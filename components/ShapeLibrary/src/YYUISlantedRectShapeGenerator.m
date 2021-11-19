//
//  YYUISlantedRectShapeGenerator.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import "YYUISlantedRectShapeGenerator.h"

#import "YYShapes.h"

@implementation YYUISlantedRectShapeGenerator {
  YYUIRectangleShapeGenerator *_rectangleGenerator;
}

- (instancetype)init {
  if (self = [super init]) {
    [self commonYYUISlantedRectShapeGeneratorInit];
  }
  return self;
}

- (void)commonYYUISlantedRectShapeGeneratorInit {
  _rectangleGenerator = [[YYUIRectangleShapeGenerator alloc] init];
}

- (id)copyWithZone:(NSZone *)__unused zone {
  YYUISlantedRectShapeGenerator *copy = [[[self class] alloc] init];
  copy.slant = self.slant;
  return copy;
}

- (void)setSlant:(CGFloat)slant {
  _slant = slant;

  _rectangleGenerator.topLeftCornerOffset = CGPointMake(slant, 0);
  _rectangleGenerator.topRightCornerOffset = CGPointMake(slant, 0);
  _rectangleGenerator.bottomLeftCornerOffset = CGPointMake(-slant, 0);
  _rectangleGenerator.bottomRightCornerOffset = CGPointMake(-slant, 0);
}

- (CGPathRef)pathForSize:(CGSize)size {
  return [_rectangleGenerator pathForSize:size];
}

@end
