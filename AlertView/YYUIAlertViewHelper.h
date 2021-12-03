//
//  YYUIAlertViewHelper.h
//  YYUIKit
//
//  Created by liuxc on 2021/12/2.
//

#import <UIKit/UIKit.h>

@class YYUIAlertView;
@class YYUIAlertController;

#pragma mark - Constants

extern CGFloat const YYUIAlertViewPaddingWidth;
extern CGFloat const YYUIAlertViewPaddingHeight;
extern CGFloat const YYUIAlertViewButtonImageOffsetFromTitle;

@interface YYUIAlertViewHelper : UIView

+ (void)animateWithDuration:(NSTimeInterval)duration
                 animations:(void(^)(void))animations
                 completion:(void(^)(BOOL finished))completion;

+ (void)keyboardAnimateWithNotificationUserInfo:(NSDictionary *)notificationUserInfo
                                     animations:(void(^)(CGFloat keyboardHeight))animations;

+ (UIImage *)image1x1WithColor:(UIColor *)color;

+ (BOOL)isNotRetina;

+ (BOOL)isPad;

+ (CGFloat)statusBarHeight;

+ (CGFloat)separatorHeight;

+ (BOOL)isPadAndNotForceForAlertView:(YYUIAlertView *)alertView;
+ (BOOL)isPadAndNotForceForAlertController:(YYUIAlertController *)alertController;

+ (BOOL)isCancelButtonSeparateForAlertView:(YYUIAlertView *)alertView;
+ (BOOL)isCancelButtonSeparateForAlertController:(YYUIAlertController *)alertController;

+ (CGFloat)systemVersion;

#if TARGET_OS_IOS
+ (UIWindow *)appWindow;
+ (UIWindow *)keyWindow;
#endif

+ (BOOL)isViewControllerBasedStatusBarAppearance;

@end


