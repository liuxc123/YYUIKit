//
//  UIColor+YYBlending.h
//  CatalogByConvention
//
//  Created by liuxc on 2021/11/16.
//

#import <UIKit/UIKit.h>

@interface UIColor (YYBlending)

/**
 Blending a color over a background color using Alpha compositing technique.
 More info about Alpha compositing: https://en.wikipedia.org/wiki/Alpha_compositing

 @param color UIColor value that sits on top.
 @param backgroundColor UIColor on the background.
 */
+ (nonnull UIColor *)yyui_blendColor:(nonnull UIColor *)color
                withBackgroundColor:(nonnull UIColor *)backgroundColor;

@end


