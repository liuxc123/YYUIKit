//
//  YYUICutCornerTreatment.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import "YYUICutCornerTreatment.h"

#import "YYShapes.h"

static NSString *const YYUICutCornerTreatmentCutKey = @"YYUICutCornerTreatmentCutKey";

@implementation YYUICutCornerTreatment

- (instancetype)init {
  return [self initWithCut:0];
}

- (instancetype)initWithCut:(CGFloat)cut {
  if (self = [super init]) {
    _cut = cut;
  }
  return self;
}

- (id)copyWithZone:(NSZone *)zone {
  YYUICutCornerTreatment *copy = [super copyWithZone:zone];
  copy.cut = _cut;
  return copy;
}

- (YYUIPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)angle {
  return [self pathGeneratorForCornerWithAngle:angle andCut:_cut];
}

- (YYUIPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)angle forViewSize:(CGSize)viewSize {
  CGFloat normalizedCut = _cut * viewSize.height;
  return [self pathGeneratorForCornerWithAngle:angle andCut:normalizedCut];
}

- (YYUIPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)angle andCut:(CGFloat)cut {
  YYUIPathGenerator *path = [YYUIPathGenerator pathGeneratorWithStartPoint:CGPointMake(0, cut)];
  [path addLineToPoint:CGPointMake(cut, 0)];
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
  YYUICutCornerTreatment *otherCutCorner = (YYUICutCornerTreatment *)object;
  return self.cut == otherCutCorner.cut;
}

- (NSUInteger)hash {
  return @(self.cut).hash ^ (NSUInteger)self.valueType;
}

@end
