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

#pragma mark - UIEdgeInsets

/// 获取UIEdgeInsets在水平方向上的值
static inline CGFloat YYUIEdgeInsetsGetHorizontalValue(UIEdgeInsets insets) {
    return insets.left + insets.right;
}

/// 获取UIEdgeInsets在垂直方向上的值
static inline CGFloat YYUIEdgeInsetsGetVerticalValue(UIEdgeInsets insets) {
    return insets.top + insets.bottom;
}
