//
//  YYUITriangleEdgeTreatment.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import "YYUITriangleEdgeTreatment.h"

#import "YYShapes.h"

@implementation YYUITriangleEdgeTreatment

- (instancetype)initWithSize:(CGFloat)size style:(YYUITriangleEdgeStyle)style {
  if (self = [super init]) {
    _size = size;
    _style = style;
  }
  return self;
}

- (YYUIPathGenerator *)pathGeneratorForEdgeWithLength:(CGFloat)length {
  BOOL isCut = (self.style == YYUITriangleEdgeStyleCut);
  YYUIPathGenerator *path = [YYUIPathGenerator pathGeneratorWithStartPoint:CGPointZero];
  [path addLineToPoint:CGPointMake(length / 2 - _size, 0)];
  [path addLineToPoint:CGPointMake(length / 2, isCut ? _size : -_size)];
  [path addLineToPoint:CGPointMake(length / 2 + _size, 0)];
  [path addLineToPoint:CGPointMake(length, 0)];
  return path;
}

- (id)copyWithZone:(NSZone *)__unused zone {
  return [[[self class] alloc] initWithSize:_size style:_style];
}

@end
