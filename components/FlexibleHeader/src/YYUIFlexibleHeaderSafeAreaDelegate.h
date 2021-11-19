//
//  YYUIFlexibleHeaderSafeAreaDelegate.h
//  YYUI
//
//  Created by liuxc on 2021/11/17.
//

#import <UIKit/UIKit.h>

@class YYUIFlexibleHeaderViewController;

/**
 This delegate makes it possible to customize which ancestor view controller is used when
 inferTopSafeAreaInsetFromViewController is enabled on YYUIFlexibleHeaderViewController.
 */
@protocol YYUIFlexibleHeaderSafeAreaDelegate
- (UIViewController *_Nullable)flexibleHeaderViewControllerTopSafeAreaInsetViewController:
    (nonnull YYUIFlexibleHeaderViewController *)flexibleHeaderViewController;
@end
