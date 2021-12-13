//
//  YYUIButton.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/22.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YYUIButtonImagePosition) {
    YYUIButtonImagePositionTop      = 0,          // imageView在titleLabel上面
    YYUIButtonImagePositionLeft     = 1,          // imageView在titleLabel左边
    YYUIButtonImagePositionBottom   = 2,          // imageView在titleLabel下面
    YYUIButtonImagePositionRight    = 3,          // imageView在titleLabel右边
};

IB_DESIGNABLE
@interface YYUIButton : UIButton

- (instancetype)initWithImagePosition:(YYUIButtonImagePosition)imagePosition;

#if TARGET_INTERFACE_BUILDER // storyBoard/xib中设置
@property (nonatomic,assign) IBInspectable NSInteger imagePosition; // 图片位置
@property (nonatomic, assign) IBInspectable CGFloat imageTitleSpace; // 图片和文字之间的间距
#else // 纯代码设置
@property (nonatomic) YYUIButtonImagePosition imagePosition; // 图片位置
@property (nonatomic, assign) CGFloat imageTitleSpace; // 图片和文字之间的间距
#endif

@end


