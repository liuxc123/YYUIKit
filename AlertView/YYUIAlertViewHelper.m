//
//  YYUIAlertViewHelper.m
//  YYUIKit
//
//  Created by liuxc on 2021/12/2.
//

#import "YYUIAlertViewHelper.h"
#import "YYUIAlertController.h"
#import "YYUIAlertView.h"

#pragma mark - Constants

CGFloat const YYUIAlertViewPaddingWidth = 10.0;
CGFloat const YYUIAlertViewPaddingHeight = 8.0;
CGFloat const YYUIAlertViewButtonImageOffsetFromTitle = 8.0;

@implementation YYUIAlertViewHelper

+ (void)animateWithDuration:(NSTimeInterval)duration
                 animations:(void(^)(void))animations
                 completion:(void(^)(BOOL finished))completion {
    [UIView animateWithDuration:duration
                          delay:0.0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.5
                        options:0
                     animations:animations
                     completion:completion];
}

+ (void)keyboardAnimateWithNotificationUserInfo:(NSDictionary *)notificationUserInfo
                                     animations:(void(^)(CGFloat keyboardHeight))animations {
    CGFloat keyboardHeight = (notificationUserInfo[UIKeyboardFrameEndUserInfoKey] ? CGRectGetHeight([notificationUserInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue]) : 0.0);

    if (!keyboardHeight) return;

    NSTimeInterval animationDuration = [notificationUserInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    int animationCurve = [notificationUserInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];

    if (animations) {
        animations(keyboardHeight);
    }

    [UIView commitAnimations];
}

+ (UIImage *)image1x1WithColor:(UIColor *)color {
    if (!color) return nil;

    CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);

    UIGraphicsBeginImageContext(rect.size);

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

+ (BOOL)isNotRetina {
    static BOOL isNotRetina;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        isNotRetina = (UIScreen.mainScreen.scale == 1.0);
    });

    return isNotRetina;
}

+ (BOOL)isPad {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+ (CGFloat)statusBarHeight {
#if TARGET_OS_IOS
    UIApplication *sharedApplication = [UIApplication sharedApplication];
    return sharedApplication.isStatusBarHidden ? 0.0 : CGRectGetHeight(sharedApplication.statusBarFrame);
#else
    return 0;
#endif
}

+ (CGFloat)separatorHeight {
    return self.isNotRetina ? 1.0 : 0.5;
}

+ (BOOL)isPadAndNotForceForAlertView:(YYUIAlertView *)alertView {
    return self.isPad && !alertView.isPadShowsActionSheetFromBottom;
}

+ (BOOL)isPadAndNotForceForAlertController:(YYUIAlertController *)alertController {
    return self.isPad && !alertController.isPadShowsActionSheetFromBottom;
}

+ (BOOL)isCancelButtonSeparateForAlertView:(YYUIAlertView *)alertView {
    return alertView.style == YYUIAlertViewStyleActionSheet && alertView.cancelButtonOffsetY != NSNotFound && alertView.cancelButtonOffsetY > 0.0 && ![self isPadAndNotForceForAlertView:alertView];
}

+ (BOOL)isCancelButtonSeparateForAlertController:(YYUIAlertController *)alertController {
    return alertController.preferredStyle == YYUIAlertControllerStyleActionSheet && alertController.cancelButtonOffsetY != NSNotFound && alertController.cancelButtonOffsetY > 0.0 && ![self isPadAndNotForceForAlertController:alertController];
}

+ (CGFloat)systemVersion {
    return [UIDevice currentDevice].systemVersion.floatValue;
}

#if TARGET_OS_IOS
+ (UIWindow *)appWindow {
    return [UIApplication sharedApplication].windows[0];
}

+ (UIWindow *)keyWindow {
    return [UIApplication sharedApplication].keyWindow;
}
#endif

+ (BOOL)isViewControllerBasedStatusBarAppearance {
    static BOOL isViewControllerBasedStatusBarAppearance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        if (UIDevice.currentDevice.systemVersion.floatValue >= 9.0) {
            isViewControllerBasedStatusBarAppearance = YES;
        }
        else {
            NSNumber *viewControllerBasedStatusBarAppearance = [NSBundle.mainBundle objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"];
            isViewControllerBasedStatusBarAppearance = (viewControllerBasedStatusBarAppearance == nil ? YES : viewControllerBasedStatusBarAppearance.boolValue);
        }
    });

    return isViewControllerBasedStatusBarAppearance;
}

@end
