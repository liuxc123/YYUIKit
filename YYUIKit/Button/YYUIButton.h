//
//  YYUIButton.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/22.
//

#import <UIKit/UIKit.h>

/// 控制图片在UIButton里的位置，默认为YYUIButtonImagePositionLeft
typedef NS_ENUM(NSUInteger, YYUIButtonImagePosition) {
    YYUIButtonImagePositionTop,             // imageView在titleLabel上面
    YYUIButtonImagePositionLeft,            // imageView在titleLabel左边
    YYUIButtonImagePositionBottom,          // imageView在titleLabel下面
    YYUIButtonImagePositionRight,           // imageView在titleLabel右边
};

@interface YYUIButton : UIButton

/**
 *  子类继承时重写的方法，一般不建议重写 initWithXxx
 */
- (void)didInitialize NS_REQUIRES_SUPER;

/**
 * 设置按钮里图标和文字的相对位置，默认为YYUIButtonImagePositionLeft<br/>
 * 可配合imageEdgeInsets、titleEdgeInsets、contentHorizontalAlignment、contentVerticalAlignment使用
 */
@property(nonatomic, assign) YYUIButtonImagePosition imagePosition;

/**
 * 设置按钮里图标和文字之间的间隔，会自动响应 imagePosition 的变化而变化，默认为0。<br/>
 * 系统默认实现需要同时设置 titleEdgeInsets 和 imageEdgeInsets，同时还需考虑 contentEdgeInsets 的增加（否则不会影响布局，可能会让图标或文字溢出或挤压），使用该属性可以避免以上情况。<br/>
 * @warning 会与 imageEdgeInsets、 titleEdgeInsets、 contentEdgeInsets 共同作用。
 */
@property(nonatomic, assign) IBInspectable CGFloat spacingBetweenImageAndTitle;

@end


