//
//  YYUIShadowLayer.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import "YYUIShadowLayer.h"

static const CGFloat kShadowElevationDialog = 24.0;
static const float kKeyShadowOpacity = (float)0.26;
static const float kAmbientShadowOpacity = (float)0.08;

@interface YYUIPendingAnimation : NSObject <CAAction>
@property(nonatomic, weak) CALayer *animationSourceLayer;
@property(nonatomic, strong) NSString *keyPath;
@property(nonatomic, strong) id fromValue;
@property(nonatomic, strong) id toValue;
@end

@implementation YYUIShadowMetrics

+ (YYUIShadowMetrics *)metricsWithElevation:(CGFloat)elevation {
  if (0.0 < elevation) {
    return [[YYUIShadowMetrics alloc] initWithElevation:elevation];
  } else {
    return [YYUIShadowMetrics emptyShadowMetrics];
  }
}

- (YYUIShadowMetrics *)initWithElevation:(CGFloat)elevation {
  self = [super init];
  if (self) {
    _topShadowRadius = [YYUIShadowMetrics ambientShadowBlur:elevation];
    _topShadowOffset = CGSizeMake(0.0, 0.0);
    _topShadowOpacity = kAmbientShadowOpacity;
    _bottomShadowRadius = [YYUIShadowMetrics keyShadowBlur:elevation];
    _bottomShadowOffset = CGSizeMake(0.0, [YYUIShadowMetrics keyShadowYOff:elevation]);
    _bottomShadowOpacity = kKeyShadowOpacity;
  }
  return self;
}

+ (YYUIShadowMetrics *)emptyShadowMetrics {
  static YYUIShadowMetrics *emptyShadowMetrics;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    emptyShadowMetrics = [[YYUIShadowMetrics alloc] init];
    emptyShadowMetrics->_topShadowRadius = (CGFloat)0.0;
    emptyShadowMetrics->_topShadowOffset = CGSizeMake(0.0, 0.0);
    emptyShadowMetrics->_topShadowOpacity = 0;
    emptyShadowMetrics->_bottomShadowRadius = (CGFloat)0.0;
    emptyShadowMetrics->_bottomShadowOffset = CGSizeMake(0.0, 0.0);
    emptyShadowMetrics->_bottomShadowOpacity = 0;
  });

  return emptyShadowMetrics;
}

+ (CGFloat)ambientShadowBlur:(CGFloat)points {
  CGFloat blur = (CGFloat)0.889544 * points - (CGFloat)0.003701;
  return blur;
}

+ (CGFloat)keyShadowBlur:(CGFloat)points {
  CGFloat blur = (CGFloat)0.666920 * points - (CGFloat)0.001648;
  return blur;
}

+ (CGFloat)keyShadowYOff:(CGFloat)points {
  CGFloat yOff = (CGFloat)1.23118 * points - (CGFloat)0.03933;
  return yOff;
}

@end

@interface YYUIShadowLayer ()

@property(nonatomic, strong) CAShapeLayer *topShadow;
@property(nonatomic, strong) CAShapeLayer *bottomShadow;
@property(nonatomic, strong) CAShapeLayer *topShadowMask;
@property(nonatomic, strong) CAShapeLayer *bottomShadowMask;

@end

@implementation YYUIShadowLayer {
  BOOL _shadowPathIsInvalid;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _elevation = 0;
    _shadowMaskEnabled = YES;
    _shadowPathIsInvalid = YES;

    [self commonYYUIShadowLayerInit];
  }
  return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self commonYYUIShadowLayerInit];
  }
  return self;
}

- (instancetype)initWithLayer:(id)layer {
  if (self = [super initWithLayer:layer]) {
    if ([layer isKindOfClass:[YYUIShadowLayer class]]) {
      YYUIShadowLayer *otherLayer = (YYUIShadowLayer *)layer;
      _elevation = otherLayer.elevation;
      _shadowMaskEnabled = otherLayer.isShadowMaskEnabled;
      _bottomShadow = [[CAShapeLayer alloc] initWithLayer:otherLayer.bottomShadow];
      _topShadow = [[CAShapeLayer alloc] initWithLayer:otherLayer.topShadow];
      _topShadowMask = [[CAShapeLayer alloc] initWithLayer:otherLayer.topShadowMask];
      _bottomShadowMask = [[CAShapeLayer alloc] initWithLayer:otherLayer.bottomShadowMask];
      [self commonYYUIShadowLayerInit];
    }
  }
  return self;
}

/**
 commonYYUIShadowLayerInit creates additional layers based on the values of _elevation and
 _shadowMaskEnabled.
 */
- (void)commonYYUIShadowLayerInit {
  if (!_bottomShadow) {
    _bottomShadow = [CAShapeLayer layer];
    _bottomShadow.backgroundColor = [UIColor clearColor].CGColor;
    _bottomShadow.shadowColor = [UIColor blackColor].CGColor;
    _bottomShadow.delegate = self;
    [self addSublayer:_bottomShadow];
  }

  if (!_topShadow) {
    _topShadow = [CAShapeLayer layer];
    _topShadow.backgroundColor = [UIColor clearColor].CGColor;
    _topShadow.shadowColor = [UIColor blackColor].CGColor;
    _topShadow.delegate = self;
    [self addSublayer:_topShadow];
  }

  // Setup shadow layer state based off _elevation and _shadowMaskEnabled
  YYUIShadowMetrics *shadowMetrics = [YYUIShadowMetrics metricsWithElevation:_elevation];
  _topShadow.shadowOffset = shadowMetrics.topShadowOffset;
  _topShadow.shadowRadius = shadowMetrics.topShadowRadius;
  _topShadow.shadowOpacity = shadowMetrics.topShadowOpacity;
  _bottomShadow.shadowOffset = shadowMetrics.bottomShadowOffset;
  _bottomShadow.shadowRadius = shadowMetrics.bottomShadowRadius;
  _bottomShadow.shadowOpacity = shadowMetrics.bottomShadowOpacity;

  if (!_topShadowMask) {
    _topShadowMask = [CAShapeLayer layer];
    _topShadowMask.delegate = self;
  }
  if (!_bottomShadowMask) {
    _bottomShadowMask = [CAShapeLayer layer];
    _bottomShadowMask.delegate = self;
  }

  // TODO(#1021): We shouldn't be calling property accessors in an init method.
  if (_shadowMaskEnabled) {
    [self configureShadowLayerMaskForLayer:_topShadowMask];
    [self configureShadowLayerMaskForLayer:_bottomShadowMask];
    _topShadow.mask = _topShadowMask;
    _bottomShadow.mask = _bottomShadowMask;
  }
}

- (void)layoutSublayers {
  [super layoutSublayers];

  [self prepareShadowPath];
  [self commonLayoutSublayers];
}

- (void)setBounds:(CGRect)bounds {
  BOOL sizeChanged = !CGSizeEqualToSize(self.bounds.size, bounds.size);
  [super setBounds:bounds];
  if (sizeChanged) {
    _shadowPathIsInvalid = YES;
    [self setNeedsLayout];
  }
}

- (void)prepareShadowPath {
  // This method is meant to be overriden by its subclasses.
}

#pragma mark - CALayer change monitoring.

/** Returns a shadowPath based on the layer properties. */
- (UIBezierPath *)defaultShadowPath {
  CGFloat cornerRadius = self.cornerRadius;
  if (0.0 < cornerRadius) {
    return [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius];
  }
  return [UIBezierPath bezierPathWithRect:self.bounds];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
  super.cornerRadius = cornerRadius;

  _topShadow.cornerRadius = cornerRadius;
  _bottomShadow.cornerRadius = cornerRadius;
  if (_shadowMaskEnabled) {
    [self configureShadowLayerMaskForLayer:_topShadowMask];
    [self configureShadowLayerMaskForLayer:_bottomShadowMask];
    _topShadow.mask = _topShadowMask;
    _bottomShadow.mask = _bottomShadowMask;
  }
}

- (void)setShadowPath:(CGPathRef)shadowPath {
  super.shadowPath = shadowPath;
  _topShadow.shadowPath = shadowPath;
  _bottomShadow.shadowPath = shadowPath;
  if (_shadowMaskEnabled) {
    [self configureShadowLayerMaskForLayer:_topShadowMask];
    [self configureShadowLayerMaskForLayer:_bottomShadowMask];
  }
}

- (void)setShadowColor:(CGColorRef)shadowColor {
  super.shadowColor = shadowColor;
  _topShadow.shadowColor = shadowColor;
  _bottomShadow.shadowColor = shadowColor;
}

#pragma mark - shouldRasterize forwarding

- (void)setShouldRasterize:(BOOL)shouldRasterize {
  [super setShouldRasterize:shouldRasterize];
  _topShadow.shouldRasterize = shouldRasterize;
  _bottomShadow.shouldRasterize = shouldRasterize;
}

#pragma mark - Shadow Spread

// Returns how far aware the shadow is spread from the edge of the layer.
+ (CGSize)shadowSpreadForElevation:(CGFloat)elevation {
  YYUIShadowMetrics *metrics = [YYUIShadowMetrics metricsWithElevation:elevation];

  CGSize shadowSpread = CGSizeZero;
  shadowSpread.width = MAX(metrics.topShadowRadius, metrics.bottomShadowRadius) +
                       MAX(metrics.topShadowOffset.width, metrics.bottomShadowOffset.width);
  shadowSpread.height = MAX(metrics.topShadowRadius, metrics.bottomShadowRadius) +
                        MAX(metrics.topShadowOffset.height, metrics.bottomShadowOffset.height);

  return shadowSpread;
}

#pragma mark - Pseudo Shadow Masks

- (void)setShadowMaskEnabled:(BOOL)shadowMaskEnabled {
  _shadowMaskEnabled = shadowMaskEnabled;
  if (_shadowMaskEnabled) {
    [self configureShadowLayerMaskForLayer:_topShadowMask];
    [self configureShadowLayerMaskForLayer:_bottomShadowMask];
    _topShadow.mask = _topShadowMask;
    _bottomShadow.mask = _bottomShadowMask;
  } else {
    _topShadow.mask = nil;
    _bottomShadow.mask = nil;
  }
}

// Creates a layer mask that has a hole cut inside so that the original contents
// of the view is no obscured by the shadow the top/bottom pseudo shadow layers
// cast.
- (void)configureShadowLayerMaskForLayer:(CAShapeLayer *)maskLayer {
  UIBezierPath *path = [self outerMaskPath];
  UIBezierPath *innerPath = nil;
  if (self.shadowPath != nil) {
    innerPath = [UIBezierPath bezierPathWithCGPath:(_Nonnull CGPathRef)self.shadowPath];
  } else if (self.cornerRadius > 0) {
    innerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius];
  } else {
    innerPath = [UIBezierPath bezierPathWithRect:self.bounds];
  }
  [path appendPath:innerPath];
  [path setUsesEvenOddFillRule:YES];

  maskLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
  maskLayer.bounds = [self maskRect];
  maskLayer.path = path.CGPath;
  maskLayer.fillRule = kCAFillRuleEvenOdd;
  maskLayer.fillColor = [UIColor blackColor].CGColor;
}

- (CGRect)maskRect {
  CGSize shadowSpread = [YYUIShadowLayer shadowSpreadForElevation:kShadowElevationDialog];
  CGRect bounds = self.bounds;
  return CGRectInset(bounds, -shadowSpread.width * 2, -shadowSpread.height * 2);
}

- (UIBezierPath *)outerMaskPath {
  return [UIBezierPath bezierPathWithRect:[self maskRect]];
}

- (void)setElevation:(CGFloat)elevation {
  _elevation = elevation;

  YYUIShadowMetrics *shadowMetrics = [YYUIShadowMetrics metricsWithElevation:elevation];

  _topShadow.shadowOffset = shadowMetrics.topShadowOffset;
  _topShadow.shadowRadius = shadowMetrics.topShadowRadius;
  _topShadow.shadowOpacity = shadowMetrics.topShadowOpacity;
  _bottomShadow.shadowOffset = shadowMetrics.bottomShadowOffset;
  _bottomShadow.shadowRadius = shadowMetrics.bottomShadowRadius;
  _bottomShadow.shadowOpacity = shadowMetrics.bottomShadowOpacity;
}

#pragma mark - CALayerDelegate

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
  if ([event isEqualToString:@"path"] || [event isEqualToString:@"shadowPath"]) {
    // We have to create a pending animation because if we are inside a UIKit animation block we
    // won't know any properties of the animation block until it is commited.
    YYUIPendingAnimation *pendingAnim = [[YYUIPendingAnimation alloc] init];
    pendingAnim.animationSourceLayer = self;
    pendingAnim.fromValue = [layer.presentationLayer valueForKey:event];
    pendingAnim.toValue = nil;
    pendingAnim.keyPath = event;

    return pendingAnim;
  }
  return nil;
}

#pragma mark - Private

- (void)commonLayoutSublayers {
  CGRect bounds = self.bounds;

  _bottomShadow.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
  _bottomShadow.bounds = bounds;
  _topShadow.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
  _topShadow.bounds = bounds;

  if (_shadowMaskEnabled) {
    [self configureShadowLayerMaskForLayer:_topShadowMask];
    [self configureShadowLayerMaskForLayer:_bottomShadowMask];
  }
  // Enforce shadowPaths because otherwise no shadows can be drawn. If a shadowPath
  // is already set, use that, otherwise fallback to just a regular rect because path.
  if (!_bottomShadow.shadowPath || _shadowPathIsInvalid) {
    if (self.shadowPath) {
      _bottomShadow.shadowPath = self.shadowPath;
    } else {
      _bottomShadow.shadowPath = [self defaultShadowPath].CGPath;
    }
  }
  if (!_topShadow.shadowPath || _shadowPathIsInvalid) {
    if (self.shadowPath) {
      _topShadow.shadowPath = self.shadowPath;
    } else {
      _topShadow.shadowPath = [self defaultShadowPath].CGPath;
    }
  }
  _shadowPathIsInvalid = NO;
}

- (void)animateCornerRadius:(CGFloat)cornerRadius
         withTimingFunction:(CAMediaTimingFunction *)timingFunction
                   duration:(NSTimeInterval)duration {
  [CATransaction begin];
  [CATransaction setDisableActions:YES];
  CGFloat currentCornerRadius = (self.cornerRadius <= 0) ? (CGFloat)0.001 : self.cornerRadius;
  CGFloat newCornerRadius = (cornerRadius <= 0) ? (CGFloat)0.001 : cornerRadius;
  // Create the paths
  UIBezierPath *currentLayerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                              cornerRadius:currentCornerRadius];
  UIBezierPath *newLayerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                          cornerRadius:newCornerRadius];

  UIBezierPath *currentMaskPath = [self outerMaskPath];
  [currentMaskPath appendPath:currentLayerPath];
  currentMaskPath.usesEvenOddFillRule = YES;

  UIBezierPath *newMaskPath = [self outerMaskPath];
  [newMaskPath appendPath:newLayerPath];
  newMaskPath.usesEvenOddFillRule = YES;

  // Animate the top layers
  NSString *shadowPathKey = @"shadowPath";
  CABasicAnimation *topLayerAnimation = [CABasicAnimation animationWithKeyPath:shadowPathKey];
  topLayerAnimation.fromValue = (__bridge id)currentLayerPath.CGPath;
  topLayerAnimation.toValue = (__bridge id)newLayerPath.CGPath;
  topLayerAnimation.duration = duration;
  topLayerAnimation.timingFunction = timingFunction;
  self.topShadow.shadowPath = newLayerPath.CGPath;
  [self.topShadow addAnimation:topLayerAnimation forKey:shadowPathKey];
  CABasicAnimation *bottomLayerAnimation = [CABasicAnimation animationWithKeyPath:shadowPathKey];
  bottomLayerAnimation.fromValue = (__bridge id)currentLayerPath.CGPath;
  bottomLayerAnimation.toValue = (__bridge id)newLayerPath.CGPath;
  bottomLayerAnimation.duration = duration;
  bottomLayerAnimation.timingFunction = timingFunction;
  self.bottomShadow.shadowPath = newLayerPath.CGPath;
  [self.bottomShadow addAnimation:bottomLayerAnimation forKey:shadowPathKey];

  // Animate the masks
  if (self.shadowMaskEnabled) {
    NSString *pathKey = @"path";
    CABasicAnimation *topMaskLayerAnimation = [CABasicAnimation animationWithKeyPath:pathKey];
    topMaskLayerAnimation.fromValue = (__bridge id)currentMaskPath.CGPath;
    topMaskLayerAnimation.toValue = (__bridge id)newMaskPath.CGPath;
    topMaskLayerAnimation.duration = duration;
    topMaskLayerAnimation.timingFunction = timingFunction;
    self.topShadowMask.path = newMaskPath.CGPath;
    [self.topShadowMask addAnimation:topMaskLayerAnimation forKey:pathKey];
    CABasicAnimation *bottomMaskLayerAnimation = [CABasicAnimation animationWithKeyPath:pathKey];
    bottomMaskLayerAnimation.fromValue = (__bridge id)currentMaskPath.CGPath;
    bottomMaskLayerAnimation.toValue = (__bridge id)newMaskPath.CGPath;
    bottomMaskLayerAnimation.duration = duration;
    bottomMaskLayerAnimation.timingFunction = timingFunction;
    self.bottomShadowMask.path = newMaskPath.CGPath;
    [self.bottomShadowMask addAnimation:bottomMaskLayerAnimation forKey:pathKey];
  }

  // Animate the corner radius
  CABasicAnimation *cornerRadiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
  cornerRadiusAnimation.fromValue = @((CGFloat)currentCornerRadius);
  cornerRadiusAnimation.toValue = @((CGFloat)newCornerRadius);
  cornerRadiusAnimation.duration = duration;
  cornerRadiusAnimation.timingFunction = timingFunction;
  self.cornerRadius = cornerRadius;
  [self addAnimation:cornerRadiusAnimation forKey:@"cornerRadius"];
  [CATransaction commit];
}

@end

@implementation YYUIPendingAnimation

- (void)runActionForKey:(NSString *)event object:(id)anObject arguments:(NSDictionary *)dict {
  if ([anObject isKindOfClass:[CAShapeLayer class]]) {
    CAShapeLayer *layer = (CAShapeLayer *)anObject;

    // In order to synchronize our animation with UIKit animations we have to fetch the resizing
    // animation created by UIKit and copy the configuration to our custom animation.
    CAAnimation *boundsAction = [self.animationSourceLayer animationForKey:@"bounds.size"];
    if (!boundsAction) {
      // Headless layers will animate bounds directly instead of decomposing
      // bounds.size/bounds.position. A headless layer is a CALayer without a delegate (usually
      // would be a UIView).
      boundsAction = [self.animationSourceLayer animationForKey:@"bounds"];
    }
    if ([boundsAction isKindOfClass:[CABasicAnimation class]]) {
      CABasicAnimation *animation = (CABasicAnimation *)[boundsAction copy];
      animation.keyPath = self.keyPath;
      animation.fromValue = self.fromValue;
      animation.toValue = self.toValue;

      [layer addAnimation:animation forKey:event];
    }
  }
}

@end
