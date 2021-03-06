//
//  YYUIStatusBarShifter.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/17.
//

#import "YYUIStatusBarShifter.h"

#import "YYUIStatusBarShifterDelegate.h"
#import "UIApplication+YYAdd.h"

static NSTimeInterval kStatusBarBecomesInvalidAnimationDuration = 0.2;

// If the time changes then we need to invalidate the status bar.
// This value is the minimum amount of time we'll wait before invalidating the status bar even
// after the time has changed in an effort to minimize flickering.
static NSTimeInterval kMinimumNumberOfSecondsToWaitFor = 3;

// Simple state machine for the shifter:
//          IsReal => IsSnapshot
//      IsSnapshot => IsReal, InvalidSnapshot
// InvalidSnapshot => IsReal
//
// In other words, once a snapshot becomes invalid it must go through the real state before it can
// become a snapshot again.
//
// The bulk of this state machine is represented in attemptSnapshotState:

typedef NS_ENUM(NSInteger, YYUIStatusBarShifterState) {
    YYUIStatusBarShifterStateRealStatusBar,
    YYUIStatusBarShifterStateIsSnapshot,
    YYUIStatusBarShifterStateInvalidSnapshot,
};

@implementation YYUIStatusBarShifter {
    UIView *_statusBarReplicaView;
    
    // ivars that can invalidate the status bar
    CGRect _originalStatusBarFrame;
    NSTimeInterval _replicaViewTimestamp;
    NSTimeInterval _secondsRemainingInMinute;
    NSTimer *_replicaInvalidatorTimer;
    
    // While our snapshot is invalid we have slightly different status bar visibility.
    BOOL _prefersStatusBarHiddenWhileInvalid;
    
    BOOL _isChangingInterfaceOrientation;
    
    BOOL _prefersStatusBarHidden;
    YYUIStatusBarShifterState _snapshotState;
    
    // The height of the status bar as it is before we do anything to it.
    CGFloat _originalStatusBarHeight;
}

- (void)dealloc {
    [_replicaInvalidatorTimer invalidate];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _enabled = YES;
        _snapshottingEnabled = YES;
        
        _originalStatusBarHeight = [UIApplication sharedExtensionApplication].statusBarFrame.size.height;
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(statusBarDidChangeFrame)
         name:UIApplicationDidChangeStatusBarFrameNotification
         object:nil];
    }
    return self;
}

#pragma mark - Notification

- (void)statusBarDidChangeFrame {
    CGFloat statusBarHeight = [UIApplication sharedExtensionApplication].statusBarFrame.size.height;
    _originalStatusBarHeight = statusBarHeight == 0 ? _originalStatusBarHeight : statusBarHeight;
}


#pragma mark - Private

// Moves to the invalid state with a status bar animation.
- (void)invalidateSnapshot {
    [UIView animateWithDuration:kStatusBarBecomesInvalidAnimationDuration
                     animations:^{
        [self attemptSnapshotState:YYUIStatusBarShifterStateInvalidSnapshot];
    }];
}

// Conditions in which the status bar should be invalidated.
- (BOOL)shouldInvalidateSnapshot {
    // Frames don't match up
    if (!CGRectEqualToRect(_statusBarReplicaView.frame, _originalStatusBarFrame)) {
        return YES;
    }
    
    // The time has changed
    if (([NSDate timeIntervalSinceReferenceDate] - _replicaViewTimestamp) >
        _secondsRemainingInMinute) {
        return YES;
    }
    
    return NO;
}

// May not necessarily end in the given state.
- (void)attemptSnapshotState:(YYUIStatusBarShifterState)snapshotState {
    if (_snapshotState == snapshotState) {
        // It's likely too good to be true that we're able to stay in the snapshot state, so let's see
        // if we can invalidate the snapshot in any way.
        if (_snapshotState == YYUIStatusBarShifterStateIsSnapshot && [self shouldInvalidateSnapshot]) {
            // Frame has become invalid - kill the snapshot.
            [self invalidateSnapshot];
        }
        return;
    }
    
    // Don't allow changing from invalid to snapshot without going through "real" first.
    if (_snapshotState == YYUIStatusBarShifterStateInvalidSnapshot &&
        snapshotState == YYUIStatusBarShifterStateIsSnapshot) {
        return;
    }
    
    // Can't go from real => invalid
    if (_snapshotState == YYUIStatusBarShifterStateRealStatusBar &&
        snapshotState == YYUIStatusBarShifterStateInvalidSnapshot) {
        return;
    }
    
    // While disabled, can't leave the real status bar state.
    if (!_enabled && _snapshotState == YYUIStatusBarShifterStateRealStatusBar) {
        return;
    }
    
    // If snapshotting is disabled, then can't go from real => snapshot, but must jump to invalid
    // state.
    if (!_snapshottingEnabled && _snapshotState == YYUIStatusBarShifterStateRealStatusBar &&
        snapshotState == YYUIStatusBarShifterStateIsSnapshot) {
        snapshotState = YYUIStatusBarShifterStateInvalidSnapshot;
    }
    
    // Invalidate the snapshot if our replica view is currently hidden and we're attempting to take
    // a new snapshot. This handles the case where you're running on an iPhone X in landscape, you
    // hide the header, and then rotate back to portrait. It is at this point that we want to
    // invalidate the snapshot.
    if (_isChangingInterfaceOrientation && snapshotState == YYUIStatusBarShifterStateIsSnapshot) {
        snapshotState = YYUIStatusBarShifterStateInvalidSnapshot;
    }
    
    [_replicaInvalidatorTimer invalidate];
    
    _snapshotState = snapshotState;
    
    // React to changing the state
    switch (_snapshotState) {
        case YYUIStatusBarShifterStateRealStatusBar: {
            // Now showing the real status bar. Remove the replica.
            [_statusBarReplicaView removeFromSuperview];
            _statusBarReplicaView = nil;
            self.prefersStatusBarHidden = NO;
            break;
        }
        case YYUIStatusBarShifterStateInvalidSnapshot: {
            // Snapshot is now invalid, show the real status bar.
            [_statusBarReplicaView removeFromSuperview];
            _statusBarReplicaView = nil;
            self.prefersStatusBarHidden = _prefersStatusBarHiddenWhileInvalid;
            break;
        }
        case YYUIStatusBarShifterStateIsSnapshot: {
            // Take a snapshot of the status bar.
            UIView *snapshotView = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO];
            UIView *clippingView = [[UIView alloc] init];
            CGFloat statusBarHeight =
            [UIApplication sharedExtensionApplication].statusBarFrame.size.height;
            clippingView.frame = CGRectMake(0, 0, snapshotView.frame.size.width, statusBarHeight);
            clippingView.autoresizingMask =
            (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin);
            clippingView.clipsToBounds = YES;
            [clippingView addSubview:snapshotView];
            [self.delegate statusBarShifter:self wantsSnapshotViewAdded:clippingView];
            
            _statusBarReplicaView = clippingView;
            _originalStatusBarFrame = clippingView.frame;
            _replicaViewTimestamp = [NSDate timeIntervalSinceReferenceDate];
            
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:NSCalendarUnitSecond
                                                       fromDate:[NSDate date]];
            _secondsRemainingInMinute =
            MAX(kMinimumNumberOfSecondsToWaitFor, (NSTimeInterval)(60 - components.second));
            
            _replicaInvalidatorTimer = [NSTimer timerWithTimeInterval:_secondsRemainingInMinute
                                                               target:self
                                                             selector:@selector(invalidateSnapshot)
                                                             userInfo:nil
                                                              repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:_replicaInvalidatorTimer forMode:NSRunLoopCommonModes];
            
            self.prefersStatusBarHidden = YES;
            break;
        }
    }
}

- (void)setPrefersStatusBarHidden:(BOOL)prefersStatusBarHidden {
    if (_prefersStatusBarHidden == prefersStatusBarHidden) {
        return;
    }
    
    _prefersStatusBarHidden = prefersStatusBarHidden;
    
    [self.delegate statusBarShifterNeedsStatusBarAppearanceUpdate:self];
}

#pragma mark - Public

- (void)setOffset:(CGFloat)offset {
    if (![self canUpdateStatusBarFrame]) {
        return;
    }
    
    // Bound the status bar range to [0..._originalStatusBarHeight].
    CGFloat statusOffsetY = MIN(_originalStatusBarHeight, offset);
    
    // Adjust the frame of the status bar.
    if (statusOffsetY > 0) {
        _prefersStatusBarHiddenWhileInvalid = statusOffsetY >= _originalStatusBarHeight;
        
        if (_snapshotState == YYUIStatusBarShifterStateInvalidSnapshot) {
            // If we're in an invalid state then we have to manage the visibility directly.
            [UIView animateWithDuration:kStatusBarBecomesInvalidAnimationDuration
                             animations:^{
                self.prefersStatusBarHidden = self->_prefersStatusBarHiddenWhileInvalid;
            }];
            
        } else {
            [self attemptSnapshotState:YYUIStatusBarShifterStateIsSnapshot];
        }
    } else {
        [self attemptSnapshotState:YYUIStatusBarShifterStateRealStatusBar];
    }
}

- (void)setEnabled:(BOOL)enabled {
    if (_enabled == enabled) {
        return;
    }
    _enabled = enabled;
    
    if (!_enabled) {
        [UIView animateWithDuration:kStatusBarBecomesInvalidAnimationDuration
                         animations:^{
            [self attemptSnapshotState:YYUIStatusBarShifterStateRealStatusBar];
        }];
    }
}

- (BOOL)canUpdateStatusBarFrame {
    CGRect statusBarFrame = [[UIApplication sharedExtensionApplication] statusBarFrame];
    CGFloat statusBarHeight = MIN(statusBarFrame.size.width, statusBarFrame.size.height);
    return ((statusBarHeight == _originalStatusBarHeight) || _statusBarReplicaView ||
            _snapshotState == YYUIStatusBarShifterStateInvalidSnapshot);
}

- (BOOL)prefersStatusBarHidden {
    return _prefersStatusBarHidden;
}

- (void)interfaceOrientationWillChange {
    _statusBarReplicaView.hidden = YES;
    _isChangingInterfaceOrientation = YES;
}

- (void)interfaceOrientationDidChange {
    _statusBarReplicaView.hidden = NO;
    _isChangingInterfaceOrientation = NO;
}

- (void)didMoveToWindow {
    _originalStatusBarHeight = [UIApplication sharedExtensionApplication].statusBarFrame.size.height;
}

@end

