//
//  YYUIMath.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <math.h>

static inline CGFloat YYUIDegreesToRadians(CGFloat degrees) {
#if CGFLOAT_IS_DOUBLE
  return degrees * (CGFloat)M_PI / 180.0;
#else
  return degrees * (CGFloat)M_PI / 180;
#endif
}

static inline BOOL YYUICGFloatEqual(CGFloat a, CGFloat b) {
  const CGFloat constantK = 3;
#if CGFLOAT_IS_DOUBLE
  const CGFloat epsilon = DBL_EPSILON;
  const CGFloat min = DBL_MIN;
#else
  const CGFloat epsilon = FLT_EPSILON;
  const CGFloat min = FLT_MIN;
#endif
  return (fabs(a - b) < constantK * epsilon * fabs(a + b) || fabs(a - b) < min);
}

// Checks whether the provided floating point number is exactly zero.
static inline BOOL YYUICGFloatIsExactlyZero(CGFloat value) {
  return (value == 0);
}

/**
 Round the given value to ceiling with provided scale factor.
 If @c scale is zero, then the rounded value will be zero.

 @param value The value to round
 @param scale The scale factor
 @return The ceiling value calculated using the provided scale factor
 */
static inline CGFloat YYUICeilScaled(CGFloat value, CGFloat scale) {
  if (YYUICGFloatEqual(scale, 0)) {
    return 0;
  }

  return ceil(value * scale) / scale;
}

/**
 Round the given value to floor with provided scale factor.
 If @c scale is zero, then the rounded value will be zero.

 @param value The value to round
 @param scale The scale factor
 @return The floor value calculated using the provided scale factor
 */
static inline CGFloat YYUIFloorScaled(CGFloat value, CGFloat scale) {
  if (YYUICGFloatEqual(scale, 0)) {
    return 0;
  }

  return floor(value * scale) / scale;
}

/**
 Expand `rect' to the smallest standardized rect containing it with pixel-aligned origin and size.
 If @c scale is zero, then a scale of 1 will be used instead.

 @param rect the rectangle to align.
 @param scale the scale factor to use for pixel alignment.

 @return the input rectangle aligned to the nearest pixels using the provided scale factor.

 @see CGRectIntegral
 */
static inline CGRect YYUIRectAlignToScale(CGRect rect, CGFloat scale) {
  if (CGRectIsNull(rect)) {
    return CGRectNull;
  }
  if (YYUICGFloatEqual(scale, 0)) {
    scale = 1;
  }

  if (YYUICGFloatEqual(scale, 1)) {
    return CGRectIntegral(rect);
  }

  CGPoint originalMinimumPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
  CGPoint newOrigin = CGPointMake(floor(originalMinimumPoint.x * scale) / scale,
                                  floor(originalMinimumPoint.y * scale) / scale);
  CGSize adjustWidthHeight =
      CGSizeMake(originalMinimumPoint.x - newOrigin.x, originalMinimumPoint.y - newOrigin.y);
  return CGRectMake(newOrigin.x, newOrigin.y,
                    ceil((CGRectGetWidth(rect) + adjustWidthHeight.width) * scale) / scale,
                    ceil((CGRectGetHeight(rect) + adjustWidthHeight.height) * scale) / scale);
}

static inline CGPoint YYUIPointRoundWithScale(CGPoint point, CGFloat scale) {
  if (YYUICGFloatEqual(scale, 0)) {
    return CGPointZero;
  }

  return CGPointMake(round(point.x * scale) / scale, round(point.y * scale) / scale);
}

/**
 Expand `size' to the closest larger pixel-aligned value.
 If @c scale is zero, then a CGSizeZero will be returned.

 @param size the size to align.
 @param scale the scale factor to use for pixel alignment.

 @return the size aligned to the closest larger pixel-aligned value using the provided scale factor.
 */
static inline CGSize YYUISizeCeilWithScale(CGSize size, CGFloat scale) {
  if (YYUICGFloatEqual(scale, 0)) {
    return CGSizeZero;
  }

  return CGSizeMake(ceil(size.width * scale) / scale, ceil(size.height * scale) / scale);
}

/**
 Align the centerPoint of a view so that its origin is pixel-aligned to the nearest pixel.
 Returns @c CGRectZero if @c scale is zero or @c bounds is @c CGRectNull.

 @param center the unaligned center of the view.
 @param bounds the bounds of the view.
 @param scale the native scaling factor for pixel alignment.

 @return the center point of the view such that its origin will be pixel-aligned.
 */
static inline CGPoint YYUIRoundCenterWithBoundsAndScale(CGPoint center,
                                                       CGRect bounds,
                                                       CGFloat scale) {
  if (YYUICGFloatEqual(scale, 0) || CGRectIsNull(bounds)) {
    return CGPointZero;
  }

  CGFloat halfWidth = CGRectGetWidth(bounds) / 2;
  CGFloat halfHeight = CGRectGetHeight(bounds) / 2;
  CGPoint origin = CGPointMake(center.x - halfWidth, center.y - halfHeight);
  origin = YYUIPointRoundWithScale(origin, scale);
  return CGPointMake(origin.x + halfWidth, origin.y + halfHeight);
}

/// Compare two edge insets using YYUICGFloatEqual.
/// @param insets1 An edge inset to compare with insets2
/// @param insets2 An edge inset to compare with insets1
static inline BOOL YYUIEdgeInsetsEqualToEdgeInsets(UIEdgeInsets insets1, UIEdgeInsets insets2) {
  BOOL topEqual = YYUICGFloatEqual(insets1.top, insets2.top);
  BOOL leftEqual = YYUICGFloatEqual(insets1.left, insets2.left);
  BOOL bottomEqual = YYUICGFloatEqual(insets1.bottom, insets2.bottom);
  BOOL rightEqual = YYUICGFloatEqual(insets1.right, insets2.right);
  return topEqual && leftEqual && bottomEqual && rightEqual;
}

/// 计算目标点 targetPoint 围绕坐标点 coordinatePoint 通过 transform 之后此点的坐标
static inline CGPoint YYCGPointApplyAffineTransformWithCoordinatePoint(CGPoint coordinatePoint, CGPoint targetPoint, CGAffineTransform t) {
    CGPoint p;
    p.x = (targetPoint.x - coordinatePoint.x) * t.a + (targetPoint.y - coordinatePoint.y) * t.c + coordinatePoint.x;
    p.y = (targetPoint.x - coordinatePoint.x) * t.b + (targetPoint.y - coordinatePoint.y) * t.d + coordinatePoint.y;
    p.x += t.tx;
    p.y += t.ty;
    return p;
}

/// 系统的 CGRectApplyAffineTransform 只会按照 anchorPoint 为 (0, 0) 的方式去计算，但通常情况下我们面对的是 UIView/CALayer，它们默认的 anchorPoint 为 (.5, .5)，所以增加这个函数，在计算 transform 时可以考虑上 anchorPoint 的影响
static inline CGRect YYCGRectApplyAffineTransformWithAnchorPoint(CGRect rect, CGAffineTransform t, CGPoint anchorPoint) {
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    CGPoint oPoint = CGPointMake(rect.origin.x + width * anchorPoint.x, rect.origin.y + height * anchorPoint.y);
    CGPoint top_left = YYCGPointApplyAffineTransformWithCoordinatePoint(oPoint, CGPointMake(rect.origin.x, rect.origin.y), t);
    CGPoint bottom_left = YYCGPointApplyAffineTransformWithCoordinatePoint(oPoint, CGPointMake(rect.origin.x, rect.origin.y + height), t);
    CGPoint top_right = YYCGPointApplyAffineTransformWithCoordinatePoint(oPoint, CGPointMake(rect.origin.x + width, rect.origin.y), t);
    CGPoint bottom_right = YYCGPointApplyAffineTransformWithCoordinatePoint(oPoint, CGPointMake(rect.origin.x + width, rect.origin.y + height), t);
    CGFloat minX = MIN(MIN(MIN(top_left.x, bottom_left.x), top_right.x), bottom_right.x);
    CGFloat maxX = MAX(MAX(MAX(top_left.x, bottom_left.x), top_right.x), bottom_right.x);
    CGFloat minY = MIN(MIN(MIN(top_left.y, bottom_left.y), top_right.y), bottom_right.y);
    CGFloat maxY = MAX(MAX(MAX(top_left.y, bottom_left.y), top_right.y), bottom_right.y);
    CGFloat newWidth = maxX - minX;
    CGFloat newHeight = maxY - minY;
    CGRect result = CGRectMake(minX, minY, newWidth, newHeight);
    return result;
}
