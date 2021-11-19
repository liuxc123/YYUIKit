//
//  YYUIPathGenerator.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import "YYUIPathGenerator.h"


@interface YYUIPathCommand : NSObject
- (void)applyToCGPath:(CGMutablePathRef)cgPath transform:(CGAffineTransform *)transform;
@end

@interface YYUIPathLineCommand : YYUIPathCommand
@property(nonatomic, assign) CGPoint point;
@end

@interface YYUIPathArcCommand : YYUIPathCommand
@property(nonatomic, assign) CGPoint point;
@property(nonatomic, assign) CGFloat radius;
@property(nonatomic, assign) CGFloat startAngle;
@property(nonatomic, assign) CGFloat endAngle;
@property(nonatomic, assign) BOOL clockwise;
@end

@interface YYUIPathArcToCommand : YYUIPathCommand
@property(nonatomic, assign) CGPoint start;
@property(nonatomic, assign) CGPoint end;
@property(nonatomic, assign) CGFloat radius;
@end

@interface YYUIPathCurveCommand : YYUIPathCommand
@property(nonatomic, assign) CGPoint control1;
@property(nonatomic, assign) CGPoint control2;
@property(nonatomic, assign) CGPoint end;
@end

@interface YYUIPathQuadCurveCommand : YYUIPathCommand
@property(nonatomic, assign) CGPoint control;
@property(nonatomic, assign) CGPoint end;
@end

@implementation YYUIPathGenerator {
  NSMutableArray *_operations;
  CGPoint _startPoint;
  CGPoint _endPoint;
}

+ (nonnull instancetype)pathGenerator {
  return [[self alloc] initWithStartPoint:CGPointZero];
}

+ (instancetype)pathGeneratorWithStartPoint:(CGPoint)start {
  return [[self alloc] initWithStartPoint:start];
}

- (instancetype)initWithStartPoint:(CGPoint)start {
  if (self = [super init]) {
    _operations = [NSMutableArray array];

    _startPoint = start;
    _endPoint = start;
  }
  return self;
}

- (void)addLineToPoint:(CGPoint)point {
  YYUIPathLineCommand *op = [[YYUIPathLineCommand alloc] init];
  op.point = point;
  [_operations addObject:op];

  _endPoint = point;
}

- (void)addArcWithCenter:(CGPoint)center
                  radius:(CGFloat)radius
              startAngle:(CGFloat)startAngle
                endAngle:(CGFloat)endAngle
               clockwise:(BOOL)clockwise {
  YYUIPathArcCommand *op = [[YYUIPathArcCommand alloc] init];
  op.point = center;
  op.radius = radius;
  op.startAngle = startAngle;
  op.endAngle = endAngle;
  op.clockwise = clockwise;
  [_operations addObject:op];

  _endPoint =
      CGPointMake(center.x + radius * cos(endAngle), center.y + radius * sin(endAngle));
}

- (void)addArcWithTangentPoint:(CGPoint)tangentPoint
                       toPoint:(CGPoint)toPoint
                        radius:(CGFloat)radius {
  YYUIPathArcToCommand *op = [[YYUIPathArcToCommand alloc] init];
  op.start = tangentPoint;
  op.end = toPoint;
  op.radius = radius;
  [_operations addObject:op];

  _endPoint = toPoint;
}

- (void)addCurveWithControlPoint1:(CGPoint)controlPoint1
                    controlPoint2:(CGPoint)controlPoint2
                          toPoint:(CGPoint)toPoint {
  YYUIPathCurveCommand *op = [[YYUIPathCurveCommand alloc] init];
  op.control1 = controlPoint1;
  op.control2 = controlPoint2;
  op.end = toPoint;
  [_operations addObject:op];

  _endPoint = toPoint;
}

- (void)addQuadCurveWithControlPoint:(CGPoint)controlPoint toPoint:(CGPoint)toPoint {
  YYUIPathQuadCurveCommand *op = [[YYUIPathQuadCurveCommand alloc] init];
  op.control = controlPoint;
  op.end = toPoint;
  [_operations addObject:op];

  _endPoint = toPoint;
}

- (void)appendToCGPath:(CGMutablePathRef)cgPath transform:(CGAffineTransform *)transform {
  for (YYUIPathCommand *op in _operations) {
    [op applyToCGPath:cgPath transform:transform];
  }
}

@end

@implementation YYUIPathCommand

- (void)applyToCGPath:(CGMutablePathRef)__unused cgPath
            transform:(CGAffineTransform *)__unused transform {
  // no-op
}

@end

@implementation YYUIPathLineCommand

- (void)applyToCGPath:(CGMutablePathRef)cgPath transform:(CGAffineTransform *)transform {
  CGPathAddLineToPoint(cgPath, transform, self.point.x, self.point.y);
}

@end

@implementation YYUIPathArcCommand
- (void)applyToCGPath:(CGMutablePathRef)cgPath transform:(CGAffineTransform *)transform {
  CGPathAddArc(cgPath, transform, self.point.x, self.point.y, self.radius, self.startAngle,
               self.endAngle, self.clockwise);
}
@end

@implementation YYUIPathArcToCommand

- (void)applyToCGPath:(CGMutablePathRef)cgPath transform:(CGAffineTransform *)transform {
  CGPathAddArcToPoint(cgPath, transform, self.start.x, self.start.y, self.end.x, self.end.y,
                      self.radius);
}

@end

@implementation YYUIPathCurveCommand

- (void)applyToCGPath:(CGMutablePathRef)cgPath transform:(CGAffineTransform *)transform {
  CGPathAddCurveToPoint(cgPath, transform, self.control1.x, self.control1.y, self.control2.x,
                        self.control2.y, self.end.x, self.end.y);
}

@end

@implementation YYUIPathQuadCurveCommand

- (void)applyToCGPath:(CGMutablePathRef)cgPath transform:(CGAffineTransform *)transform {
  CGPathAddQuadCurveToPoint(cgPath, transform, self.control.x, self.control.y, self.end.x,
                            self.end.y);
}

@end

