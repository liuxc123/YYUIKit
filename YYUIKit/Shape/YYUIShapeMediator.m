//
//  YYUIShapeMediator.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import "YYUIShapeMediator.h"

#import "YYUIShapeGenerating.h"

// An epsilon for use with width/height values.
static const CGFloat kDimensionalEpsilon = 0.001;

@implementation YYUIShapeMediator

- (instancetype)initWithViewLayer:(CALayer *)viewLayer {
  self = [super init];
  if (self) {
    _viewLayer = viewLayer;
    _viewLayer.backgroundColor = [UIColor clearColor].CGColor;
    _colorLayer = [CAShapeLayer layer];
    _colorLayer.delegate = (id<CALayerDelegate>)_viewLayer;
    _shapeLayer = [CAShapeLayer layer];
    [_viewLayer insertSublayer:_colorLayer atIndex:0];
  }
  return self;
}

- (void)layoutShapedSublayers {
  CGRect bounds = _viewLayer.bounds;

  CGPoint center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
  _colorLayer.position = center;
  _colorLayer.bounds = bounds;

  [self prepareShadowPath];
}

- (void)prepareShadowPath {
  if (self.shapeGenerator) {
    CGRect standardizedBounds = CGRectStandardize(_viewLayer.bounds);
    self.path = [self.shapeGenerator pathForSize:standardizedBounds.size];
  }
}

- (void)setShapeGenerator:(id<YYUIShapeGenerating>)shapeGenerator {
  _shapeGenerator = shapeGenerator;

  CGRect standardizedBounds = CGRectStandardize(_viewLayer.bounds);
  self.path = [self.shapeGenerator pathForSize:standardizedBounds.size];
}

- (void)setPath:(CGPathRef)path {
  _viewLayer.shadowPath = path;
  _colorLayer.path = path;
  _shapeLayer.path = path;

  if (CGPathIsEmpty(path)) {
    _viewLayer.backgroundColor = self.shapedBackgroundColor.CGColor;
    _viewLayer.borderColor = self.shapedBorderColor.CGColor;
    _viewLayer.borderWidth = self.shapedBorderWidth;

    _colorLayer.fillColor = nil;
    _colorLayer.strokeColor = nil;
    _colorLayer.lineWidth = 0;
  } else {
    _viewLayer.backgroundColor = nil;
    _viewLayer.borderColor = nil;
    _viewLayer.borderWidth = 0;

    _colorLayer.fillColor = self.shapedBackgroundColor.CGColor;
    _colorLayer.strokeColor = self.shapedBorderColor.CGColor;
    _colorLayer.lineWidth = self.shapedBorderWidth;
    [self generateColorPathGivenLineWidth];
  }
}

- (void)generateColorPathGivenLineWidth {
  if (CGPathIsEmpty(self.path) || _colorLayer.lineWidth <= 0) {
    _colorLayer.path = _viewLayer.shadowPath;
    _shapeLayer.path = _viewLayer.shadowPath;
    return;
  }
  CGFloat halfOfBorderWidth = self.shapedBorderWidth / 2.f;
  CGAffineTransform colorLayerTransform = [self generateTransformInsetByValue:halfOfBorderWidth];
  CGPathRef colorLayerPath =
      CGPathCreateCopyByTransformingPath(_viewLayer.shadowPath, &colorLayerTransform);
  _colorLayer.path = colorLayerPath;
  CGPathRelease(colorLayerPath);
  // The shape layer is used to provide the user a mask for their content, which means also
  // show the full border. Because the border is shown half outside and half inside
  // the color layer path, we must inset the shape layer by the full border width.
  CGAffineTransform shapeLayerTransform =
      [self generateTransformInsetByValue:self.shapedBorderWidth];
  CGPathRef shapeLayerPath =
      CGPathCreateCopyByTransformingPath(_viewLayer.shadowPath, &shapeLayerTransform);
  _shapeLayer.path = shapeLayerPath;
  CGPathRelease(shapeLayerPath);
}

- (CGAffineTransform)generateTransformInsetByValue:(CGFloat)value {
  // Use the identitfy transfrom when inset is less than Epsilon.
  if (value < kDimensionalEpsilon) {
    return CGAffineTransformIdentity;
  }

  // Use the path's boundingBox to get the proportion of inset value,
  // because this tranform is expected to be applied on a CGPath.
  CGRect pathBoundingBox = CGPathGetPathBoundingBox(_viewLayer.shadowPath);
  CGRect pathStandardizedBounds = CGRectStandardize(pathBoundingBox);

  if (CGRectGetWidth(pathStandardizedBounds) < kDimensionalEpsilon ||
      CGRectGetHeight(pathStandardizedBounds) < kDimensionalEpsilon) {
    return CGAffineTransformIdentity;
  }

  CGRect insetBounds = CGRectInset(pathStandardizedBounds, value, value);
  CGFloat width = CGRectGetWidth(pathStandardizedBounds);
  CGFloat height = CGRectGetHeight(pathStandardizedBounds);
  CGFloat pathCenterX = CGRectGetMidX(pathStandardizedBounds);
  CGFloat pathCenterY = CGRectGetMidY(pathStandardizedBounds);
  // Calculate the shifted center and re-center it by applying a translation transform.
  // value * 2 represents the accumulated borderWidth on each side, value * 2 / width
  // represents the proportion of accumulated borderWidth in path bounds, which is also
  // the value used for scale transform.
  // The shiftWidth represents the shifted length horizontally on the center.
  CGFloat shiftWidth = value * 2 / width * pathCenterX;
  // Same calculation for height.
  CGFloat shiftHeight = value * 2 / height * pathCenterY;
  CGAffineTransform transform = CGAffineTransformMakeTranslation(shiftWidth, shiftHeight);
  transform = CGAffineTransformScale(transform, CGRectGetWidth(insetBounds) / width,
                                     CGRectGetHeight(insetBounds) / height);
  return transform;
}

- (CGPathRef)path {
  return _colorLayer.path;
}

- (void)setShapedBackgroundColor:(UIColor *)shapedBackgroundColor {
  _shapedBackgroundColor = shapedBackgroundColor;
  if (CGPathIsEmpty(self.path)) {
    _viewLayer.backgroundColor = _shapedBackgroundColor.CGColor;
    _colorLayer.fillColor = nil;
  } else {
    _viewLayer.backgroundColor = nil;
    _colorLayer.fillColor = _shapedBackgroundColor.CGColor;
  }
}

- (void)setShapedBorderColor:(UIColor *)shapedBorderColor {
  _shapedBorderColor = shapedBorderColor;
  if (CGPathIsEmpty(self.path)) {
    _viewLayer.borderColor = _shapedBorderColor.CGColor;
    _colorLayer.strokeColor = nil;
  } else {
    _viewLayer.borderColor = nil;
    _colorLayer.strokeColor = _shapedBorderColor.CGColor;
  }
}

- (void)setShapedBorderWidth:(CGFloat)shapedBorderWidth {
  _shapedBorderWidth = shapedBorderWidth;

  if (CGPathIsEmpty(self.path)) {
    _viewLayer.borderWidth = _shapedBorderWidth;
    _colorLayer.lineWidth = 0;
  } else {
    _viewLayer.borderWidth = 0;
    _colorLayer.lineWidth = _shapedBorderWidth;
    [self generateColorPathGivenLineWidth];
  }
}

@end
