//
//  YYUIRoundedCornerTreatment.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import "YYUIRoundedCornerTreatment.h"

#import "YYShapes.h"

@implementation YYUIRoundedCornerTreatment

- (instancetype)init {
  return [self initWithRadius:0];
}

- (instancetype)initWithRadius:(CGFloat)radius {
  if (self = [super init]) {
    _radius = radius;
  }
  return self;
}

- (id)copyWithZone:(NSZone *)zone {
  YYUIRoundedCornerTreatment *copy = [super copyWithZone:zone];
  copy.radius = _radius;
  return copy;
}

- (YYUIPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)angle {
  return [self pathGeneratorForCornerWithAngle:angle andRadius:_radius];
}

- (YYUIPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)angle forViewSize:(CGSize)viewSize {
  CGFloat normalizedRadius = _radius * viewSize.height;
  return [self pathGeneratorForCornerWithAngle:angle andRadius:normalizedRadius];
}

- (YYUIPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)angle andRadius:(CGFloat)radius {
  YYUIPathGenerator *path = [YYUIPathGenerator pathGeneratorWithStartPoint:CGPointMake(0, radius)];
  [path addArcWithTangentPoint:CGPointZero
                       toPoint:CGPointMake(sin(angle) * radius, cos(angle) * radius)
                        radius:radius];
  return path;
}

- (BOOL)isEqual:(id)object {
  if (object == self) {
    return YES;
  } else if (![super isEqual:object]) {
    return NO;
  }
  if (!object || ![[object class] isEqual:[self class]]) {
    return NO;
  }
  YYUIRoundedCornerTreatment *otherRoundedCorner = (YYUIRoundedCornerTreatment *)object;
  return self.radius == otherRoundedCorner.radius;
}

- (NSUInteger)hash {
  return @(self.radius).hash ^ (NSUInteger)self.valueType;
}

@end
