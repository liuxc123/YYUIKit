//
//  YYUIFlexibleHeaderViewAnimationDelegate.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/17.
//

#import <UIKit/UIKit.h>

@class YYUIFlexibleHeaderView;

/**
 An object may conform to this protocol in order to receive animation events caused by a
 YYUIFlexibleHeaderView.
 */
@protocol YYUIFlexibleHeaderViewAnimationDelegate <NSObject>
@optional

/**
 Informs the receiver that the flexible header view's tracking scroll view has changed.

 @param animated If YES, then this method is being invoked from within an animation block. Changes
 made to the flexible header as a result of this invocation will be animated alongside the header's
 animation.
 */
- (void)flexibleHeaderView:(nonnull YYUIFlexibleHeaderView *)flexibleHeaderView
    didChangeTrackingScrollViewAnimated:(BOOL)animated;

/**
 Informs the receiver that the flexible header view's animation changing to a new tracking scroll
 view has completed.

 Only invoked if an animation occurred when the tracking scroll view was changed.
 */
- (void)flexibleHeaderViewChangeTrackingScrollViewAnimationDidComplete:
    (nonnull YYUIFlexibleHeaderView *)flexibleHeaderView;

@end
