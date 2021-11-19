//
//  YYUICornerTreatment.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import "YYUICornerTreatment.h"

#import "YYUIPathGenerator.h"

@implementation YYUICornerTreatment

- (instancetype)init {
  _valueType = YYUICornerTreatmentValueTypeAbsolute;
  return [super init];
}

- (YYUIPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)__unused angle {
  return [YYUIPathGenerator pathGeneratorWithStartPoint:CGPointZero];
}

- (YYUIPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)__unused angle
                                          forViewSize:(CGSize)__unused viewSize {
  return [YYUIPathGenerator pathGeneratorWithStartPoint:CGPointZero];
}

- (id)copyWithZone:(nullable NSZone *)__unused zone {
  YYUICornerTreatment *copy = [[[self class] alloc] init];
  copy.valueType = _valueType;
  return copy;
}

- (BOOL)isEqual:(id)object {
  if (object == self) {
    return YES;
  }
  if (!object || ![[object class] isEqual:[self class]]) {
    return NO;
  }
  YYUICornerTreatment *otherCorner = (YYUICornerTreatment *)object;
  return self.valueType == otherCorner.valueType;
}

- (NSUInteger)hash {
  return (NSUInteger)self.valueType;
}

@end

