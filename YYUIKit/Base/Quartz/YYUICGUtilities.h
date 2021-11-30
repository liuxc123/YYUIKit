//
//  YYUICGUtilities.h
//  CatalogByConvention
//
//  Created by liuxc on 2021/11/30.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#if __has_include(<YYKit/YYKit.h>)
#import <YYKit/YYKitMacro.h>
#import <YYKit/YYCGUtilities.h>
#else
#import "YYKitMacro.h"
#import "YYCGUtilities.h"
#endif

#if __has_include(<YYUIKit/YYIUKit.h>)
#import <YYUIKit/YYUIKitMacro.h>
#else
#import "YYUIKitMacro.h"
#endif

YY_EXTERN_C_BEGIN
NS_ASSUME_NONNULL_BEGIN


static inline BOOL CGFloatEqual(CGFloat a, CGFloat b) {
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

/// Compare two edge insets using CGFloatEqual.
/// @param insets1 An edge inset to compare with insets2
/// @param insets2 An edge inset to compare with insets1
static inline BOOL UIEdgeInsetsEqual(UIEdgeInsets insets1, UIEdgeInsets insets2) {
  BOOL topEqual = CGFloatEqual(insets1.top, insets2.top);
  BOOL leftEqual = CGFloatEqual(insets1.left, insets2.left);
  BOOL bottomEqual = CGFloatEqual(insets1.bottom, insets2.bottom);
  BOOL rightEqual = CGFloatEqual(insets1.right, insets2.right);
  return topEqual && leftEqual && bottomEqual && rightEqual;
}

NS_ASSUME_NONNULL_END
YY_EXTERN_C_END
