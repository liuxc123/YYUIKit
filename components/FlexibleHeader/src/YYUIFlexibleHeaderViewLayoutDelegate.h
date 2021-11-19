//
//  YYUIFlexibleHeaderViewLayoutDelegate.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/17.
//

#import <UIKit/UIKit.h>

@class YYUIFlexibleHeaderView;
@class YYUIFlexibleHeaderViewController;

/**
 An object may conform to this protocol in order to receive layout change events caused by a
 YYUIFlexibleHeaderView.
 */
@protocol YYUIFlexibleHeaderViewLayoutDelegate <NSObject>
@required

/**
 Informs the receiver that the flexible header view's frame has changed.

 The receiver should use the YYUIFlexibleHeader scrollPhase APIs in order to react to the frame
 changes.
 */
- (void)flexibleHeaderViewController:
            (nonnull YYUIFlexibleHeaderViewController *)flexibleHeaderViewController
    flexibleHeaderViewFrameDidChange:(nonnull YYUIFlexibleHeaderView *)flexibleHeaderView;

@end
