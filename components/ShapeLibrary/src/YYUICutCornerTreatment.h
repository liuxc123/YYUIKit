//
//  YYUICutCornerTreatment.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import <CoreGraphics/CoreGraphics.h>

#import "YYShapes.h"

/**
 A cut corner treatment subclassing YYUICornerTreatment.
 This can be used to set corners in YYUIRectangleShapeGenerator.
 */
@interface YYUICutCornerTreatment : YYUICornerTreatment

/**
 The cut of the corner.

 The value of the cut defines by how many UI points starting from the edge of the corner and going
 equal distance on the X axis and the Y axis will the corner be cut.

 As an example if the shape is a square with a size of 100x100, and we have all its corners set
 with YYUICutCornerTreatment and a cut value of 50 then the final result will be a diamond with a
 size of 50x50.
 +--------------+                     /\
 |              |                   /    \ 50
 |              |                 /        \
 |              | 100   --->    /            \
 |              |               \            /
 |              |                 \        /
 |              |                   \    / 50
 +--------------+                     \/
 100

 */
@property(nonatomic, assign) CGFloat cut;

/**
 Initializes an YYUICutCornerTreatment instance with a given cut.
 */
- (nonnull instancetype)initWithCut:(CGFloat)cut NS_DESIGNATED_INITIALIZER;

/**
 Initializes an YYUICutCornerTreatment instance with a cut of zero.
 */
- (nonnull instancetype)init;

@end
