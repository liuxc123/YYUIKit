//
//  UIWindow+YYUIAlertView.m
//  YYUIKit
//
//  Created by liuxc on 2021/12/2.
//

#import "UIWindow+YYUIAlertView.h"

@implementation UIWindow (YYUIAlertView)

- (nullable UIViewController *)currentViewController {
    UIViewController *viewController = self.rootViewController;

    if (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }

    return viewController;
}

@end
