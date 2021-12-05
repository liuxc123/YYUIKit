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

@interface YYUIAlertAction : NSObject <NSCopying, UIAppearance>

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

/** action圆角曲率 */
@property (nonatomic, assign) CGFloat cornerRadius;

/** action高度 */
@property (nonatomic, assign) CGFloat height;

/** action边框宽度 */
@property (nonatomic, assign) CGFloat borderWidth;

/** action边框颜色 */
@property (nonatomic, strong) UIColor *borderColor;

/** action是否能点击 默认YES */
@property(nonatomic, getter=isEnabled) BOOL enabled;

/** action点击不关闭 (仅适用于默认类型) */
@property (nonatomic, assign) BOOL dismissOnTouch;

@property (nonatomic, copy, readonly) void (^handler)(YYUIAlertAction *action);

@end

@protocol YYUIAlertControllerDelegate;
@interface YYUIAlertController : UIViewController

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

#pragma mark - Action

- (void)addAction:(YYUIAlertAction *)action;
@property (nonatomic, readonly) NSArray<YYUIAlertAction *> *actions;

#pragma mark - TextField

/* 添加文本输入框
 * 一旦添加后就会回调一次(仅回调一次,因此可以在这个block块里面自由定制textFiled,如设置textField的属性,设置代理,添加addTarget,监听通知等);
 */
- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;
@property(nullable, nonatomic, readonly) NSArray<UITextField *> *textFields;

/** 头部图标, 大小取决于图片本身大小 */
@property(nullable,nonatomic, copy) UIImage *image;
/** 主标题 */
@property(nullable, nonatomic, copy) NSString *title;
/** 副标题 */
@property(nullable, nonatomic, copy) NSString *message;
/** 主标题(富文本) */
@property(nullable, nonatomic, copy) NSAttributedString *attributedTitle;
/** 副标题(富文本) */
@property(nullable, nonatomic, copy) NSAttributedString *attributedMessage;

/*
 * action水平排列还是垂直排列
 * actionSheet样式下:默认为UILayoutConstraintAxisVertical(垂直排列), 如果设置为UILayoutConstraintAxisHorizontal(水平排列)，则除去取消样式action之外的其余action将水平排列
 * alert样式下:当actions的个数大于2，或者某个action的title显示不全时为UILayoutConstraintAxisVertical(垂直排列)，否则默认为UILayoutConstraintAxisHorizontal(水平排列)，此样式下设置该属性可以修改所有action的排列方式
 * 不论哪种样式，只要外界设置了该属性，永远以外界设置的优先
 */
@property(nonatomic) UILayoutConstraintAxis actionAxis;

/* 距离屏幕边缘的最小间距
 * alert样式下该属性是指对话框四边与屏幕边缘之间的距离，此样式下默认值随设备变化，actionSheet样式下是指弹出边的对立边与屏幕之间的距离，比如如果从右边弹出，那么该属性指的就是对话框左边与屏幕之间的距离，此样式下默认值为70
 */
@property(nonatomic, assign) CGFloat minDistanceToEdges;

/** SPAlertControllerStyleAlert样式下默认6.0f，SPAlertControllerStyleActionSheet样式下默认13.0f，去除半径设置为0即可 */
@property(nonatomic, assign) CGFloat cornerRadius;

/** 对话框的偏移量，y值为正向下偏移，为负向上偏移；x值为正向右偏移，为负向左偏移，该属性只对SPAlertControllerStyleAlert样式有效,键盘的frame改变会自动偏移，如果手动设置偏移只会取手动设置的 */
@property(nonatomic, assign) CGPoint offsetForAlert;
/** 设置alert样式下的偏移量,动画为NO则跟属性offsetForAlert等效 */
- (void)setOffsetForAlert:(CGPoint)offsetForAlert animated:(BOOL)animated;

/** 是否需要对话框拥有毛玻璃,默认为YES */
@property(nonatomic, assign) BOOL needDialogBlur;

/** 是否单击背景退出对话框,默认为YES */
@property(nonatomic, assign) BOOL dismissOnTouchBackground;

@property(assign, nonatomic, readonly) YYUIAlertControllerStyle preferredStyle;

@property(assign, nonatomic, readonly) YYUIAlertAnimationType animationType;

#pragma mark - Delegate

@property(nonatomic, weak, nullable) id<YYUIAlertControllerDelegate> delegate;



/** 设置action与下一个action之间的间距, action仅限于非取消样式，必须在'-addAction:'之后设置，iOS11或iOS11以上才能使用 */
- (void)setCustomSpacing:(CGFloat)spacing afterAction:(YYUIAlertAction *)action API_AVAILABLE(ios(11.0));
- (CGFloat)customSpacingAfterAction:(YYUIAlertAction *)action API_AVAILABLE(ios(11.0));

/** 设置蒙层的外观样式,可通过alpha调整透明度 */
- (void)setBackgroundViewAppearanceStyle:(UIBlurEffectStyle)style alpha:(CGFloat)alpha;

// 插入一个组件view，位置处于头部和action部分之间，要求头部和action部分同时存在
- (void)insertComponentView:(nonnull UIView *)componentView;

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
