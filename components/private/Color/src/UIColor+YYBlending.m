//
//  UIColor+YYUIKitBlending.m
//  CatalogByConvention
//
//  Created by liuxc on 2021/11/16.
//

#import "UIColor+YYBlending.h"

/**
 Helper method to blend a color channel with a background color channel using alpha composition.
 More info about Alpha compositing: https://en.wikipedia.org/wiki/Alpha_compositing

 @params value is the value of color channel
 @params bValue is the value of background color channel
 @params alpha is the alpha of color channel
 @params bAlpha is the alpha of background color channel
 */

static CGFloat blendColorChannel(CGFloat value, CGFloat bValue, CGFloat alpha, CGFloat bAlpha) {
  return ((1 - alpha) * bValue * bAlpha + alpha * value) / (alpha + bAlpha * (1 - alpha));
}

@implementation UIColor (YYBlending)

+ (UIColor *)yyui_blendColor:(UIColor *)color withBackgroundColor:(UIColor *)backgroundColor {
  CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
  [color getRed:&red green:&green blue:&blue alpha:&alpha];
  CGFloat bRed = 0.0, bGreen = 0.0, bBlue = 0.0, bAlpha = 0.0;
  [backgroundColor getRed:&bRed green:&bGreen blue:&bBlue alpha:&bAlpha];

  return [UIColor colorWithRed:blendColorChannel(red, bRed, alpha, bAlpha)
                         green:blendColorChannel(green, bGreen, alpha, bAlpha)
                          blue:blendColorChannel(blue, bBlue, alpha, bAlpha)
                         alpha:alpha + bAlpha * (1 - alpha)];
}
    
@end
