//
//  YYUIToastAnimator.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YYUIToastView;

/**
 * `YYUIToastAnimatorDelegate`是所有`YYUIToastAnimator`或者其子类必须遵循的协议，是整个动画过程实现的地方。
 */
@protocol YYUIToastAnimatorDelegate <NSObject>

@required

- (void)showWithCompletion:(void (^)(BOOL finished))completion;
- (void)hideWithCompletion:(void (^)(BOOL finished))completion;
- (BOOL)isShowing;
- (BOOL)isAnimating;
@end

typedef NS_ENUM(NSInteger, YYUIToastAnimationType) {
    YYUIToastAnimationTypeFade      = 0,
    YYUIToastAnimationTypeZoom,
    YYUIToastAnimationTypeSlide
};

/**
 * `YYUIToastAnimator`可以让你通过实现一些协议来自定义ToastView显示和隐藏的动画。你可以继承`YYUIToastAnimator`，然后实现`YYUIToastAnimatorDelegate`中的方法，即可实现自定义的动画。YYUIToastAnimator默认也提供了几种type的动画：1、YYUIToastAnimationTypeFade；2、YYUIToastAnimationTypeZoom；3、YYUIToastAnimationTypeSlide；
 */
@interface YYUIToastAnimator : NSObject <YYUIToastAnimatorDelegate>

/**
 * 初始化方法，请务必使用这个方法来初始化。
 *
 * @param toastView 要使用这个animator的YYUIToastView实例。
 */
- (instancetype)initWithToastView:(YYUIToastView *)toastView NS_DESIGNATED_INITIALIZER;

/**
 * 获取初始化传进来的YYUIToastView。
 */
@property(nonatomic, weak, readonly) YYUIToastView *toastView;

/**
 * 指定YYUIToastAnimator做动画的类型type。此功能暂时未实现，目前所有动画类型都是YYUIToastAnimationTypeFade。
 */
@property(nonatomic, assign) YYUIToastAnimationType animationType;

@end

NS_ASSUME_NONNULL_END
