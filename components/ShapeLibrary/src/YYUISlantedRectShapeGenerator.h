//
//  YYUISlantedRectShapeGenerator.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

#import "YYShapes.h"

/**
 A slanted rectangle shape generator.

 Creates rectangles with the vertical edges at a slant.
 */
@interface YYUISlantedRectShapeGenerator : NSObject <YYUIShapeGenerating>

/**
 The horizontal offset of the corners.
 */
@property(nonatomic, assign) CGFloat slant;

@end
