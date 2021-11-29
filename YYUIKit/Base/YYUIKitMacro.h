//
//  YYUIKitMacro.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/26.
//

#import <UIKit/UIKit.h>
#import <YYKit/YYKit.h>
#import <math.h>

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
