//
//  YYUIStatusBarShifterDelegate.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/17.
//

#import <UIKit/UIKit.h>

@class YYUIStatusBarShifter;

/**
 The YYUIStatusBarShifterDelegate protocol allows a delegate to react to changes in the status bar
 shifter's state.
 */
@protocol YYUIStatusBarShifterDelegate <NSObject>
@required
     
/** Informs the receiver that the preferred status bar visibility has changed. */
- (void)statusBarShifterNeedsStatusBarAppearanceUpdate:(YYUIStatusBarShifter *)statusBarShifter;

/**
 Informs the receiver that a snapshot view would like to be added to a view hierarchy.
 
 The receiver is expected to add `view` as a subview. The superview should be shifting off-screen,
 which will cause the snapshot view to shift off-screen as well.
 */
- (void)statusBarShifter:(YYUIStatusBarShifter *)statusBarShifter
  wantsSnapshotViewAdded:(UIView *)view;

@end
