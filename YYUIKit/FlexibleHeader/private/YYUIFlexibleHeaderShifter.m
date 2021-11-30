//
//  YYUIFlexibleHeaderShifter.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/17.
//

#import "YYUIFlexibleHeaderShifter.h"
#import "YYUIFlexibleHeaderView+ShiftBehavior.h"
#import "YYUIFlexibleHeaderShiftBehavior.h"
#import "YYUIFlexibleHeaderShiftBehaviorEnabledWithStatusBar.h"

// The suffix for an app extension bundle path.
static NSString *const kAppExtensionSuffix = @".appex";

@implementation YYUIFlexibleHeaderShifter

- (instancetype)init {
    self = [super init];
    if (self) {
        _behavior = YYUIFlexibleHeaderShiftBehaviorDisabled;
    }
    return self;
}

#pragma mark - Behavior

- (BOOL)hidesStatusBarWhenShiftedOffscreen {
    BOOL behaviorWantsStatusBarHidden =
    self.behavior == YYUIFlexibleHeaderShiftBehaviorEnabledWithStatusBar ||
    self.behavior == YYUIFlexibleHeaderShiftBehaviorHideable;
    return behaviorWantsStatusBarHidden && !self.trackingScrollView.pagingEnabled;
}

+ (YYUIFlexibleHeaderShiftBehavior)behaviorForCurrentContextFromBehavior:(YYUIFlexibleHeaderShiftBehavior)behavior {
    // In app extensions we do not allow shifting with the status bar.
    if ([[[NSBundle mainBundle] bundlePath] hasSuffix:kAppExtensionSuffix] &&
        behavior == YYUIFlexibleHeaderShiftBehaviorEnabledWithStatusBar) {
        return YYUIFlexibleHeaderShiftBehaviorEnabled;
    }
    return behavior;
}

@end

