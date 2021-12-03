//
//  YYUIAlertController.h
//  YYUIKit
//
//  Created by liuxc on 2021/12/2.
//

#import <UIKit/UIKit.h>
#import "YYUIAlertAction.h"
#import "YYUIAlertViewShared.h"

NS_ASSUME_NONNULL_BEGIN

@class YYUIAlertController;
@protocol YYUIAlertControllerDelegate;

#pragma mark - Constants

extern NSString * _Nonnull const YYUIAlertControllerWillShowNotification;
extern NSString * _Nonnull const YYUIAlertControllerDidShowNotification;

extern NSString * _Nonnull const YYUIAlertControllerWillDismissNotification;
extern NSString * _Nonnull const YYUIAlertControllerDidDismissNotification;

/** You can use this notification to add some custom animations */
extern NSString * _Nonnull const YYUIAlertControllerShowAnimationsNotification;
/** You can use this notification to add some custom animations */
extern NSString * _Nonnull const YYUIAlertControllerDismissAnimationsNotification;

extern NSString * _Nonnull const kYYUIAlertControllerAnimationDuration;

#pragma mark - Types

typedef void (^ _Nullable YYUIAlertControllerCompletionHandler)(void);
typedef void (^ _Nullable YYUIAlertControllerHandler)(YYUIAlertController * _Nonnull alertController);
typedef void (^ _Nullable YYUIAlertControllerTextFieldSetupHandler)(UITextField * _Nonnull textField);
typedef void (^ _Nullable YYUIAlertControllerAnimationsBlock)(YYUIAlertController * _Nonnull alertController, NSTimeInterval duration);

typedef NS_ENUM(NSUInteger, YYUIAlertControllerStyle) {
    YYUIAlertControllerStyleAlert       = 0,
    YYUIAlertControllerStyleActionSheet = 1
};

typedef NS_ENUM(NSUInteger, YYUIAlertControllerWindowLevel) {
    YYUIAlertControllerWindowLevelAboveStatusBar = 0,
    YYUIAlertControllerWindowLevelBelowStatusBar = 1
};

@interface YYUIAlertController : NSObject <UIAppearance>

/** Is action "show" already had been executed */
@property (assign, nonatomic, readonly, getter=isShowing) BOOL showing;
/** Is alert view visible right now */
@property (assign, nonatomic, readonly, getter=isVisible) BOOL visible;

@property (assign, nonatomic, readonly) YYUIAlertControllerStyle preferredStyle;

/** Default is YYUIAlertControllerWindowLevelAboveStatusBar */
@property (assign, nonatomic) YYUIAlertControllerWindowLevel windowLevel UI_APPEARANCE_SELECTOR;

/**
 Default:
 if (alert with activityIndicator || progressView || textFields) then NO
 else YES
 */
@property (assign, nonatomic, getter=isCancelOnTouch) BOOL cancelOnTouch UI_APPEARANCE_SELECTOR;

/**
 Dismiss alert view on action, cancel and destructive
 Default is YES
 */
@property (assign, nonatomic, getter=isDismissOnAction) BOOL dismissOnAction UI_APPEARANCE_SELECTOR;

@property (nullable, nonatomic, readonly) NSArray<YYUIAlertAction *> *actions;

@property (nullable, nonatomic, readonly) NSArray<UITextField *> *textFields;

/** View that you associate to alert view while initialization */
@property (strong, nonatomic, readonly, nullable) UIView *innerView;

/** Default is 0 */
@property (assign, nonatomic) NSInteger tag;

#pragma mark - Style properties

/**
 Set colors of actions title and highlighted background, cancel button title and highlighted background, activity indicator and progress view
 Default is [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0]
 */
@property (strong, nonatomic, nullable) UIColor *tintColor UI_APPEARANCE_SELECTOR;
/**
 Color hides main view when alert view is showing
 Default is [UIColor colorWithWhite:0.0 alpha:0.35]
 */
@property (strong, nonatomic, nullable) UIColor *coverColor UI_APPEARANCE_SELECTOR;
/** Default is nil */
@property (strong, nonatomic, nullable) UIBlurEffect *coverBlurEffect UI_APPEARANCE_SELECTOR;
/** Default is 1.0 */
@property (assign, nonatomic) CGFloat coverAlpha UI_APPEARANCE_SELECTOR;
/** Default is UIColor.whiteColor */
@property (strong, nonatomic, nullable) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;
/** Default is nil */
@property (strong, nonatomic, nullable) UIBlurEffect *backgroundBlurEffect UI_APPEARANCE_SELECTOR;
/**
 Default:
 if (style ==YYUIAlertControllerStyleAlert || iOS < 9.0) then 44.0
 else 56.0
 */
@property (assign, nonatomic) CGFloat buttonsHeight UI_APPEARANCE_SELECTOR;
/** Default is 44.0 */
@property (assign, nonatomic) CGFloat textFieldsHeight UI_APPEARANCE_SELECTOR;
/**
 Top and bottom offsets from borders of the screen
 Default is 8.0
 */
@property (assign, nonatomic) CGFloat offsetVertical UI_APPEARANCE_SELECTOR;
/**
 Offset between cancel button and main view when style isYYUIAlertControllerStyleActionSheet
 Default is 8.0
 */
@property (assign, nonatomic) CGFloat cancelButtonOffsetY UI_APPEARANCE_SELECTOR;
/** Default is NSNotFound */
@property (assign, nonatomic) CGFloat heightMax UI_APPEARANCE_SELECTOR;
/**
 Default:
 if (style == YYUIAlertControllerStyleAlert) then 280.0
 else if (iPad) then 304.0
 else window.width - 16.0
 */
@property (assign, nonatomic) CGFloat width UI_APPEARANCE_SELECTOR;
/** Default is [UIColor colorWithWhite:0.85 alpha:1.0] */
@property (strong, nonatomic, nullable) UIColor *separatorsColor UI_APPEARANCE_SELECTOR;
/** Default is UIScrollViewIndicatorStyleBlack */
@property (assign, nonatomic) UIScrollViewIndicatorStyle indicatorStyle UI_APPEARANCE_SELECTOR;
/** Default is NO */
@property (assign, nonatomic, getter=isShowsVerticalScrollIndicator) BOOL showsVerticalScrollIndicator UI_APPEARANCE_SELECTOR;
/** Default is NO */
@property (assign, nonatomic, getter=isPadShowsActionSheetFromBottom) BOOL padShowsActionSheetFromBottom UI_APPEARANCE_SELECTOR;
/** Default is NO */
@property (assign, nonatomic, getter=isOneRowOneButton) BOOL oneRowOneButton UI_APPEARANCE_SELECTOR;
/** Default is YES */
@property (assign, nonatomic) BOOL shouldDismissAnimated UI_APPEARANCE_SELECTOR;

#pragma marl - Layer properties

/**
 Default:
 if (iOS < 9.0) then 6.0
 else 12.0
 */
@property (assign, nonatomic) CGFloat layerCornerRadius UI_APPEARANCE_SELECTOR;
/** Default is nil */
@property (strong, nonatomic, nullable) UIColor *layerBorderColor UI_APPEARANCE_SELECTOR;
/** Default is 0.0 */
@property (assign, nonatomic) CGFloat layerBorderWidth UI_APPEARANCE_SELECTOR;
/** Default is nil */
@property (strong, nonatomic, nullable) UIColor *layerShadowColor UI_APPEARANCE_SELECTOR;
/** Default is 0.0 */
@property (assign, nonatomic) CGFloat layerShadowRadius UI_APPEARANCE_SELECTOR;
/** Default is CGPointZero */
@property (assign, nonatomic) CGPoint layerShadowOffset UI_APPEARANCE_SELECTOR;
 
#pragma mark - Animation properties

/** Default is 0.5 */
@property (assign, nonatomic) NSTimeInterval animationDuration UI_APPEARANCE_SELECTOR;

/**
 Only if (style == YYUIAlertControllerStyleAlert)
 Default is 1.2
 */
@property (assign, nonatomic) CGFloat initialScale UI_APPEARANCE_SELECTOR;

/**
 Only if (style == YYUIAlertControllerStyleAlert)
 Default is 0.95
 */
@property (assign, nonatomic) CGFloat finalScale UI_APPEARANCE_SELECTOR;

#pragma mark - Title properties

@property (copy, nonatomic, readonly, nullable) NSString *title;

/**
 Default:
 if (style == YYUIAlertControllerStyleAlert) then UIColor.blackColor
 else UIColor.grayColor
 */
@property (strong, nonatomic, nullable) UIColor *titleTextColor UI_APPEARANCE_SELECTOR;
/** Default is NSTextAlignmentCenter */
@property (assign, nonatomic) NSTextAlignment titleTextAlignment UI_APPEARANCE_SELECTOR;
/**
 Default:
 if (style == YYUIAlertControllerStyleAlert) then [UIFont boldSystemFontOfSize:18.0]
 else [UIFont boldSystemFontOfSize:14.0]
 */
@property (strong, nonatomic, nullable) UIFont *titleFont UI_APPEARANCE_SELECTOR;

#pragma mark - Message properties

@property (copy, nonatomic, readonly, nullable) NSString *message;

/**
 Default:
 if (style == YYUIAlertControllerStyleAlert) then UIColor.blackColor
 else UIColor.grayColor
 */
@property (strong, nonatomic, nullable) UIColor *messageTextColor UI_APPEARANCE_SELECTOR;
/** Default is NSTextAlignmentCenter */
@property (assign, nonatomic) NSTextAlignment messageTextAlignment UI_APPEARANCE_SELECTOR;
/** Default is [UIFont systemFontOfSize:14.0] */
@property (strong, nonatomic, nullable) UIFont *messageFont UI_APPEARANCE_SELECTOR;

//#pragma mark - Buttons properties
//
//@property (copy, nonatomic, readonly, nullable) NSString *buttonsTitle;
///** Default is YES */
//@property (assign, nonatomic, getter=isCancelButtonEnabled) BOOL buttonsEnabled;
//@property (copy, nonatomic, nullable) UIImage *buttonsIconImage;
//@property (copy, nonatomic, nullable) UIImage *buttonsIconImagesHighlighted;
//@property (copy, nonatomic, nullable) UIImage *buttonsIconImagesDisabled;
//
///** Default is tintColor */
//@property (strong, nonatomic, nullable) UIColor *buttonsTitleColor UI_APPEARANCE_SELECTOR;
///** Default is UIColor.whiteColor */
//@property (strong, nonatomic, nullable) UIColor *buttonsTitleColorHighlighted UI_APPEARANCE_SELECTOR;
///** Default is UIColor.grayColor */
//@property (strong, nonatomic, nullable) UIColor *buttonsTitleColorDisabled UI_APPEARANCE_SELECTOR;
///** Default is NSTextAlignmentCenter */
//@property (assign, nonatomic) NSTextAlignment buttonsTextAlignment UI_APPEARANCE_SELECTOR;
///** Default is [UIFont systemFontOfSize:18.0] */
//@property (strong, nonatomic, nullable) UIFont *buttonsFont UI_APPEARANCE_SELECTOR;
///** Default is UIColor.clearColor */
//@property (strong, nonatomic, nullable) UIColor *buttonsBackgroundColor UI_APPEARANCE_SELECTOR;
///** Default is tintColor */
//@property (strong, nonatomic, nullable) UIColor *buttonsBackgroundColorHighlighted UI_APPEARANCE_SELECTOR;
///** Default is UIColor.clearColor */
//@property (strong, nonatomic, nullable) UIColor *buttonsBackgroundColorDisabled UI_APPEARANCE_SELECTOR;
///** Default is 1 */
//@property (assign, nonatomic) NSUInteger buttonsNumberOfLines UI_APPEARANCE_SELECTOR;
///** Default is NSLineBreakByTruncatingMiddle */
//@property (assign, nonatomic) NSLineBreakMode buttonsLineBreakMode UI_APPEARANCE_SELECTOR;
///** Default is 14.0 / 18.0 */
//@property (assign, nonatomic) CGFloat buttonsMinimumScaleFactor UI_APPEARANCE_SELECTOR;
///** Default is YES */
//@property (assign, nonatomic, getter=isButtonsAdjustsFontSizeToFitWidth) BOOL buttonsAdjustsFontSizeToFitWidth UI_APPEARANCE_SELECTOR;
///** Default is YYUIAlertViewButtonIconPositionLeft */
//@property (assign, nonatomic) YYUIAlertViewButtonIconPosition buttonsIconPosition UI_APPEARANCE_SELECTOR;

//#pragma mark - Cancel button properties
//
//@property (copy, nonatomic, readonly, nullable) NSString *cancelButtonTitle;
///** Default is YES */
//@property (assign, nonatomic, getter=isCancelButtonEnabled) BOOL cancelButtonEnabled;
//@property (strong, nonatomic, nullable) UIImage *cancelButtonIconImage;
//@property (strong, nonatomic, nullable) UIImage *cancelButtonIconImageHighlighted;
//@property (strong, nonatomic, nullable) UIImage *cancelButtonIconImageDisabled;
//
///** Default is tintColor */
//@property (strong, nonatomic, nullable) UIColor *cancelButtonTitleColor UI_APPEARANCE_SELECTOR;
///** Default is UIColor.whiteColor */
//@property (strong, nonatomic, nullable) UIColor *cancelButtonTitleColorHighlighted UI_APPEARANCE_SELECTOR;
///** Default is UIColor.grayColor */
//@property (strong, nonatomic, nullable) UIColor *cancelButtonTitleColorDisabled UI_APPEARANCE_SELECTOR;
///** Default is NSTextAlignmentCenter */
//@property (assign, nonatomic) NSTextAlignment cancelButtonTextAlignment UI_APPEARANCE_SELECTOR;
///** Default is [UIFont boldSystemFontOfSize:18.0] */
//@property (strong, nonatomic, nullable) UIFont *cancelButtonFont UI_APPEARANCE_SELECTOR;
///** Default is UIColor.clearColor */
//@property (strong, nonatomic, nullable) UIColor *cancelButtonBackgroundColor UI_APPEARANCE_SELECTOR;
///** Default is tintColor */
//@property (strong, nonatomic, nullable) UIColor *cancelButtonBackgroundColorHighlighted UI_APPEARANCE_SELECTOR;
///** Default is UIColor.clearColor */
//@property (strong, nonatomic, nullable) UIColor *cancelButtonBackgroundColorDisabled UI_APPEARANCE_SELECTOR;
///** Default is 1 */
//@property (assign, nonatomic) NSUInteger cancelButtonNumberOfLines UI_APPEARANCE_SELECTOR;
///** Default is NSLineBreakByTruncatingMiddle */
//@property (assign, nonatomic) NSLineBreakMode cancelButtonLineBreakMode UI_APPEARANCE_SELECTOR;
///** Default is 14.0 / 18.0 */
//@property (assign, nonatomic) CGFloat cancelButtonMinimumScaleFactor UI_APPEARANCE_SELECTOR;
///** Default is YES */
//@property (assign, nonatomic, getter=isCancelButtonAdjustsFontSizeToFitWidth) BOOL cancelButtonAdjustsFontSizeToFitWidth UI_APPEARANCE_SELECTOR;
///** Default is YYUIAlertViewButtonIconPositionLeft */
//@property (assign, nonatomic) YYUIAlertViewButtonIconPosition cancelButtonIconPosition UI_APPEARANCE_SELECTOR;

//#pragma mark - Destructive button properties
//
//@property (copy, nonatomic, readonly, nullable) NSString *destructiveButtonTitle;
//@property (strong, nonatomic, nullable) UIImage *destructiveButtonIconImage;
//@property (strong, nonatomic, nullable) UIImage *destructiveButtonIconImageHighlighted;
//@property (strong, nonatomic, nullable) UIImage *destructiveButtonIconImageDisabled;
//
///** Default is UIColor.redColor */
//@property (strong, nonatomic, nullable) UIColor *destructiveButtonTitleColor UI_APPEARANCE_SELECTOR;
///** Default is UIColor.whiteColor */
//@property (strong, nonatomic, nullable) UIColor *destructiveButtonTitleColorHighlighted UI_APPEARANCE_SELECTOR;
///** Default is UIColor.grayColor */
//@property (strong, nonatomic, nullable) UIColor *destructiveButtonTitleColorDisabled UI_APPEARANCE_SELECTOR;
///** Default is NSTextAlignmentCenter */
//@property (assign, nonatomic) NSTextAlignment destructiveButtonTextAlignment UI_APPEARANCE_SELECTOR;
///** Default is [UIFont systemFontOfSize:18.0] */
//@property (strong, nonatomic, nullable) UIFont *destructiveButtonFont UI_APPEARANCE_SELECTOR;
///** Default is UIColor.clearColor */
//@property (strong, nonatomic, nullable) UIColor *destructiveButtonBackgroundColor UI_APPEARANCE_SELECTOR;
///** Default is UIColor.redColor */
//@property (strong, nonatomic, nullable) UIColor *destructiveButtonBackgroundColorHighlighted UI_APPEARANCE_SELECTOR;
///** Default is UIColor.clearColor */
//@property (strong, nonatomic, nullable) UIColor *destructiveButtonBackgroundColorDisabled UI_APPEARANCE_SELECTOR;
///** Default is 1 */
//@property (assign, nonatomic) NSUInteger destructiveButtonNumberOfLines UI_APPEARANCE_SELECTOR;
///** Default is NSLineBreakByTruncatingMiddle */
//@property (assign, nonatomic) NSLineBreakMode destructiveButtonLineBreakMode UI_APPEARANCE_SELECTOR;
///** Default is 14.0 / 18.0 */
//@property (assign, nonatomic) CGFloat destructiveButtonMinimumScaleFactor UI_APPEARANCE_SELECTOR;
///** Default is YES */
//@property (assign, nonatomic, getter=isDestructiveButtonAdjustsFontSizeToFitWidth) BOOL destructiveButtonAdjustsFontSizeToFitWidth UI_APPEARANCE_SELECTOR;
///** Default is YYUIAlertViewButtonIconPositionLeft */
//@property (assign, nonatomic) YYUIAlertViewButtonIconPosition destructiveButtonIconPosition UI_APPEARANCE_SELECTOR;

#pragma mark - Activity indicator properties

/** Default is UIActivityIndicatorViewStyleWhiteLarge */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle UI_APPEARANCE_SELECTOR;
/** Default is tintColor */
@property (strong, nonatomic, nullable) UIColor *activityIndicatorViewColor UI_APPEARANCE_SELECTOR;

#pragma mark - Progress view properties

@property (assign, nonatomic) float progress;

/** Default is tintColor */
@property (strong, nonatomic, nullable) UIColor *progressViewProgressTintColor UI_APPEARANCE_SELECTOR;
/** Default is [UIColor colorWithWhite:0.8 alpha:1.0] */
@property (strong, nonatomic, nullable) UIColor *progressViewTrackTintColor UI_APPEARANCE_SELECTOR;
/** Default is nil */
@property (strong, nonatomic, nullable) UIImage *progressViewProgressImage UI_APPEARANCE_SELECTOR;
/** Default is nil */
@property (strong, nonatomic, nullable) UIImage *progressViewTrackImage UI_APPEARANCE_SELECTOR;

#pragma mark - Progress label properties

@property (strong, nonatomic, nullable) NSString *progressLabelText;

/** Default is UIColor.blackColor */
@property (strong, nonatomic, nullable) UIColor *progressLabelTextColor UI_APPEARANCE_SELECTOR;
/** Defailt is NSTextAlignmentCenter */
@property (assign, nonatomic) NSTextAlignment progressLabelTextAlignment UI_APPEARANCE_SELECTOR;
/** Default is [UIFont systemFontOfSize:14.0] */
@property (strong, nonatomic, nullable) UIFont *progressLabelFont UI_APPEARANCE_SELECTOR;
/** Default is 1 */
@property (assign, nonatomic) NSUInteger progressLabelNumberOfLines UI_APPEARANCE_SELECTOR;
/** Default is NSLineBreakByTruncatingTail */
@property (assign, nonatomic) NSLineBreakMode progressLabelLineBreakMode UI_APPEARANCE_SELECTOR;

#pragma mark - Text fields properties

/** Default is [UIColor colorWithWhite:0.97 alpha:1.0] */
@property (strong, nonatomic, nullable) UIColor *textFieldsBackgroundColor UI_APPEARANCE_SELECTOR;
/** Default is UIColor.blackColor */
@property (strong, nonatomic, nullable) UIColor *textFieldsTextColor UI_APPEARANCE_SELECTOR;
/** Default is [UIFont systemFontOfSize:16.0] */
@property (strong, nonatomic, nullable) UIFont *textFieldsFont UI_APPEARANCE_SELECTOR;
/** Default is NSTextAlignmentLeft */
@property (assign, nonatomic) NSTextAlignment textFieldsTextAlignment UI_APPEARANCE_SELECTOR;
/** Default is NO */
@property (assign, nonatomic) BOOL textFieldsClearsOnBeginEditing UI_APPEARANCE_SELECTOR;
/** Default is NO */
@property (assign, nonatomic) BOOL textFieldsAdjustsFontSizeToFitWidth UI_APPEARANCE_SELECTOR;
/** Default is 12.0 */
@property (assign, nonatomic) CGFloat textFieldsMinimumFontSize UI_APPEARANCE_SELECTOR;
/** Default is UITextFieldViewModeAlways */
@property (assign, nonatomic) UITextFieldViewMode textFieldsClearButtonMode UI_APPEARANCE_SELECTOR;

#pragma mark - Callbacks

/** To avoid retain cycle, do not forget about weak reference to self */
@property (copy, nonatomic) YYUIAlertControllerHandler willShowHandler;
/** To avoid retain cycle, do not forget about weak reference to self */
@property (copy, nonatomic) YYUIAlertControllerHandler didShowHandler;

/** To avoid retain cycle, do not forget about weak reference to self */
@property (copy, nonatomic) YYUIAlertControllerHandler willDismissHandler;
/** To avoid retain cycle, do not forget about weak reference to self */
@property (copy, nonatomic) YYUIAlertControllerHandler didDismissHandler;

/**
 You can use this block to add some custom animations
 To avoid retain cycle, do not forget about weak reference to self
 */
@property (copy, nonatomic, nullable) YYUIAlertControllerAnimationsBlock showAnimationsBlock;
/**
 You can use this block to add some custom animations
 To avoid retain cycle, do not forget about weak reference to self
 */
@property (copy, nonatomic, nullable) YYUIAlertControllerAnimationsBlock dismissAnimationsBlock;

#pragma mark - Delegate

@property (weak, nonatomic, nullable) id <YYUIAlertControllerDelegate> delegate;

#pragma mark -

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(YYUIAlertControllerStyle)preferredStyle;

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(YYUIAlertControllerStyle)preferredStyle;

#pragma mark -

- (void)addAction:(UIAlertAction *)action;
- (void)addTextFieldWithConfigurationHandler:(YYUIAlertControllerTextFieldSetupHandler)configurationHandler;

- (void)showAnimated:(BOOL)animated completionHandler:(YYUIAlertControllerCompletionHandler)completionHandler;
- (void)showAnimated;
- (void)show;

- (void)dismissAnimated:(BOOL)animated completionHandler:(YYUIAlertControllerCompletionHandler)completionHandler;
- (void)dismissAnimated;
- (void)dismiss;

- (void)transitionToAlertController:(nonnull YYUIAlertController *)alertController completionHandler:(YYUIAlertControllerCompletionHandler)completionHandler;
- (void)transitionToAlertController:(nonnull YYUIAlertController *)alertController;

- (void)setProgress:(float)progress progressLabelText:(nullable NSString *)progressLabelText;

- (void)setActionPropertiesAtIndex:(NSUInteger)index handler:(void(^ _Nonnull)(YYUIAlertAction * _Nonnull action))handler;

- (void)layoutValidateWithSize:(CGSize)size;

#pragma mark - Unavailable

- (nonnull instancetype)init __attribute__((unavailable("use \"- initWith...\" instead")));
+ (nonnull instancetype)new __attribute__((unavailable("use \"+ alertViewWith...\" instead")));

@end

#pragma mark - Delegate

@protocol YYUIAlertControllerDelegate <NSObject>

@optional

- (void)alertControllerWillShow:(nonnull YYUIAlertController *)alertController;
- (void)alertControllerDidShow:(nonnull YYUIAlertController *)alertController;

- (void)alertControllerWillDismiss:(nonnull YYUIAlertController *)alertController;
- (void)alertControllerDidDismiss:(nonnull YYUIAlertController *)alertController;

/** You can use this method to add some custom animations */
- (void)showAnimationsForAlertController:(nonnull YYUIAlertController *)alertController duration:(NSTimeInterval)duration;
/** You can use this method to add some custom animations */
- (void)dismissAnimationsForAlertController:(nonnull YYUIAlertController *)alertController duration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
