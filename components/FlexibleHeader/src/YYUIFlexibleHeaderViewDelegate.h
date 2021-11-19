//
//  YYUIFlexibleHeaderViewDelegate.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/17.
//

#import <UIKit/UIKit.h>

@class YYUIFlexibleHeaderView;

/**
 The YYUIFlexibleHeaderViewDelegate protocol allows a delegate to respond to changes in the header
 view's state.

 The delegate is typically the UIViewController that owns this flexible header view.
 */
@protocol YYUIFlexibleHeaderViewDelegate <NSObject>
@required

/**
 Informs the receiver that the flexible header view's preferred status bar visibility has changed.
 */
- (void)flexibleHeaderViewNeedsStatusBarAppearanceUpdate:
    (nonnull YYUIFlexibleHeaderView *)headerView;

/**
 Informs the receiver that the flexible header view's frame has changed.

 The frame may change in response to scroll events of the tracking scroll view. The receiver
 should use the YYUIFlexibleHeaderView scrollPhase APIs to determine which phase the header's frame
 is in.
 */
- (void)flexibleHeaderViewFrameDidChange:(nonnull YYUIFlexibleHeaderView *)headerView;

@end
