//
//  YYUIAlertController.h
//  YYUIKit
//
//  Created by 刘学成 on 2021/12/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YYUIAlertControllerStyle) {
    YYUIAlertControllerStyleActionSheet = 0, // 从单侧弹出(顶/左/底/右)
    YYUIAlertControllerStyleAlert,           // 从中间弹出
};

typedef NS_ENUM(NSInteger, YYUIAlertAnimationType) {
    YYUIAlertAnimationTypeDefault = 0, // 默认动画，如果是YYUIAlertControllerStyleActionSheet样式,默认动画等效于YYUIAlertAnimationTypeFromBottom，如果是YYUIAlertControllerStyleAlert样式,默认动画等效于YYUIAlertAnimationTypeShrink
    YYUIAlertAnimationTypeFromBottom,  // 从底部弹出
    YYUIAlertAnimationTypeFromTop,     // 从顶部弹出
    YYUIAlertAnimationTypeFromRight,   // 从右边弹出
    YYUIAlertAnimationTypeFromLeft,    // 从左边弹出
    
    YYUIAlertAnimationTypeShrink,      // 收缩动画
    YYUIAlertAnimationTypeExpand,      // 发散动画
    YYUIAlertAnimationTypeFade,        // 渐变动画

    YYUIAlertAnimationTypeNone,        // 无动画
};

typedef NS_ENUM(NSInteger, YYUIAlertActionStyle) {
    YYUIAlertActionStyleDefault = 0,  // 默认样式
    YYUIAlertActionStyleCancel,       // 取消样式,字体加粗
    YYUIAlertActionStyleDestructive   // 红色字体样式
};

@interface YYUIAlertAction : NSObject <NSCopying>

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(YYUIAlertActionStyle)style handler:(void (^ __nullable)(YYUIAlertAction *action))handler;

/** action类型 */
@property (nonatomic, readonly) YYUIAlertActionStyle style;

/** action的标题 */
@property (nullable, nonatomic, copy) NSString *title;

/** action高亮标题 */
@property (nullable, nonatomic, copy) NSString *highlight;

/** action的富文本标题 */
@property (nullable, nonatomic, copy) NSAttributedString *attributedTitle;

/** action高亮标题(attributed) */
@property (nonatomic, strong) NSAttributedString *attributedHighlight;

/** action标题行数 默认为: 1 */
@property (nonatomic, assign) NSInteger numberOfLines;

/** action标题对齐方式 默认为: NSTextAlignmentLeft */
@property (nonatomic, assign) NSTextAlignment textAlignment;

/** action字体 */
@property (nonatomic, strong) UIFont *font;

/** action字体大小随宽度变化 默认为: NO */
@property (nonatomic, assign) BOOL adjustsFontSizeToFitWidth;

/** action断行模式 默认为: NSLineBreakByTruncatingMiddle */
@property (nonatomic, assign) NSLineBreakMode lineBreakMode;

/** action标题颜色 */
@property (nonatomic, strong) UIColor *titleColor;

/** action高亮标题颜色 */
@property (nonatomic, strong) UIColor *highlightColor;

/** action背景颜色 (与 backgroundImage 相同) */
@property (nonatomic, strong) UIColor *backgroundColor;

/** action高亮背景颜色 */
@property (nonatomic, strong) UIColor *backgroundHighlightColor;

/** action背景图片 (与 backgroundColor 相同) */
@property (nonatomic, strong) UIImage *backgroundImage;

/** action高亮背景图片 */
@property (nonatomic, strong) UIImage *backgroundHighlightImage;

/** action图片 */
@property (nonatomic, strong) UIImage *image;

/** action高亮图片 */
@property (nonatomic, strong) UIImage *highlightImage;

/** action间距范围 */
@property (nonatomic, assign) UIEdgeInsets insets;

/** action图片的间距范围 */
@property (nonatomic, assign) UIEdgeInsets imageEdgeInsets;

/** action标题的间距范围 */
@property (nonatomic, assign) UIEdgeInsets titleEdgeInsets;

/** action高度 */
@property (nonatomic, assign) CGFloat height;

/** action是否能点击 默认YES */
@property(nonatomic, getter=isEnabled) BOOL enabled;

/** action点击不关闭 (仅适用于默认类型) */
@property (nonatomic, assign) BOOL dismissOnTouch;

/** action点击事件*/
@property (nonatomic, copy, readonly) void (^handler)(YYUIAlertAction *action);

@end

@protocol YYUIAlertControllerDelegate;
@interface YYUIAlertController : UIViewController

@property(assign, nonatomic, readonly) YYUIAlertControllerStyle preferredStyle;

@property(assign, nonatomic, readonly) YYUIAlertAnimationType animationType;

/** Default:  YES */
@property(nonatomic, assign) BOOL dismissOnTouchBackground;

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


/* 距离屏幕边缘的最小间距
 * alert样式下该属性是指对话框四边与屏幕边缘之间的距离，此样式下默认值随设备变化，actionSheet样式下是指弹出边的对立边与屏幕之间的距离，比如如果从右边弹出，那么该属性指的就是对话框左边与屏幕之间的距离，此样式下默认值为70
 */
@property(nonatomic, assign) CGFloat minDistanceToEdges UI_APPEARANCE_SELECTOR;

/** YYUIAlertControllerStyleAlert样式下默认6.0f，YYUIAlertControllerStyleActionSheet样式下默认13.0f，去除半径设置为0即可 */
@property(nonatomic, assign) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;

/** 对话框的偏移量，y值为正向下偏移，为负向上偏移；x值为正向右偏移，为负向左偏移，该属性只对YYUIAlertControllerStyleAlert样式有效,键盘的frame改变会自动偏移，如果手动设置偏移只会取手动设置的 */
@property(nonatomic, assign) CGPoint offsetForAlert UI_APPEARANCE_SELECTOR;

/** Default is [UIColor colorWithWhite:0.85 alpha:1.0] */
@property (strong, nonatomic, nullable) UIColor *separatorsColor UI_APPEARANCE_SELECTOR;

/** Default is UIScrollViewIndicatorStyleBlack */
@property (assign, nonatomic) UIScrollViewIndicatorStyle indicatorStyle UI_APPEARANCE_SELECTOR;

/** Default is NO */
@property (assign, nonatomic, getter=isShowsVerticalScrollIndicator) BOOL showsVerticalScrollIndicator UI_APPEARANCE_SELECTOR;

#pragma mark - Image properties

/** Default:  nil */
@property (nonatomic, copy, nullable) UIImage *image;

/** image limit size default Infinity */
@property (nonatomic, assign) CGSize imageLimitSize UI_APPEARANCE_SELECTOR;

/** image tintColor,  when image mode is UIImageRenderingModeAlwaysTemplate */
@property (nonatomic, strong) UIColor *imageTintColor UI_APPEARANCE_SELECTOR;

#pragma mark - Title properties

@property (copy, nonatomic, nullable) NSString *title;
@property (copy, nonatomic, nullable) NSAttributedString *attributedTitle;

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

@property (copy, nonatomic, nullable) NSString *message;
@property (copy, nonatomic, nullable) NSAttributedString *attributedMessage;

/**
 Default:
 if (style == LGAlertViewStyleAlert) then UIColor.blackColor
 else UIColor.grayColor
 */
@property (strong, nonatomic, nullable) UIColor *messageTextColor UI_APPEARANCE_SELECTOR;
/** Default is NSTextAlignmentCenter */
@property (assign, nonatomic) NSTextAlignment messageTextAlignment UI_APPEARANCE_SELECTOR;
/** Default is [UIFont systemFontOfSize:14.0] */
@property (strong, nonatomic, nullable) UIFont *messageFont UI_APPEARANCE_SELECTOR;

#pragma mark - Action properties

@property (nonatomic, readonly) NSArray<YYUIAlertAction *> *actions;

/**
 Default:
 if (style == YYUIAlertControllerStyleAlert || iOS < 9.0) then 44.0
 else 56.0
 */
@property (assign, nonatomic) CGFloat actionsHeight UI_APPEARANCE_SELECTOR;

/*
 * action水平排列还是垂直排列
 * actionSheet样式下:默认为UILayoutConstraintAxisVertical(垂直排列), 如果设置为UILayoutConstraintAxisHorizontal(水平排列)，则除去取消样式action之外的其余action将水平排列
 * alert样式下:当actions的个数大于2，或者某个action的title显示不全时为UILayoutConstraintAxisVertical(垂直排列)，否则默认为UILayoutConstraintAxisHorizontal(水平排列)，此样式下设置该属性可以修改所有action的排列方式
 * 不论哪种样式，只要外界设置了该属性，永远以外界设置的优先
 */
@property(nonatomic) UILayoutConstraintAxis actionAxis;

#pragma mark - Default action properties

/** Default is tintColor */
@property (strong, nonatomic, nullable) UIColor *actionsTitleColor UI_APPEARANCE_SELECTOR;
/** Default is UIColor.whiteColor */
@property (strong, nonatomic, nullable) UIColor *actionsTitleColorHighlighted UI_APPEARANCE_SELECTOR;
/** Default is UIColor.grayColor */
@property (strong, nonatomic, nullable) UIColor *actionsTitleColorDisabled UI_APPEARANCE_SELECTOR;
/** Default is NSTextAlignmentCenter */
@property (assign, nonatomic) NSTextAlignment actionsTextAlignment UI_APPEARANCE_SELECTOR;
/** Default is [UIFont systemFontOfSize:18.0] */
@property (strong, nonatomic, nullable) UIFont *actionsFont UI_APPEARANCE_SELECTOR;
/** Default is UIColor.clearColor */
@property (strong, nonatomic, nullable) UIColor *actionsBackgroundColor UI_APPEARANCE_SELECTOR;
/** Default is tintColor */
@property (strong, nonatomic, nullable) UIColor *actionsBackgroundColorHighlighted UI_APPEARANCE_SELECTOR;
/** Default is UIColor.clearColor */
@property (strong, nonatomic, nullable) UIColor *actionsBackgroundColorDisabled UI_APPEARANCE_SELECTOR;
/** Default is 1 */
@property (assign, nonatomic) NSUInteger actionsNumberOfLines UI_APPEARANCE_SELECTOR;
/** Default is NSLineBreakByTruncatingMiddle */
@property (assign, nonatomic) NSLineBreakMode actionsLineBreakMode UI_APPEARANCE_SELECTOR;
/** Default is 14.0 / 18.0 */
@property (assign, nonatomic) CGFloat actionsMinimumScaleFactor UI_APPEARANCE_SELECTOR;
/** Default is YES */
@property (assign, nonatomic, getter=isActionsAdjustsFontSizeToFitWidth) BOOL actionsAdjustsFontSizeToFitWidth UI_APPEARANCE_SELECTOR;

#pragma mark - Cancel action properties

/** Default is tintColor */
@property (strong, nonatomic, nullable) UIColor *cancelActionTitleColor UI_APPEARANCE_SELECTOR;
/** Default is UIColor.whiteColor */
@property (strong, nonatomic, nullable) UIColor *cancelActionTitleColorHighlighted UI_APPEARANCE_SELECTOR;
/** Default is UIColor.grayColor */
@property (strong, nonatomic, nullable) UIColor *cancelActionTitleColorDisabled UI_APPEARANCE_SELECTOR;
/** Default is NSTextAlignmentCenter */
@property (assign, nonatomic) NSTextAlignment cancelActionTextAlignment UI_APPEARANCE_SELECTOR;
/** Default is [UIFont boldSystemFontOfSize:18.0] */
@property (strong, nonatomic, nullable) UIFont *cancelActionFont UI_APPEARANCE_SELECTOR;
/** Default is UIColor.clearColor */
@property (strong, nonatomic, nullable) UIColor *cancelActionBackgroundColor UI_APPEARANCE_SELECTOR;
/** Default is tintColor */
@property (strong, nonatomic, nullable) UIColor *cancelActionBackgroundColorHighlighted UI_APPEARANCE_SELECTOR;
/** Default is UIColor.clearColor */
@property (strong, nonatomic, nullable) UIColor *cancelActionBackgroundColorDisabled UI_APPEARANCE_SELECTOR;
/** Default is 1 */
@property (assign, nonatomic) NSUInteger cancelActionNumberOfLines UI_APPEARANCE_SELECTOR;
/** Default is NSLineBreakByTruncatingMiddle */
@property (assign, nonatomic) NSLineBreakMode cancelActionLineBreakMode UI_APPEARANCE_SELECTOR;
/** Default is 14.0 / 18.0 */
@property (assign, nonatomic) CGFloat cancelActionMinimumScaleFactor UI_APPEARANCE_SELECTOR;
/** Default is YES */
@property (assign, nonatomic, getter=isCancelActionAdjustsFontSizeToFitWidth) BOOL cancelActionAdjustsFontSizeToFitWidth UI_APPEARANCE_SELECTOR;

#pragma mark - Destructive action properties

/** Default is UIColor.redColor */
@property (strong, nonatomic, nullable) UIColor *destructiveActionTitleColor UI_APPEARANCE_SELECTOR;
/** Default is UIColor.whiteColor */
@property (strong, nonatomic, nullable) UIColor *destructiveActionTitleColorHighlighted UI_APPEARANCE_SELECTOR;
/** Default is UIColor.grayColor */
@property (strong, nonatomic, nullable) UIColor *destructiveActionTitleColorDisabled UI_APPEARANCE_SELECTOR;
/** Default is NSTextAlignmentCenter */
@property (assign, nonatomic) NSTextAlignment destructiveActionTextAlignment UI_APPEARANCE_SELECTOR;
/** Default is [UIFont systemFontOfSize:18.0] */
@property (strong, nonatomic, nullable) UIFont *destructiveActionFont UI_APPEARANCE_SELECTOR;
/** Default is UIColor.clearColor */
@property (strong, nonatomic, nullable) UIColor *destructiveActionBackgroundColor UI_APPEARANCE_SELECTOR;
/** Default is UIColor.redColor */
@property (strong, nonatomic, nullable) UIColor *destructiveActionBackgroundColorHighlighted UI_APPEARANCE_SELECTOR;
/** Default is UIColor.clearColor */
@property (strong, nonatomic, nullable) UIColor *destructiveActionBackgroundColorDisabled UI_APPEARANCE_SELECTOR;
/** Default is 1 */
@property (assign, nonatomic) NSUInteger destructiveActionNumberOfLines UI_APPEARANCE_SELECTOR;
/** Default is NSLineBreakByTruncatingMiddle */
@property (assign, nonatomic) NSLineBreakMode destructiveActionLineBreakMode UI_APPEARANCE_SELECTOR;
/** Default is 14.0 / 18.0 */
@property (assign, nonatomic) CGFloat destructiveActionMinimumScaleFactor UI_APPEARANCE_SELECTOR;
/** Default is YES */
@property (assign, nonatomic, getter=isAestructiveActionAdjustsFontSizeToFitWidth) BOOL destructiveActionAdjustsFontSizeToFitWidth UI_APPEARANCE_SELECTOR;

#pragma mark - Text fields properties

@property(nullable, nonatomic, readonly) NSArray<UITextField *> *textFields;

/** Default is 44.0 */
@property (assign, nonatomic) CGFloat textFieldsHeight UI_APPEARANCE_SELECTOR;
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

#pragma mark - Delegate

@property(nonatomic, weak, nullable) id<YYUIAlertControllerDelegate> delegate;

#pragma mark - Initialization

/**
 创建控制器

@param title 大标题
@param message 副标题
@param preferredStyle 对话框样式
@return 控制器对象
*/
+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(YYUIAlertControllerStyle)preferredStyle;

/**
 创建控制器

@param title 大标题
@param message 副标题
@param preferredStyle 对话框样式
@param animationType 动画类型
@return 控制器对象
*/
+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(YYUIAlertControllerStyle)preferredStyle animationType:(YYUIAlertAnimationType)animationType;

/**
 创建控制器(自定义整个对话框)
 
 @param customAlertView 整个对话框的自定义view
 @param preferredStyle 对话框样式
 @param animationType 动画类型
 @return 控制器对象
 */
+ (instancetype)alertControllerWithCustomAlertView:(nonnull UIView *)customAlertView
                                    preferredStyle:(YYUIAlertControllerStyle)preferredStyle
                                     animationType:(YYUIAlertAnimationType)animationType;
/**
 创建控制器(自定义对话框的头部)
 
 @param customHeaderView 头部自定义view
 @param preferredStyle 对话框样式
 @param animationType 动画类型
 @return 控制器对象
 */
+ (instancetype)alertControllerWithCustomHeaderView:(nonnull UIView *)customHeaderView
                                     preferredStyle:(YYUIAlertControllerStyle)preferredStyle
                                      animationType:(YYUIAlertAnimationType)animationType;
/**
 创建控制器(自定义对话框的action部分)
 
 @param customActionSequenceView action部分的自定义view
 @param title 大标题
 @param message 副标题
 @param preferredStyle 对话框样式
 @param animationType 动画类型
 @return 控制器对象
 */
+ (instancetype)alertControllerWithCustomActionSequenceView:(nonnull UIView *)customActionSequenceView
                                                      title:(nullable NSString *)title
                                                    message:(nullable NSString *)message
                                             preferredStyle:(YYUIAlertControllerStyle)preferredStyle
                                              animationType:(YYUIAlertAnimationType)animationType;


- (void)addAction:(YYUIAlertAction *)action;

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;

- (void)setOffsetForAlert:(CGPoint)offsetForAlert animated:(BOOL)animated;

/** 设置action与下一个action之间的间距, action仅限于非取消样式，必须在'-addAction:'之后设置，iOS11或iOS11以上才能使用 */
- (void)setCustomSpacing:(CGFloat)spacing afterAction:(YYUIAlertAction *)action API_AVAILABLE(ios(11.0));
- (CGFloat)customSpacingAfterAction:(YYUIAlertAction *)action API_AVAILABLE(ios(11.0));

/** 设置蒙层的外观样式,可通过alpha调整透明度 */
- (void)setBackgroundViewAppearanceStyle:(UIBlurEffectStyle)style alpha:(CGFloat)alpha;

// 插入一个组件view，位置处于头部和action部分之间，要求头部和action部分同时存在
- (void)insertComponentView:(nonnull UIView *)componentView;

/** 更新自定义view的size，比如屏幕旋转，自定义view的大小发生了改变，可通过该方法更新size */
- (void)updateCustomViewSize:(CGSize)size;

@end

@protocol YYUIAlertControllerDelegate <NSObject>

@optional;

- (void)willPresentAlertController:(YYUIAlertController *)alertController; // 将要present
- (void)didPresentAlertController:(YYUIAlertController *)alertController;  // 已经present
- (void)willDismissAlertController:(YYUIAlertController *)alertController; // 将要dismiss
- (void)didDismissAlertController:(YYUIAlertController *)alertController;  // 已经dismiss

@end

@interface YYUIAlertPresentationController : UIPresentationController
@end

@interface YYUIAlertAnimation : NSObject <UIViewControllerAnimatedTransitioning>
+ (instancetype)animationIsPresenting:(BOOL)presenting;
@end

NS_ASSUME_NONNULL_END
