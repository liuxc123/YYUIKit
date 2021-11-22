//
//  YYUISheetContainerView.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/22.
//

#import "YYUISheetContainerView.h"

#import "YYUISheetState.h"
#import "YYUIDraggableView.h"
#import "YYUIDraggableViewDelegate.h"
#import "YYUISheetBehavior.h"
#import "YYUISheetContainerViewDelegate.h"
#import "YYKeyboardWatcher.h"

/** KVO key for monitoring the content size for the content view if it is a scrollview. */
static NSString *kContentSizeKey = nil;
/** KVO key for monitoring the content inset for the content view if it is a scrollview. */
static NSString *kContentInsetKey = nil;
/** KVO context unique to this class. */
static void *kObservingContext = &kObservingContext;

// We add an extra padding to the sheet height, so that if the user swipes upwards, fast, the
// bounce does not reveal a gap between the sheet and the bottom of the screen.
static const CGFloat kSheetBounceBuffer = 150;

@interface YYUISheetContainerView () <YYUIDraggableViewDelegate>

@property(nonatomic) YYUISheetState sheetState;
@property(nonatomic) YYUIDraggableView *sheet;
@property(nonatomic) UIView *contentView;

@property(nonatomic) UIDynamicAnimator *animator;
@property(nonatomic) YYUISheetBehavior *sheetBehavior;
@property(nonatomic) BOOL isDragging;
@property(nonatomic) CGFloat originalPreferredSheetHeight;
@property(nonatomic) CGRect previousAnimatedBounds;
@property(nonatomic) BOOL simulateScrollViewBounce;

@end

@implementation YYUISheetContainerView

+ (void)initialize {
  if (self != [YYUISheetContainerView class]) {
    return;
  }
  kContentSizeKey = NSStringFromSelector(@selector(contentSize));
  kContentInsetKey = NSStringFromSelector(@selector(contentInset));
}

- (instancetype)initWithFrame:(CGRect)frame
                  contentView:(UIView *)contentView
                   scrollView:(UIScrollView *)scrollView
     simulateScrollViewBounce:(BOOL)simulateScrollViewBounce {
  self = [super initWithFrame:frame];
  if (self) {
    _willBeDismissed = NO;
    _ignoreKeyboardHeight = NO;
    _simulateScrollViewBounce = simulateScrollViewBounce;
    if (UIAccessibilityIsVoiceOverRunning()) {
      _sheetState = YYUISheetStateExtended;
    } else {
      _sheetState = YYUISheetStatePreferred;
    }

    // Don't set the frame yet because we're going to change the anchor point.
    _sheet = [[YYUIDraggableView alloc] initWithFrame:CGRectZero scrollView:scrollView];
    _sheet.simulateScrollViewBounce = _simulateScrollViewBounce;
    _sheet.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _sheet.delegate = self;
    _sheet.backgroundColor = contentView.backgroundColor;

    // Adjust the anchor point so all positions relate to the top edge rather than the actual
    // center.
    _sheet.layer.anchorPoint = CGPointMake((CGFloat)0.5, 0);
    _sheet.frame = self.bounds;

    _contentView = contentView;
    _contentView.autoresizingMask =
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [_sheet addSubview:_contentView];
    [self addSubview:_sheet];

    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];

    [scrollView addObserver:self
                 forKeyPath:kContentSizeKey
                    options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                    context:kObservingContext];
    [scrollView addObserver:self
                 forKeyPath:kContentInsetKey
                    options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                    context:kObservingContext];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(voiceOverStatusDidChange)
                                                 name:UIAccessibilityVoiceOverStatusChanged
                                               object:nil];

    // Add the keyboard notifications.
    NSArray *notificationNames = @[
      YYUIKeyboardWatcherKeyboardWillShowNotification,
      YYUIKeyboardWatcherKeyboardWillHideNotification,
      YYUIKeyboardWatcherKeyboardWillChangeFrameNotification
    ];

    for (NSString *name in notificationNames) {
      [[NSNotificationCenter defaultCenter]
          addObserver:self
             selector:@selector(keyboardStateChangedWithNotification:)
                 name:name
               object:nil];
    }

    // Since we handle the SafeAreaInsets ourselves through the contentInset property, we disable
    // the adjustment behavior to prevent accounting for it twice.
    if (@available(iOS 11.0, *)) {
      scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    scrollView.preservesSuperviewLayoutMargins = YES;
  }
  return self;
}

- (void)dealloc {
  [self.sheet.scrollView removeObserver:self forKeyPath:kContentSizeKey];
  [self.sheet.scrollView removeObserver:self forKeyPath:kContentInsetKey];
}

- (void)voiceOverStatusDidChange {
  if (self.window && UIAccessibilityIsVoiceOverRunning()) {
    // Adjust the sheet height as necessary for VO.
    [self animatePaneWithInitialVelocity:CGPointZero];
  }
  [self updateSheetState];
}

#pragma mark UIView

- (void)didMoveToWindow {
  [super didMoveToWindow];
  if (self.window) {
    if (!self.sheetBehavior) {
      self.sheetBehavior = [[YYUISheetBehavior alloc] initWithItem:self.sheet
                                         simulateScrollViewBounce:self.simulateScrollViewBounce];
    }
    [self animatePaneWithInitialVelocity:CGPointZero];
  } else {
    [self.animator removeAllBehaviors];
    self.sheetBehavior = nil;
  }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
  [super traitCollectionDidChange:previousTraitCollection];

  if (self.traitCollection.verticalSizeClass == previousTraitCollection.verticalSizeClass) {
    return;
  }

  [self updateSheetFrame];
}

- (void)safeAreaInsetsDidChange {
  if (@available(iOS 11.0, *)) {
    [super safeAreaInsetsDidChange];

    if (self.adjustHeightForSafeAreaInsets) {
      _preferredSheetHeight = self.originalPreferredSheetHeight + self.safeAreaInsets.bottom;

      UIEdgeInsets contentInset = self.sheet.scrollView.contentInset;
      contentInset.bottom = MAX(contentInset.bottom, self.safeAreaInsets.bottom);
      self.sheet.scrollView.contentInset = contentInset;
    }
    CGRect scrollViewFrame = CGRectStandardize(self.sheet.scrollView.frame);
    scrollViewFrame.size = CGSizeMake(scrollViewFrame.size.width, CGRectGetHeight(self.frame));
    self.sheet.scrollView.frame = scrollViewFrame;

    // Note this is needed to make sure the full displayed frame updates to reflect the new safe
    // area insets after rotation. See b/183357841 for context.
    [self updateSheetFrame];
  }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  // As long as this class added the KVO observation, it doesn't matter which of the two properties
  // has been updated. A change in either warrants repositioning the sheet.
  // If contentSize was updated, then there's likely more or less content to see so it's worth
  // repositioning.  If contentInset was updated, then the visible content has changed and the
  // sheet should reposition to keep it visible.
  // Notably, ActionSheet changes contentInset when it calculates its header height. If contentInset
  // were not observed, then the sheet wouldn't be able to fully show the contentSize portion of
  // that view.
  if (context == kObservingContext) {
    NSValue *oldValue = change[NSKeyValueChangeOldKey];
    NSValue *newValue = change[NSKeyValueChangeNewKey];
    if (self.window && !self.isDragging && ![oldValue isEqual:newValue]) {
      [self animatePaneWithInitialVelocity:CGPointZero];
    }
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

#pragma mark - Layout

- (void)layoutSubviews {
  [super layoutSubviews];
  if (!CGRectEqualToRect(self.bounds, self.previousAnimatedBounds) && self.window) {
    // Adjusts the pane to the correct snap point if we are visible.
    [self animatePaneWithInitialVelocity:CGPointZero];
  }
}

- (void)updateSheetHeight {
  CGFloat adjustedPreferredSheetHeight = self.originalPreferredSheetHeight;
  if (@available(iOS 11.0, *)) {
    if (self.adjustHeightForSafeAreaInsets) {
      adjustedPreferredSheetHeight += self.safeAreaInsets.bottom;
    }
  }

  if (_preferredSheetHeight == adjustedPreferredSheetHeight) {
    return;
  }
  _preferredSheetHeight = adjustedPreferredSheetHeight;

  [self updateSheetFrame];
}

- (void)setPreferredSheetHeight:(CGFloat)preferredSheetHeight {
  self.originalPreferredSheetHeight = preferredSheetHeight;
  [self updateSheetHeight];
}

- (void)setAdjustHeightForSafeAreaInsets:(BOOL)adjustHeightForSafeAreaInsets {
  _adjustHeightForSafeAreaInsets = adjustHeightForSafeAreaInsets;
  [self updateSheetHeight];
}

// Slides the sheet position downwards, so the right amount peeks above the bottom of the superview.
- (void)updateSheetFrame {
  [self.animator removeAllBehaviors];

  CGRect sheetRect = self.bounds;
  sheetRect.origin.y = CGRectGetMaxY(self.bounds) - [self effectiveSheetHeight];
  sheetRect.size.height += kSheetBounceBuffer;

  self.sheet.frame = sheetRect;

  CGRect contentFrame = self.sheet.bounds;
  contentFrame.size.height -= kSheetBounceBuffer;
  if (!self.sheet.scrollView) {
    // If the content doesn't scroll then we have to set its frame to the size we are making
    // visible. This ensures content using autolayout lays out correctly.
    contentFrame.size.height = [self effectiveSheetHeight];
  }
  self.contentView.frame = contentFrame;

  // Adjusts the pane to the correct snap point, e.g. after a rotation.
  if (self.window) {
    [self animatePaneWithInitialVelocity:CGPointZero];
  }
}

- (void)updateSheetState {
  if (UIAccessibilityIsVoiceOverRunning()) {
    // Always return the full height when VO is running, so that the entire content is on-screen
    // and accessibile.
    self.sheetState = YYUISheetStateExtended;
  } else {
    CGFloat currentSheetHeight = CGRectGetMaxY(self.bounds) - CGRectGetMinY(self.sheet.frame);
    self.sheetState = (currentSheetHeight >= [self maximumSheetHeight] ? YYUISheetStateExtended
                                                                       : YYUISheetStatePreferred);
  }
}

// Returns |preferredSheetHeight|, modified as necessary. It will return the full screen height if
// the content height is taller than the sheet height and the vertical size class is `.compact`.
// Otherwise, it will return `preferredSheetHeight`, assuming it's shorter than the sheet height.
- (CGFloat)effectiveSheetHeight {
  CGFloat maxSheetHeight = [self maximumSheetHeight];
  BOOL contentIsTallerThanMaxSheetHeight = [self scrollViewContentHeight] > maxSheetHeight;
  BOOL isVerticallyCompact =
      self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact;
  if (contentIsTallerThanMaxSheetHeight && isVerticallyCompact) {
    return maxSheetHeight;
  } else {
    return MIN(self.preferredSheetHeight, maxSheetHeight);
  }
}

- (CGFloat)scrollViewContentHeight {
  return self.sheet.scrollView.contentInset.top + self.sheet.scrollView.contentSize.height +
         self.sheet.scrollView.contentInset.bottom;
}

// Returns the maximum allowable height that the sheet can be dragged to.
- (CGFloat)maximumSheetHeight {
  CGFloat boundsHeight = CGRectGetHeight(self.bounds);
  if (@available(iOS 11.0, *)) {
    boundsHeight -= self.safeAreaInsets.top;
  }
  // If we have a scrollview, the sheet should never get taller than its content height.
  CGFloat contentHeight = [self scrollViewContentHeight];
  if (contentHeight > 0) {
    return MIN(boundsHeight, contentHeight);
  } else {
    return MIN(boundsHeight, self.preferredSheetHeight);
  }
}

#pragma mark - Gesture-driven animation

- (void)animatePaneWithInitialVelocity:(CGPoint)initialVelocity {
  self.previousAnimatedBounds = self.bounds;
  self.sheetBehavior.targetPoint = [self targetPoint];
  self.sheetBehavior.velocity = initialVelocity;
  __weak YYUISheetContainerView *weakSelf = self;
  self.sheetBehavior.action = ^{
    [weakSelf sheetBehaviorDidUpdate];
  };
  [self.animator addBehavior:self.sheetBehavior];
}

// Calculates the snap-point for the view to spring to.
- (CGPoint)targetPoint {
  CGRect bounds = self.bounds;
  CGFloat midX = CGRectGetMidX(bounds);
  CGFloat bottomY = CGRectGetMaxY(bounds);
  if (!self.ignoreKeyboardHeight) {
    CGFloat keyboardOffset = [YYUIKeyboardWatcher sharedKeyboardWatcher].visibleKeyboardHeight;
    bottomY -= keyboardOffset;
  }

  CGPoint targetPoint;
  switch (self.sheetState) {
    case YYUISheetStatePreferred:
      targetPoint = CGPointMake(midX, bottomY - [self effectiveSheetHeight]);
      break;
    case YYUISheetStateExtended:
      targetPoint = CGPointMake(midX, bottomY - [self maximumSheetHeight]);
      break;
    case YYUISheetStateClosed:
      targetPoint = CGPointMake(midX, bottomY);
      break;
  }
  [self.delegate sheetContainerViewDidChangeYOffset:self yOffset:targetPoint.y];
  return targetPoint;
}

- (void)sheetBehaviorDidUpdate {
  // If sheet has been dragged off the bottom, we can trigger a dismiss.
  if (self.sheetState == YYUISheetStateClosed &&
      CGRectGetMinY(self.sheet.frame) > CGRectGetMaxY(self.bounds)) {
    [self.delegate sheetContainerViewDidHide:self];

    [self.animator removeAllBehaviors];

    // Reset the state to preferred once we are dismissed.
    self.sheetState = YYUISheetStatePreferred;
  }
}

#pragma mark - Notifications

- (void)keyboardStateChangedWithNotification:(__unused NSNotification *)notification {
  if (self.window) {
    // Only add animation if the view is not set to be dismissed with the new keyboard. Otherwise,
    // the view will first adjust height to fit above the keyboard and then dismiss, which appears
    // glitchy on the screen.
    if (!self.willBeDismissed) {
      [self animatePaneWithInitialVelocity:CGPointZero];
    }
  }
}

#pragma mark - YYUIDraggableViewDelegate

- (CGFloat)maximumHeightForDraggableView:(__unused YYUIDraggableView *)view {
  return [self maximumSheetHeight];
}

- (BOOL)draggableView:(__unused YYUIDraggableView *)view
    shouldBeginDraggingWithVelocity:(CGPoint)velocity {
  [self updateSheetState];

  switch (self.sheetState) {
    case YYUISheetStatePreferred:
      return YES;
    case YYUISheetStateExtended: {
      UIScrollView *scrollView = self.sheet.scrollView;
      if (scrollView) {
        BOOL draggingDown = (velocity.y >= 0);
        // Only allow dragging down if we are scrolled to the top.
        if (scrollView.contentOffset.y <= -scrollView.contentInset.top && draggingDown) {
          return YES;
        } else {
          // Allow dragging in any direction if the content is not scrollable.
          CGFloat contentHeight = scrollView.contentInset.top + scrollView.contentSize.height +
                                  scrollView.contentInset.bottom;
          return (CGRectGetHeight(scrollView.bounds) >= contentHeight);
        }
      }
      return YES;
    }
    case YYUISheetStateClosed:
      return NO;
  }
}

- (void)draggableView:(__unused YYUIDraggableView *)view
    draggingEndedWithVelocity:(CGPoint)velocity {
  YYUISheetState targetState;
  if (self.preferredSheetHeight == [self maximumSheetHeight]) {
    // Cannot be extended, only closed.
    targetState = ((velocity.y > 0 && self.dismissOnDraggingDownSheet) ? YYUISheetStateClosed
                                                                       : YYUISheetStatePreferred);
  } else {
    CGFloat currentSheetHeight = CGRectGetMaxY(self.bounds) - CGRectGetMinY(self.sheet.frame);
    if (currentSheetHeight >= self.preferredSheetHeight) {
      targetState = (velocity.y > 0 ? YYUISheetStatePreferred : YYUISheetStateExtended);
    } else {
      targetState = ((velocity.y > 0 && self.dismissOnDraggingDownSheet) ? YYUISheetStateClosed
                                                                         : YYUISheetStatePreferred);
    }
  }
  self.isDragging = NO;
  self.sheetState = targetState;
  [self animatePaneWithInitialVelocity:velocity];
}

- (void)draggableViewBeganDragging:(__unused YYUIDraggableView *)view {
  [self.animator removeAllBehaviors];
  self.isDragging = YES;
}

- (void)draggableView:(nonnull YYUIDraggableView *)view didPanToOffset:(CGFloat)offset {
  [self.delegate sheetContainerViewDidChangeYOffset:self yOffset:offset];
}

- (void)setSheetState:(YYUISheetState)sheetState {
  if (sheetState != _sheetState) {
    _sheetState = sheetState;
    [self.delegate sheetContainerViewWillChangeState:self sheetState:sheetState];
  }
}

@end

