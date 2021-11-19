//
//  YYUITriangleEdgeTreatment.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import <CoreGraphics/CoreGraphics.h>

#import "YYShapes.h"

typedef enum : NSUInteger {
  YYUITriangleEdgeStyleHandle,
  YYUITriangleEdgeStyleCut,
} YYUITriangleEdgeStyle;

/**
 An edge treatment that adds a triangle-shaped cut or handle to the edge.
 */
@interface YYUITriangleEdgeTreatment : YYUIEdgeTreatment

/**
 The size of the triangle shape.
 */
@property(nonatomic, assign) CGFloat size;

/**
 The style of the triangle shape.
 */
@property(nonatomic, assign) YYUITriangleEdgeStyle style;

/**
 Initializes an YYUITriangleEdgeTreatment with a given size and style.
 */
- (nonnull instancetype)initWithSize:(CGFloat)size
                               style:(YYUITriangleEdgeStyle)style NS_DESIGNATED_INITIALIZER;

- (nonnull instancetype)init NS_UNAVAILABLE;

@end
