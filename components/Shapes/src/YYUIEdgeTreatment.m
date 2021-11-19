//
//  YYUIEdgeTreatment.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import "YYUIEdgeTreatment.h"

#import "YYUIPathGenerator.h"

@implementation YYUIEdgeTreatment

- (instancetype)init {
  return [super init];
}

- (YYUIPathGenerator *)pathGeneratorForEdgeWithLength:(CGFloat)length {
  YYUIPathGenerator *path = [YYUIPathGenerator pathGeneratorWithStartPoint:CGPointZero];
  [path addLineToPoint:CGPointMake(length, 0)];
  return path;
}

- (id)copyWithZone:(nullable NSZone *)__unused zone {
  return [[[self class] alloc] init];
}

@end

