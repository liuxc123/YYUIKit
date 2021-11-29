//
//  UIColor+YYUIElevation.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/17.
//

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

/**
 Provides extension to UIColor for YYUI Elevation usage.
 */
@interface UIColor (YYUIElevation)

/**
 Returns a color that takes the specified elevation value into account.
 
 Negative elevation is treated as 0.
 Pattern-based UIColor is not supported.
 @param elevation The @c yyui_absoluteElevation value to use when resolving the color.
 */
- (nonnull UIColor *)yyui_resolvedColorWithElevation:(CGFloat)elevation;

/**
 Returns a color that takes the specified elevation value and traits into account when there is a
 color appearance difference between current traits and previous traits. When userInterfaceStyle is
 UIUserInterfaceStyleDark in currentTraitCollection, elevation will be used to resolve the color.

 Negative elevation is treated as 0.
 Pattern-based UIColor is not supported.
 UIColor in UIExtendedGrayColorSpace will be resolved to UIExtendedSRGBColorSpace.

 @param traitCollection The traits to use when resolving the color.
 @param previousTraitCollection The previous traits to use when comparing color appearance.
 @param elevation The @c yyui_absoluteElevation to use when resolving the color.
 */
- (nonnull UIColor *)
    yyui_resolvedColorWithTraitCollection:(nonnull UITraitCollection *)traitCollection
                 previousTraitCollection:(nonnull UITraitCollection *)previousTraitCollection
                               elevation:(CGFloat)elevation;

/**
 Returns a color that takes the specified elevation value and traits into account.
 When userInterfaceStyle is UIUserInterfaceStyleDark in traitCollection, elevation will be used
 to resolve the color.
 Negative elevation is treated as 0.
 Pattern-based UIColor is not supported.
 UIColor in UIExtendedGrayColorSpace will be resolved to UIExtendedSRGBColorSpace.

 @param traitCollection The traits to use when resolving the color.
 @param elevation The @c yyui_absoluteElevation to use when resolving the color.
 */
- (nonnull UIColor *)yyui_resolvedColorWithTraitCollection:
                         (nonnull UITraitCollection *)traitCollection
                                                elevation:(CGFloat)elevation;
@end

