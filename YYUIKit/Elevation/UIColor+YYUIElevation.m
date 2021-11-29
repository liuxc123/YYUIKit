//
//  UIColor+YYUIElevation.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/17.
//

#import "UIColor+YYUIElevation.h"

#import <CoreGraphics/CoreGraphics.h>

#import "YYUIKitMacro.h"

@implementation UIColor (YYUIElevation)

- (UIColor *)yyui_resolvedColorWithTraitCollection:(UITraitCollection *)traitCollection
                          previousTraitCollection:(UITraitCollection *)previousTraitCollection
                                        elevation:(CGFloat)elevation {
  if (@available(iOS 13.0, *)) {
    if ([traitCollection
            hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
      return [self yyui_resolvedColorWithTraitCollection:traitCollection elevation:elevation];
    }
  }
  return self;
}

- (UIColor *)yyui_resolvedColorWithTraitCollection:(UITraitCollection *)traitCollection
                                        elevation:(CGFloat)elevation {
  if (@available(iOS 13.0, *)) {
    UIColor *resolvedColor = [self resolvedColorWithTraitCollection:traitCollection];
    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
      return [resolvedColor yyui_resolvedColorWithElevation:elevation];
    } else {
      return resolvedColor;
    }
  }
  return self;
}

- (UIColor *)yyui_resolvedColorWithElevation:(CGFloat)elevation {
  if (CGColorGetPattern(self.CGColor)) {
    [NSException raise:NSGenericException
                format:@"Pattern-based colors are not supported by %@", NSStringFromSelector(_cmd)];
  }

  UIColor *overlayColor = UIColor.whiteColor;
  elevation = MAX(elevation, 0);
  CGFloat alphaValue = 0;
  if (!CGFloatEqual(elevation, 0)) {
    if (elevation < 1) {
      // A formula for values between 0 to 1 is used here to simulate the alpha percentage
      // as in the main formula below there is a jump between any number larger than 0 to an
      // alpha value of 2. This formula provides a gradual polynomial curve that makes the delta
      // of the alpha value between lower numbers to be smaller than the higher numbers.
      // AlphaValue = 5.11916 * elevationValue ^ 2
      alphaValue = (CGFloat)5.11916 * pow((CGFloat)elevation, 2);
    } else {
      // A formula is used here to simulate the alpha percentage stated on
      // https://material.io/design/color/dark-theme.html#properties
      // AlphaValue = 4.5 * ln (elevationValue + 1) + 2
      // Note: Both formulas meet at the transition point of (1, 5.11916).
      alphaValue = (CGFloat)4.5 * (CGFloat)log(elevation + 1) + 2;
    }
  }
    
    return [self colorByAddColor: [overlayColor colorWithAlphaComponent:alphaValue * (CGFloat)0.01] blendMode:kCGBlendModeNormal];
}

@end

