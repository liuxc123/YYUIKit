//
//  YYUIAction.h
//  YYUIKit
//
//  Created by liuxc on 2021/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YYUIAlertActionStyle) {
    YYUIAlertActionStyleDefault,
    YYUIAlertActionStyleCancel,
    YYUIAlertActionStyleDestructive
};

@interface YYUIAlertAction : NSObject

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(YYUIAlertActionStyle)style handler:(void (^ __nullable)(YYUIAlertAction *action))handler;

/** action类型 */
@property (nonatomic, assign) YYUIAlertActionStyle style;

/** action标题 */
@property (nonatomic, strong) NSString *title;

/** action高亮标题 */
@property (nonatomic, strong) NSString *highlight;

/** action标题(attributed) */
@property (nonatomic, strong) NSAttributedString *attributedTitle;

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
@property (nonatomic, strong) UIColor *titleColorHighlighted;

/** action禁用标题颜色 */
@property (nonatomic, strong) UIColor *titleColorDisabled;

/** action背景颜色 (与 backgroundImage 相同) */
@property (nonatomic, strong) UIColor *backgroundColor;

/** action高亮背景颜色 */
@property (nonatomic, strong) UIColor *backgroundColorHighlighted;

/** action禁用颜色 */
@property (nonatomic, strong) UIColor *backgroundColorDisabled;

/** action背景图片 (与 backgroundColor 相同) */
@property (nonatomic, strong) UIImage *backgroundImage;

/** action高亮背景图片 */
@property (nonatomic, strong) UIImage *backgroundImageHighlighted;

/** action禁用图片 */
@property (nonatomic, strong) UIImage *backgroundImageDisabled;

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

/** action点击不关闭 (仅适用于默认类型) */
@property (nonatomic, assign) BOOL dismissOnTouch;

/** action点击事件回调Block */
@property (nonatomic, copy) void (^ _Nullable handler)(YYUIAlertAction *action);

@end

@interface YYUIAlertActionButton : UIButton

@property (nonatomic, strong) YYUIAlertAction *action;

@property (nonatomic, strong) UIView *topSeparatorView;

@property (nonatomic, strong) UIView *bottomSeparatorView;

+ (YYUIAlertActionButton *)button;

@end

NS_ASSUME_NONNULL_END
