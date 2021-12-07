//
//  YYUIPopupController.h
//  YYUIKit
//
//  Created by liuxc on 2021/12/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Control view mask style
typedef NS_ENUM(NSUInteger, YYUIPopupMaskType) {
    YYUIPopupMaskTypeDarkBlur = 0,
    YYUIPopupMaskTypeLightBlur,
    YYUIPopupMaskTypeExtraLightBlur,
    YYUIPopupMaskTypeWhite,
    YYUIPopupMaskTypeClear,
    YYUIPopupMaskTypeBlackOpacity // default
};

/// Control the style of view Presenting
typedef NS_ENUM(NSInteger, YYUIPopupAnimationStyle) {
    YYUIPopupAnimationStyleFromTop = 0,
    YYUIPopupAnimationStyleFromBottom,
    YYUIPopupAnimationStyleFromLeft,
    YYUIPopupAnimationStyleFromRight,
    YYUIPopupAnimationStyleFade, // default
    YYUIPopupAnimationStyleTransform
};

/// Control where the view finally position
typedef NS_ENUM(NSUInteger, YYUIPopupLayoutType) {
    YYUIPopupLayoutTypeTop = 0,
    YYUIPopupLayoutTypeBottom,
    YYUIPopupLayoutTypeLeft,
    YYUIPopupLayoutTypeRight,
    YYUIPopupLayoutTypeCenter // default
};

/// Control the display level of the PopupController
typedef NS_ENUM(NSUInteger, YYUIPopupWindowLevel) {
    YYUIPopupWindowLevelVeryHigh = 0,
    YYUIPopupWindowLevelHigh,
    YYUIPopupWindowLevelNormal, // default
    YYUIPopupWindowLevelLow,
    YYUIPopupWindowLevelVeryLow
};

@protocol YYUIPopupControllerDelegate;

@interface YYUIPopupController : NSObject

@property (nonatomic, weak) id <YYUIPopupControllerDelegate> _Nullable delegate;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// Designated initializer，Must set your content view and its size.
/// Bind the view to a popup controller，one-to-one
+ (instancetype)popupWithView:(UIView *)popupView;
+ (instancetype)popupWithController:(UIViewController *)controller;
- (instancetype)initWithView:(UIView *)popupView size:(CGSize)size;

/// The view is the initialized `popupView`
@property (nonatomic, strong, readonly) UIView *view;

/// Whether contentView is presenting.
@property (nonatomic, assign, readonly) BOOL isPresenting;

/// Set popup view mask style. default is YYUIPopupMaskTypeBlackOpacity (maskAlpha: 0.5)
@property (nonatomic, assign) YYUIPopupMaskType maskType;

/// Set popup view display position. default is YYUIPopupLayoutTypeCenter
@property (nonatomic, assign) YYUIPopupLayoutType layoutType;

/// Set popup view present slide style. default is YYUIPopupAnimationStyleFade
@property (nonatomic, assign) YYUIPopupAnimationStyle presentationStyle;

/// Set popup view dismiss slide style. default is `presentationStyle`
@property (nonatomic, assign) YYUIPopupAnimationStyle dismissonStyle;

/// Set popup view priority. default is YYUIPopupWindowLevelNormal
@property (nonatomic, assign) YYUIPopupWindowLevel windowLevel;

/// default is 0.5, When maskType is YYUIPopupMaskTypeBlackOpacity vaild.
@property (nonatomic, assign) CGFloat maskAlpha;

/// default is 0.5, When slideStyle is YYUIPopupAnimationStyleTransform vaild.
@property (nonatomic, assign) CGFloat presentationTransformScale;

/// default is `presentationTransformScale`, When slideStyle is YYUIPopupAnimationStyleTransform vaild.
@property (nonatomic, assign) CGFloat dismissonTransformScale;

/// default is YES. if NO, Mask view will not respond to events.
@property (nonatomic, assign) BOOL dismissOnMaskTouched;

/// The view will disappear after `dismissAfterDelay` seconds，default is 0 will not disappear
@property (nonatomic, assign) NSTimeInterval dismissAfterDelay;

/// default is NO. if YES, Popup view will allow to drag
@property (nonatomic, assign) BOOL panGestureEnabled;

/// When drag position meets the screen ratio the view will dismiss，default is 0.5
@property (nonatomic, assign) CGFloat panDismissRatio;

/// Adjust the layout position by `offsetSpacing`
@property (nonatomic, assign) CGFloat offsetSpacing;

/// Adjust the spacing between with the keyboard
@property (nonatomic, assign) CGFloat keyboardOffsetSpacing;

/// default is NO. if YES, Will adjust view position when keyboard changes
@property (nonatomic, assign) BOOL keyboardChangeFollowed;

/// default is NO. if the view becomes first responder，you need set YES to keep the animation consistent
/// If you want to make the animation consistent:
/// You need to call the method "becomeFirstResponder()" in "willPresentBlock", don't call it before that.
/// You need to call the method "resignFirstResponder()" in "willDismissBlock".
@property (nonatomic, assign) BOOL becomeFirstResponded;

/// Block gets called when internal trigger dismiss.
@property (nonatomic, copy) void (^defaultDismissBlock)(YYUIPopupController *popupController);

/// Block gets called when contentView will present.
@property (nonatomic, copy) void (^willPresentBlock)(YYUIPopupController *popupController);

/// Block gets called when contentView did present.
@property (nonatomic, copy) void (^didPresentBlock)(YYUIPopupController *popupController);

/// Block gets called when contentView will dismiss.
@property (nonatomic, copy) void (^willDismissBlock)(YYUIPopupController *popupController);

/// Block gets called when contentView did dismiss.
@property (nonatomic, copy) void (^didDismissBlock)(YYUIPopupController *popupController);

@end


@interface YYUIPopupController (Convenient)

/// Dismiss all the popupcontrollers in the app.
+ (void)dismissAllPopupControllers;

/// Dismiss the popup for contentView.
+ (void)dismissPopupControllerForView:(UIView *)view;

/// Dismiss super popup.
/// Iterate over superviews until you find a `YYUIPopupController` and dismiss it.
+ (void)dismissSuperPopupControllerIn:(UIView *)view;

/// shows popup view animated in window
- (void)show;

/// shows popup view animated.
- (void)showInView:(UIView *)view completion:(void (^ __nullable)(void))completion;

/// shows popup view animated using the specified duration.
- (void)showInView:(UIView *)view duration:(NSTimeInterval)duration completion:(void (^ __nullable)(void))completion;

/// shows popup view animated using the specified duration and bounced.
- (void)showInView:(UIView *)view duration:(NSTimeInterval)duration bounced:(BOOL)bounced completion:(void (^ __nullable)(void))completion;

/// shows popup view animated using the specified duration, delay, options, bounced, and completion handler.
- (void)showInView:(UIView *)view duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options bounced:(BOOL)bounced completion:(void (^ __nullable)(void))completion;

/// hide popup view animated
- (void)dismiss;

/// hide popup view animated using the specified duration.
- (void)dismissWithDuration:(NSTimeInterval)duration completion:(void (^ __nullable)(void))completion;

/// hide popup view animated using the specified duration, delay, options, and completion handler.
- (void)dismissWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options completion:(void (^ __nullable)(void))completion;

@end


@protocol YYUIPopupControllerDelegate <NSObject>
@optional

// - The Delegate method, block is preferred.
- (void)popupControllerWillPresent:(YYUIPopupController *)popupController;
- (void)popupControllerDidPresent:(YYUIPopupController *)popupController;
- (void)popupControllerWillDismiss:(YYUIPopupController *)popupController;
- (void)popupControllerDidDismiss:(YYUIPopupController *)popupController;

@end

@interface UIView (YYUIPopupController)

@property(nonatomic, weak, nullable) YYUIPopupController *yyui_popupController;
@end

NS_ASSUME_NONNULL_END

