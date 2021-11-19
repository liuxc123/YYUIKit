//
//  YYUIFlexibleHeaderShifter.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/17.
//

#import "YYUIFlexibleHeaderView+ShiftBehavior.h"

#import <Foundation/Foundation.h>

/**
 The flexible header shifter is responsibile for vertical movement of the YYUIFlexibleHeaderView.
 */
__attribute__((objc_subclassing_restricted)) @interface YYUIFlexibleHeaderShifter : NSObject

#pragma mark - Tracking scroll view

/**
 The scroll view whose content offset affects the shift behavior of the flexible header.

 The tracking scroll view is weakly held so that we don't unintentionally keep the scroll view
 around any longer than it needs to be. Doing so could get into tricky situations where the view
 controller didn't nil out the scroll view's delegate in dealloc and UIScrollView's non-weak
 delegate points to a dead object.
 */
@property(nonatomic, weak, nullable) UIScrollView *trackingScrollView;

#pragma mark - Behavior

/**
 The behavior of the header's vertical movement.

 Default: YYUIFlexibleHeaderShiftBehaviorDisabled
 */
@property(nonatomic) YYUIFlexibleHeaderShiftBehavior behavior;

/**
 Returns a valid behavior for the current application context.

 Not all behaviors are usable in all application contexts. In app extensions, for example, it is not
 possible to adjust the status bar's positioning. This method should be used to adjust a desired
 behavior to the current context's supported behaviors.

 @param behavior The shift behavior that was originally desired.
 @returns If the code is running in an app extension, then
 YYUIFlexibleHeaderShiftBehaviorEnabledWithStatusBar will be returned as
 YYUIFlexibleHeaderShiftBehaviorEnabled. In all other contexts, @c behavior is returned unmodified.
 */
+ (YYUIFlexibleHeaderShiftBehavior)behaviorForCurrentContextFromBehavior:
    (YYUIFlexibleHeaderShiftBehavior)behavior;

/**
 Returns YES if the shifter will also hide the status bar when the header is shifting off-screen;
 returns NO otherwise.
 */
- (BOOL)hidesStatusBarWhenShiftedOffscreen;

@end

