//
//  YYUIAlertViewController.m
//  YYUIKit
//
//  Created by liuxc on 2021/12/2.
//

#import "YYUIAlertViewController.h"
#import "YYUIAlertController.h"
#import "YYUIAlertView.h"
#import "UIWindow+YYUIAlertView.h"
#import "YYUIAlertViewHelper.h"

@interface YYUIAlertViewController ()

@property (strong, nonatomic) YYUIAlertController *alertController;
@property (strong, nonatomic) YYUIAlertView *alertView;

@end

@implementation YYUIAlertViewController

- (instancetype)initWithAlertController:(YYUIAlertController *)alertController view:(UIView *)view {
    self = [super init];
    if (self) {
        self.alertController = alertController;

        self.view.backgroundColor = UIColor.clearColor;
        [self.view addSubview:view];
    }
    return self;
}

- (nonnull instancetype)initWithAlertView:(nonnull YYUIAlertView *)alertView view:(nonnull UIView *)view {
    self = [super init];
    if (self) {
        self.alertView = alertView;

        self.view.backgroundColor = UIColor.clearColor;
        [self.view addSubview:view];
    }
    return self;
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:coordinator.transitionDuration animations:^{
            [self setNeedsStatusBarAppearanceUpdate];
            if (self.alertController) {
                [self.alertController layoutValidateWithSize:size];
            }
            if (self.alertView) {
                [self.alertView layoutValidateWithSize:size];
            }
        }];
    });
}

#pragma mark -

- (BOOL)shouldAutorotate {
    UIViewController *viewController = YYUIAlertViewHelper.appWindow.currentViewController;

    if (viewController) {
        return viewController.shouldAutorotate;
    }

    return super.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIViewController *viewController = YYUIAlertViewHelper.appWindow.currentViewController;

    if (viewController) {
        return viewController.supportedInterfaceOrientations;
    }

    return super.supportedInterfaceOrientations;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (YYUIAlertViewHelper.isViewControllerBasedStatusBarAppearance) {
        UIViewController *viewController = YYUIAlertViewHelper.appWindow.currentViewController;

        if (viewController) {
            return viewController.preferredStatusBarStyle;
        }
    }

    return super.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    if (YYUIAlertViewHelper.isViewControllerBasedStatusBarAppearance) {
        UIViewController *viewController = YYUIAlertViewHelper.appWindow.currentViewController;

        if (viewController) {
            return viewController.prefersStatusBarHidden;
        }
    }

    return super.prefersStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    if (YYUIAlertViewHelper.isViewControllerBasedStatusBarAppearance) {
        UIViewController *viewController = YYUIAlertViewHelper.appWindow.currentViewController;

        if (viewController) {
            return viewController.preferredStatusBarUpdateAnimation;
        }
    }

    return super.preferredStatusBarUpdateAnimation;
}

@end
