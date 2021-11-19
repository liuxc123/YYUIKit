//
//  YYUICurvedCornerTreatment.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//


#import "YYUICurvedCornerTreatment.h"

#import "YYShapes.h"

@implementation YYUICurvedCornerTreatment

- (instancetype)init {
  return [self initWithSize:CGSizeZero];
}

- (instancetype)initWithSize:(CGSize)size {
  if (self = [super init]) {
    _size = size;
  }
  return self;
}

- (YYUIPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)angle {
  return [self pathGeneratorForCornerWithAngle:angle andCurve:_size];
}

- (YYUIPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)angle forViewSize:(CGSize)viewSize {
  CGSize normalizedCurve =
      CGSizeMake(_size.width * viewSize.height, _size.height * viewSize.height);
  return [self pathGeneratorForCornerWithAngle:angle andCurve:normalizedCurve];
}

- (YYUIPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)angle andCurve:(CGSize)curve {
  YYUIPathGenerator *path =
      [YYUIPathGenerator pathGeneratorWithStartPoint:CGPointMake(0, curve.height)];
  [path addQuadCurveWithControlPoint:CGPointZero toPoint:CGPointMake(curve.width, 0)];
  return path;
}

- (id)copyWithZone:(NSZone *)zone {
  YYUICurvedCornerTreatment *copy = [super copyWithZone:zone];
  copy.size = _size;
  return copy;
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
  YYUICurvedCornerTreatment *otherCurvedCorner = (YYUICurvedCornerTreatment *)object;
  return CGSizeEqualToSize(self.size, otherCurvedCorner.size);
}

- (NSUInteger)hash {
  return @(self.size.height).hash ^ @(self.size.width).hash ^ (NSUInteger)self.valueType;
}

@end
