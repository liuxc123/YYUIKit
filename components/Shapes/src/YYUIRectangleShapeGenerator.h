//
//  YYUIRectangleShapeGenerator.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import <UIKit/UIKit.h>

#import "YYUIShapeGenerating.h"

@class YYUICornerTreatment;
@class YYUIEdgeTreatment;

/**
 An YYUIShapeGenerating for creating shaped rectanglular CGPaths.

 By default YYUIRectangleShapeGenerator creates rectanglular CGPaths. Set the corner and edge
 treatments to shape parts of the generated path.
 */
@interface YYUIRectangleShapeGenerator : NSObject <YYUIShapeGenerating>

/**
 The corner treatments to apply to each corner.
 */
@property(nonatomic, strong) YYUICornerTreatment *topLeftCorner;
@property(nonatomic, strong) YYUICornerTreatment *topRightCorner;
@property(nonatomic, strong) YYUICornerTreatment *bottomLeftCorner;
@property(nonatomic, strong) YYUICornerTreatment *bottomRightCorner;

/**
 The offsets to apply to each corner.
 */
@property(nonatomic, assign) CGPoint topLeftCornerOffset;
@property(nonatomic, assign) CGPoint topRightCornerOffset;
@property(nonatomic, assign) CGPoint bottomLeftCornerOffset;
@property(nonatomic, assign) CGPoint bottomRightCornerOffset;

/**
 The edge treatments to apply to each edge.
 */
@property(nonatomic, strong) YYUIEdgeTreatment *topEdge;
@property(nonatomic, strong) YYUIEdgeTreatment *rightEdge;
@property(nonatomic, strong) YYUIEdgeTreatment *bottomEdge;
@property(nonatomic, strong) YYUIEdgeTreatment *leftEdge;

/**
 Convenience to set all corners to the same YYUICornerTreatment instance.
 */
- (void)setCorners:(YYUICornerTreatment *)cornerShape;

/**
 Conveninece to set all edge treatments to the same YYUIEdgeTreatment instance.
 */
- (void)setEdges:(YYUIEdgeTreatment *)edgeShape;

@end

