//
//  UIImage+YYUIAdd.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (YYUIAdd)

/*
 *  修复旋转方向，返回正方向的图
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

/*
 *  压缩图片方法(先压缩质量再压缩尺寸)
 */
- (NSData *)compressWithLengthLimit:(NSUInteger)maxLength;

/*
 *  压缩图片方法(压缩质量)
 */
- (NSData *)compressQualityWithLengthLimit:(NSInteger)maxLength;

/*
 *  压缩图片方法(压缩质量二分法)
 */
- (NSData *)compressMidQualityWithLengthLimit:(NSInteger)maxLength;

/*
 *  压缩图片方法(压缩尺寸)
 */
- (NSData *)compressBySizeWithLengthLimit:(NSUInteger)maxLength;

@end

NS_ASSUME_NONNULL_END
