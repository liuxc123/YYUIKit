//
//  YYUITips.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/4.
//

#import "YYUITips.h"
#import "YYUIToastContentView.h"
#import "YYUIToastBackgroundView.h"
#import "YYResource.h"

const NSInteger YYUITipsAutomaticallyHideToastSeconds = -1;

@interface YYUITips ()

@property(nonatomic, strong) UIView *contentCustomView;

@end

@implementation YYUITips

- (void)showLoading {
    [self showLoading:nil hideAfterDelay:0];
}

- (void)showLoadingHideAfterDelay:(NSTimeInterval)delay {
    [self showLoading:nil hideAfterDelay:delay];
}

- (void)showLoading:(NSString *)text {
    [self showLoading:text hideAfterDelay:0];
}

- (void)showLoading:(NSString *)text hideAfterDelay:(NSTimeInterval)delay {
    [self showLoading:text detailText:nil hideAfterDelay:delay];
}

- (void)showLoading:(NSString *)text detailText:(NSString *)detailText {
    [self showLoading:text detailText:detailText hideAfterDelay:0];
}

- (void)showLoading:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicator startAnimating];
    self.contentCustomView = indicator;
    [self showTipWithText:text detailText:detailText hideAfterDelay:delay];
}

- (void)showWithText:(NSString *)text {
    [self showWithText:text detailText:nil hideAfterDelay:0];
}

- (void)showWithText:(NSString *)text hideAfterDelay:(NSTimeInterval)delay {
    [self showWithText:text detailText:nil hideAfterDelay:delay];
}

- (void)showWithText:(NSString *)text detailText:(NSString *)detailText {
    [self showWithText:text detailText:detailText hideAfterDelay:0];
}

- (void)showWithText:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay {
    self.contentCustomView = nil;
    [self showTipWithText:text detailText:detailText hideAfterDelay:delay];
}

- (void)showSucceed:(NSString *)text {
    [self showSucceed:text detailText:nil hideAfterDelay:0];
}

- (void)showSucceed:(NSString *)text hideAfterDelay:(NSTimeInterval)delay {
    [self showSucceed:text detailText:nil hideAfterDelay:delay];
}

- (void)showSucceed:(NSString *)text detailText:(NSString *)detailText {
    [self showSucceed:text detailText:detailText hideAfterDelay:0];
}

- (void)showSucceed:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay {
    self.contentCustomView = [[UIImageView alloc] initWithImage:[[YYUIResource imageWithName:@"ic_tips_done"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self showTipWithText:text detailText:detailText hideAfterDelay:delay];
}

- (void)showError:(NSString *)text {
    [self showError:text detailText:nil hideAfterDelay:0];
}

- (void)showError:(NSString *)text hideAfterDelay:(NSTimeInterval)delay {
    [self showError:text detailText:nil hideAfterDelay:delay];
}

- (void)showError:(NSString *)text detailText:(NSString *)detailText {
    [self showError:text detailText:detailText hideAfterDelay:0];
}

- (void)showError:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay {
    self.contentCustomView = [[UIImageView alloc] initWithImage:[[YYUIResource imageWithName:@"ic_tips_error"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self showTipWithText:text detailText:detailText hideAfterDelay:delay];
}

- (void)showInfo:(NSString *)text {
    [self showInfo:text detailText:nil hideAfterDelay:0];
}

- (void)showInfo:(NSString *)text hideAfterDelay:(NSTimeInterval)delay {
    [self showInfo:text detailText:nil hideAfterDelay:delay];
}

- (void)showInfo:(NSString *)text detailText:(NSString *)detailText {
    [self showInfo:text detailText:detailText hideAfterDelay:0];
}

- (void)showInfo:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay {
    self.contentCustomView = [[UIImageView alloc] initWithImage:[[YYUIResource imageWithName:@"ic_tips_info"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self showTipWithText:text detailText:detailText hideAfterDelay:delay];
}

- (void)showTipWithText:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay {
    
    YYUIToastContentView *contentView = (YYUIToastContentView *)self.contentView;
    contentView.customView = self.contentCustomView;
    
    contentView.textLabelText = text ?: @"";
    contentView.detailTextLabelText = detailText ?: @"";
    
    [self showAnimated:YES];
    
    if (delay == YYUITipsAutomaticallyHideToastSeconds) {
        [self hideAnimated:YES afterDelay:[YYUITips smartDelaySecondsForTipsText:text]];
    } else if (delay > 0) {
        [self hideAnimated:YES afterDelay:delay];
    }
    
    [self postAccessibilityAnnouncement:text detailText:detailText];
}

- (void)postAccessibilityAnnouncement:(NSString *)text detailText:(NSString *)detailText {
    NSString *announcementString = nil;
    if (text) {
        announcementString = text;
    }
    if (detailText) {
        announcementString = announcementString ? [text stringByAppendingFormat:@", %@", detailText] : detailText;
    }
    if (announcementString) {
        // 发送一个让VoiceOver播报的Announcement，帮助视障用户获取toast内的信息，但是这个播报会被即时打断而不生效，所以在这里延时1秒发送此通知。
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, announcementString);
        });
    }
}

+ (NSTimeInterval)smartDelaySecondsForTipsText:(NSString *)text {
    // 按照中文 2 个字符、英文 1 个字符的方式来计算文本长度
    NSUInteger length = 0;
    for (NSUInteger i = 0, l = text.length; i < l; i++) {
        unichar character = [text characterAtIndex:i];
        if (isascii(character)) {
            length += 1;
        } else {
            length += 2;
        }
    }
    
    if (length <= 20) {
        return 1.5;
    } else if (length <= 40) {
        return 2.0;
    } else if (length <= 50) {
        return 2.5;
    } else {
        return 3.0;
    }
}

+ (YYUITips *)showLoadingInView:(UIView *)view {
    return [self showLoading:nil detailText:nil inView:view hideAfterDelay:0];
}

+ (YYUITips *)showLoading:(NSString *)text inView:(UIView *)view {
    return [self showLoading:text detailText:nil inView:view hideAfterDelay:0];
}

+ (YYUITips *)showLoadingInView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    return [self showLoading:nil detailText:nil inView:view hideAfterDelay:delay];
}

+ (YYUITips *)showLoading:(NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    return [self showLoading:text detailText:nil inView:view hideAfterDelay:delay];
}

+ (YYUITips *)showLoading:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view {
    return [self showLoading:text detailText:detailText inView:view hideAfterDelay:0];
}

+ (YYUITips *)showLoading:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    YYUITips *tips = [self createTipsToView:view];
    [tips showLoading:text detailText:detailText hideAfterDelay:delay];
    return tips;
}

+ (YYUITips *)showWithText:(nullable NSString *)text {
    return [self showWithText:text detailText:nil inView:DefaultTipsParentView hideAfterDelay:YYUITipsAutomaticallyHideToastSeconds];
}

+ (YYUITips *)showWithText:(nullable NSString *)text detailText:(nullable NSString *)detailText {
    return [self showWithText:text detailText:detailText inView:DefaultTipsParentView hideAfterDelay:YYUITipsAutomaticallyHideToastSeconds];
}

+ (YYUITips *)showWithText:(NSString *)text inView:(UIView *)view {
    return [self showWithText:text detailText:nil inView:view hideAfterDelay:YYUITipsAutomaticallyHideToastSeconds];
}

+ (YYUITips *)showWithText:(NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    return [self showWithText:text detailText:nil inView:view hideAfterDelay:delay];
}

+ (YYUITips *)showWithText:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view {
    return [self showWithText:text detailText:detailText inView:view hideAfterDelay:YYUITipsAutomaticallyHideToastSeconds];
}

+ (YYUITips *)showWithText:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    YYUITips *tips = [self createTipsToView:view];
    [tips showWithText:text detailText:detailText hideAfterDelay:delay];
    return tips;
}

+ (YYUITips *)showSucceed:(nullable NSString *)text {
    return [self showSucceed:text detailText:nil inView:DefaultTipsParentView hideAfterDelay:YYUITipsAutomaticallyHideToastSeconds];
}

+ (YYUITips *)showSucceed:(nullable NSString *)text detailText:(nullable NSString *)detailText {
    return [self showSucceed:text detailText:detailText inView:DefaultTipsParentView hideAfterDelay:YYUITipsAutomaticallyHideToastSeconds];
}

+ (YYUITips *)showSucceed:(NSString *)text inView:(UIView *)view {
    return [self showSucceed:text detailText:nil inView:view hideAfterDelay:YYUITipsAutomaticallyHideToastSeconds];
}

+ (YYUITips *)showSucceed:(NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    return [self showSucceed:text detailText:nil inView:view hideAfterDelay:delay];
}

+ (YYUITips *)showSucceed:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view {
    return [self showSucceed:text detailText:detailText inView:view hideAfterDelay:YYUITipsAutomaticallyHideToastSeconds];
}

+ (YYUITips *)showSucceed:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    YYUITips *tips = [self createTipsToView:view];
    [tips showSucceed:text detailText:detailText hideAfterDelay:delay];
    return tips;
}

+ (YYUITips *)showError:(nullable NSString *)text {
    return [self showError:text detailText:nil inView:DefaultTipsParentView hideAfterDelay:YYUITipsAutomaticallyHideToastSeconds];
}

+ (YYUITips *)showError:(nullable NSString *)text detailText:(nullable NSString *)detailText {
    return [self showError:text detailText:detailText inView:DefaultTipsParentView hideAfterDelay:YYUITipsAutomaticallyHideToastSeconds];
}

+ (YYUITips *)showError:(NSString *)text inView:(UIView *)view {
    return [self showError:text detailText:nil inView:view hideAfterDelay:YYUITipsAutomaticallyHideToastSeconds];
}

+ (YYUITips *)showError:(NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    return [self showError:text detailText:nil inView:view hideAfterDelay:delay];
}

+ (YYUITips *)showError:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view {
    return [self showError:text detailText:detailText inView:view hideAfterDelay:YYUITipsAutomaticallyHideToastSeconds];
}

+ (YYUITips *)showError:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    YYUITips *tips = [self createTipsToView:view];
    [tips showError:text detailText:detailText hideAfterDelay:delay];
    return tips;
}

+ (YYUITips *)showInfo:(nullable NSString *)text {
    return [self showInfo:text detailText:nil inView:DefaultTipsParentView hideAfterDelay:YYUITipsAutomaticallyHideToastSeconds];
}

+ (YYUITips *)showInfo:(nullable NSString *)text detailText:(nullable NSString *)detailText {
    return [self showInfo:text detailText:detailText inView:DefaultTipsParentView hideAfterDelay:YYUITipsAutomaticallyHideToastSeconds];
}

+ (YYUITips *)showInfo:(NSString *)text inView:(UIView *)view {
    return [self showInfo:text detailText:nil inView:view hideAfterDelay:YYUITipsAutomaticallyHideToastSeconds];
}

+ (YYUITips *)showInfo:(NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    return [self showInfo:text detailText:nil inView:view hideAfterDelay:delay];
}

+ (YYUITips *)showInfo:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view {
    return [self showInfo:text detailText:detailText inView:view hideAfterDelay:YYUITipsAutomaticallyHideToastSeconds];
}

+ (YYUITips *)showInfo:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    YYUITips *tips = [self createTipsToView:view];
    [tips showInfo:text detailText:detailText hideAfterDelay:delay];
    return tips;
}

+ (YYUITips *)createTipsToView:(UIView *)view {
    YYUITips *tips = [[YYUITips alloc] initWithView:view];
    [view addSubview:tips];
    tips.removeFromSuperViewWhenHide = YES;
    return tips;
}

+ (void)hideAllTipsInView:(UIView *)view {
    [self hideAllToastInView:view animated:NO];
}

+ (void)hideAllTips {
    [self hideAllToastInView:nil animated:NO];
}

@end

