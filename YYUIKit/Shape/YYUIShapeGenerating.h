//
//  YYUIShapeGenerating.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import <UIKit/UIKit.h>

/**
 A protocol for objects that create closed CGPaths of varying sizes.
 */
@protocol YYUIShapeGenerating <NSCopying>

/**
 Creates a CGPath for the given size.

 @param size The expected size of the generated path.
 @return CGPathRef A closed path of the provided size. If size is empty, may return NULL.
 */
- (nullable CGPathRef)pathForSize:(CGSize)size;

@end
