//
//  YYUIPillShapeGenerator.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import <CoreGraphics/CoreGraphics.h>

#import "YYUIPillShapeGenerator.h"

#import "YYUIRoundedCornerTreatment.h"
#import "YYShapes.h"

@implementation YYUIPillShapeGenerator {
  YYUIRectangleShapeGenerator *_rectangleGenerator;
  YYUIRoundedCornerTreatment *_cornerShape;
}

- (instancetype)init {
  if (self = [super init]) {
    [self commonInit];
  }
  return self;
}

- (id)copyWithZone:(NSZone *)__unused zone {
  return [[[self class] alloc] init];
}

- (void)commonInit {
  _cornerShape = [[YYUIRoundedCornerTreatment alloc] init];
  _rectangleGenerator = [[YYUIRectangleShapeGenerator alloc] init];
  [_rectangleGenerator setCorners:_cornerShape];
}

- (CGPathRef)pathForSize:(CGSize)size {
  CGFloat radius = (CGFloat)0.5 * MIN(fabs(size.width), fabs(size.height));
  if (radius > 0) {
    [_rectangleGenerator setCorners:[[YYUIRoundedCornerTreatment alloc] initWithRadius:radius]];
  }
  return [_rectangleGenerator pathForSize:size];
}

@end
