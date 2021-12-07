//
//  YYUIAlertAction.h
//  YYUIKit
//
//  Created by liuxc on 2021/12/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

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

/** action主题颜色 */
@property (nonatomic, strong) UIColor *tintColor;

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


NS_ASSUME_NONNULL_END
