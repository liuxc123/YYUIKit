//
//  YYUIRectangleShapeGenerator.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import "YYUIRectangleShapeGenerator.h"

#import "YYUICornerTreatment.h"
#import "YYUIEdgeTreatment.h"
#import "YYUIPathGenerator.h"

static inline CGFloat CGPointDistanceToPoint(CGPoint a, CGPoint b) {
  return hypot(a.x - b.x, a.y - b.y);
}

// Edges in clockwise order
typedef enum : NSUInteger {
  YYUIShapeEdgeTop = 0,
  YYUIShapeEdgeRight,
  YYUIShapeEdgeBottom,
  YYUIShapeEdgeLeft,
} YYUIShapeEdgePosition;

// Corners in clockwise order
typedef enum : NSUInteger {
  YYUIShapeCornerTopLeft = 0,
  YYUIShapeCornerTopRight,
  YYUIShapeCornerBottomRight,
  YYUIShapeCornerBottomLeft,
} YYUIShapeCornerPosition;

@implementation YYUIRectangleShapeGenerator

- (instancetype)init {
  if (self = [super init]) {
    [self setEdges:[[YYUIEdgeTreatment alloc] init]];
    [self setCorners:[[YYUICornerTreatment alloc] init]];
  }
  return self;
}

- (id)copyWithZone:(NSZone *)zone {
  YYUIRectangleShapeGenerator *copy = [[[self class] alloc] init];

  copy.topLeftCorner = [copy.topLeftCorner copyWithZone:zone];
  copy.topRightCorner = [copy.topRightCorner copyWithZone:zone];
  copy.bottomRightCorner = [copy.bottomRightCorner copyWithZone:zone];
  copy.bottomLeftCorner = [copy.bottomLeftCorner copyWithZone:zone];

  copy.topLeftCornerOffset = copy.topLeftCornerOffset;
  copy.topRightCornerOffset = copy.topRightCornerOffset;
  copy.bottomRightCornerOffset = copy.bottomRightCornerOffset;
  copy.bottomLeftCornerOffset = copy.bottomLeftCornerOffset;

  copy.topEdge = [copy.topEdge copyWithZone:zone];
  copy.rightEdge = [copy.rightEdge copyWithZone:zone];
  copy.bottomEdge = [copy.bottomEdge copyWithZone:zone];
  copy.leftEdge = [copy.leftEdge copyWithZone:zone];

  return copy;
}

- (void)setCorners:(YYUICornerTreatment *)cornerShape {
  self.topLeftCorner = [cornerShape copy];
  self.topRightCorner = [cornerShape copy];
  self.bottomRightCorner = [cornerShape copy];
  self.bottomLeftCorner = [cornerShape copy];
}

- (void)setEdges:(YYUIEdgeTreatment *)edgeShape {
  self.topEdge = [edgeShape copy];
  self.rightEdge = [edgeShape copy];
  self.bottomEdge = [edgeShape copy];
  self.leftEdge = [edgeShape copy];
}

- (YYUICornerTreatment *)cornerTreatmentForPosition:(YYUIShapeCornerPosition)position {
  switch (position) {
    case YYUIShapeCornerTopLeft:
      return self.topLeftCorner;
    case YYUIShapeCornerTopRight:
      return self.topRightCorner;
    case YYUIShapeCornerBottomLeft:
      return self.bottomLeftCorner;
    case YYUIShapeCornerBottomRight:
      return self.bottomRightCorner;
  }
}

- (CGPoint)cornerOffsetForPosition:(YYUIShapeCornerPosition)position {
  switch (position) {
    case YYUIShapeCornerTopLeft:
      return self.topLeftCornerOffset;
    case YYUIShapeCornerTopRight:
      return self.topRightCornerOffset;
    case YYUIShapeCornerBottomLeft:
      return self.bottomLeftCornerOffset;
    case YYUIShapeCornerBottomRight:
      return self.bottomRightCornerOffset;
  }
}

- (YYUIEdgeTreatment *)edgeTreatmentForPosition:(YYUIShapeEdgePosition)position {
  switch (position) {
    case YYUIShapeEdgeTop:
      return self.topEdge;
    case YYUIShapeEdgeLeft:
      return self.leftEdge;
    case YYUIShapeEdgeRight:
      return self.rightEdge;
    case YYUIShapeEdgeBottom:
      return self.bottomEdge;
  }
}

- (CGPathRef)pathForSize:(CGSize)size {
  CGMutablePathRef path = CGPathCreateMutable();
  YYUIPathGenerator *cornerPaths[4];
  CGAffineTransform cornerTransforms[4];
  CGAffineTransform edgeTransforms[4];
  CGFloat edgeAngles[4];
  CGFloat edgeLengths[4];

  // Start by getting the path of each corner and calculating edge angles.
  for (NSInteger i = 0; i < 4; i++) {
    YYUICornerTreatment *cornerShape = [self cornerTreatmentForPosition:i];
    CGFloat cornerAngle = [self angleOfCorner:i forViewSize:size];
    if (cornerShape.valueType == YYUICornerTreatmentValueTypeAbsolute) {
      cornerPaths[i] = [cornerShape pathGeneratorForCornerWithAngle:cornerAngle];
    } else if (cornerShape.valueType == YYUICornerTreatmentValueTypePercentage) {
      cornerPaths[i] = [cornerShape pathGeneratorForCornerWithAngle:cornerAngle forViewSize:size];
    }
    edgeAngles[i] = [self angleOfEdge:i forViewSize:size];
  }

  // Create transformation matrices for each corner and edge
  for (NSInteger i = 0; i < 4; i++) {
    CGPoint cornerCoords = [self cornerCoordsForPosition:i forViewSize:size];
    CGAffineTransform cornerTransform =
        CGAffineTransformMakeTranslation(cornerCoords.x, cornerCoords.y);
    CGFloat prevEdgeAngle = edgeAngles[(i + 4 - 1) % 4];
    // We add 90 degrees (M_PI_2) here because the corner starts rotated from the edge.
    cornerTransform = CGAffineTransformRotate(cornerTransform, prevEdgeAngle + (CGFloat)M_PI_2);
    cornerTransforms[i] = cornerTransform;

    CGPoint edgeStartPoint =
        CGPointApplyAffineTransform(cornerPaths[i].endPoint, cornerTransforms[i]);
    CGAffineTransform edgeTransform =
        CGAffineTransformMakeTranslation(edgeStartPoint.x, edgeStartPoint.y);
    CGFloat edgeAngle = edgeAngles[i];
    edgeTransform = CGAffineTransformRotate(edgeTransform, edgeAngle);
    edgeTransforms[i] = edgeTransform;
  }

  // Calculate the length of each edge using the transformed corner paths.
  for (NSInteger i = 0; i < 4; i++) {
    NSInteger next = (i + 1) % 4;
    CGPoint edgeStartPoint =
        CGPointApplyAffineTransform(cornerPaths[i].endPoint, cornerTransforms[i]);
    CGPoint edgeEndPoint =
        CGPointApplyAffineTransform(cornerPaths[next].startPoint, cornerTransforms[next]);
    edgeLengths[i] = CGPointDistanceToPoint(edgeStartPoint, edgeEndPoint);
  }

  // Draw the first corner manually because we have to MoveToPoint to start the path.
  CGPathMoveToPoint(path, &cornerTransforms[0], cornerPaths[0].startPoint.x,
                    cornerPaths[0].startPoint.y);
  [cornerPaths[0] appendToCGPath:path transform:&cornerTransforms[0]];

  // Draw the remaining three corners joined by edges.
  for (NSInteger i = 1; i < 4; i++) {
    // draw the edge from the previous point to the current point
    YYUIEdgeTreatment *edge = [self edgeTreatmentForPosition:(i - 1)];
    YYUIPathGenerator *edgePath = [edge pathGeneratorForEdgeWithLength:edgeLengths[i - 1]];
    [edgePath appendToCGPath:path transform:&edgeTransforms[i - 1]];

    YYUIPathGenerator *cornerPath = cornerPaths[i];
    [cornerPath appendToCGPath:path transform:&cornerTransforms[i]];
  }

  // Draw final edge back to first point.
  YYUIEdgeTreatment *edge = [self edgeTreatmentForPosition:3];
  YYUIPathGenerator *edgePath = [edge pathGeneratorForEdgeWithLength:edgeLengths[3]];
  [edgePath appendToCGPath:path transform:&edgeTransforms[3]];

  CGPathCloseSubpath(path);

  return CFAutorelease(path);
}

- (CGFloat)angleOfCorner:(YYUIShapeCornerPosition)cornerPosition forViewSize:(CGSize)size {
  CGPoint prevCornerCoord = [self cornerCoordsForPosition:(cornerPosition - 1 + 4) % 4
                                              forViewSize:size];
  CGPoint nextCornerCoord = [self cornerCoordsForPosition:(cornerPosition + 1) % 4
                                              forViewSize:size];
  CGPoint cornerCoord = [self cornerCoordsForPosition:cornerPosition forViewSize:size];
  CGPoint prevVector =
      CGPointMake(prevCornerCoord.x - cornerCoord.x, prevCornerCoord.y - cornerCoord.y);
  CGPoint nextVector =
      CGPointMake(nextCornerCoord.x - cornerCoord.x, nextCornerCoord.y - cornerCoord.y);
  CGFloat prevAngle = atan2(prevVector.y, prevVector.x);
  CGFloat nextAngle = atan2(nextVector.y, nextVector.x);
  CGFloat angle = prevAngle - nextAngle;
  if (angle < 0)
    angle += (CGFloat)(2 * M_PI);
  return angle;
}

- (CGFloat)angleOfEdge:(YYUIShapeEdgePosition)edgePosition forViewSize:(CGSize)size {
  YYUIShapeCornerPosition startCornerPosition = (YYUIShapeCornerPosition)edgePosition;
  YYUIShapeCornerPosition endCornerPosition = (startCornerPosition + 1) % 4;
  CGPoint startCornerCoord = [self cornerCoordsForPosition:startCornerPosition forViewSize:size];
  CGPoint endCornerCoord = [self cornerCoordsForPosition:endCornerPosition forViewSize:size];

  CGPoint edgeVector =
      CGPointMake(endCornerCoord.x - startCornerCoord.x, endCornerCoord.y - startCornerCoord.y);
  return atan2(edgeVector.y, edgeVector.x);
}

- (CGPoint)cornerCoordsForPosition:(YYUIShapeCornerPosition)cornerPosition
                       forViewSize:(CGSize)viewSize {
  CGPoint offset = [self cornerOffsetForPosition:cornerPosition];
  CGPoint translation;
  switch (cornerPosition) {
    case YYUIShapeCornerTopLeft:
      translation = CGPointMake(0, 0);
      break;
    case YYUIShapeCornerTopRight:
      translation = CGPointMake(viewSize.width, 0);
      break;
    case YYUIShapeCornerBottomLeft:
      translation = CGPointMake(0, viewSize.height);
      break;
    case YYUIShapeCornerBottomRight:
      translation = CGPointMake(viewSize.width, viewSize.height);
      break;
  }

  return CGPointMake(offset.x + translation.x, offset.y + translation.y);
}

@end

