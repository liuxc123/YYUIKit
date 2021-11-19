//
//  UIColor+YYUIKitDynamic.m
//  CatalogByConvention
//
//  Created by liuxc on 2021/11/16.
//

#import "UIColor+YYDynamic.h"

#import "YYAvailability.h"

@implementation UIColor (YYDynamic)

+ (UIColor *)colorWithUserInterfaceStyleDarkColor:(UIColor *)darkColor
                                     defaultColor:(UIColor *)defaultColor {
#if YYUI_AVAILABLE_SDK_IOS(13_0)
  if (@available(iOS 13.0, *)) {
    return [UIColor
        colorWithDynamicProvider:^UIColor *_Nonnull(UITraitCollection *_Nonnull traitCollection) {
          if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return darkColor;
          } else {
            return defaultColor;
          }
        }];
  } else {
    return defaultColor;
  }
#else
  return defaultColor;
#endif  // YYUI_AVAILABLE_SDK_IOS(13_0)
}

+ (UIColor *)colorWithAccessibilityContrastHigh:(UIColor *)highContrastColor
                                         normal:(UIColor *)normalContrastColor {
#if YYUI_AVAILABLE_SDK_IOS(13_0)
  if (@available(iOS 13.0, *)) {
    return [UIColor
        colorWithDynamicProvider:^UIColor *_Nonnull(UITraitCollection *_Nonnull traitCollection) {
          if (traitCollection.accessibilityContrast == UIAccessibilityContrastHigh) {
            return highContrastColor;
          } else {
            return normalContrastColor;
          }
        }];
  } else {
    return normalContrastColor;
  }
#else
  return normalContrastColor;
#endif  // YYUI_AVAILABLE_SDK_IOS(13_0)
}

- (UIColor *)yyui_resolvedColorWithTraitCollection:(UITraitCollection *)traitCollection {
#if YYUI_AVAILABLE_SDK_IOS(13_0)
  if (@available(iOS 13.0, *)) {
    return [self resolvedColorWithTraitCollection:traitCollection];
  } else {
    return self;
  }
#else
  return self;
#endif  // YYUI_AVAILABLE_SDK_IOS(13_0)
}

@end
