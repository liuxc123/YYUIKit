//
//  UIColor+YYUITheme.m
//  CocoaLumberjack
//
//  Created by liuxc on 2021/10/24.
//

#import "UIColor+YYUITheme.h"
#import "YYUIThemeManager.h"
#import <objc/runtime.h>

@implementation UIColor (YYUITheme)

- (void)setThemeColorName:(NSString *)themeColorName {
    objc_setAssociatedObject(self, @selector(themeColorName), themeColorName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)themeColorName {
    return objc_getAssociatedObject(self, @selector(themeColorName));
}

- (void)setThemeProvider:(UIColor * _Nonnull (^)(NSString * _Nonnull))themeProvider {
    objc_setAssociatedObject(self, @selector(themeProvider), themeProvider, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIColor * (^)(NSString * _Nonnull))themeProvider {
    return objc_getAssociatedObject(self, @selector(themeProvider));
}

#pragma mark - public

+ (UIColor *)themeColor:(NSString *)themeColorName {
    YYUIThemeManager *manager = [YYUIThemeManager sharedManager];
    NSString *value = manager.configInfo[manager.currentTheme][@"color"][themeColorName];
    UIColor *color = [UIColor colorWithHexString:value] ?: [UIColor clearColor];
    color.themeColorName = themeColorName;
    return color;
}

+ (CGColorRef)themeCGColor:(NSString *)themeColorName {
    return (__bridge CGColorRef)[UIColor themeColor:themeColorName];
}

+ (UIColor *)colorWithThemeProvider:(YYUIColorThemeProvider)themeProvider {
    UIColor *color = themeProvider([YYUIThemeManager sharedManager].currentTheme);
    color.themeProvider = themeProvider;
    return color;
}

- (UIColor *)refreshTheme {
    UIColor *tempColor = self;
    
    if (self.themeColorName) {
        tempColor = [UIColor themeColor:self.themeColorName];
    }
    
    if (self.themeProvider) {
        YYUIColorThemeProvider provider = self.themeProvider;
        tempColor = provider([[YYUIThemeManager sharedManager] currentTheme]);
        tempColor.themeProvider = provider;
    }
    return tempColor;
}

- (BOOL)isTheme {
    return self.themeColorName || self.themeProvider;
}

#pragma mark - other

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    
    if (!hexString) return nil;
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    
    CGFloat alpha, red, blue, green;
    
    switch ([colorString length]) {
        case 0:
            return nil;
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorString start: 0 length: 1];
            green = [self colorComponentFrom:colorString start: 1 length: 1];
            blue  = [self colorComponentFrom:colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom:colorString start: 0 length: 1];
            red   = [self colorComponentFrom:colorString start: 1 length: 1];
            green = [self colorComponentFrom:colorString start: 2 length: 1];
            blue  = [self colorComponentFrom:colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorString start: 0 length: 2];
            green = [self colorComponentFrom:colorString start: 2 length: 2];
            blue  = [self colorComponentFrom:colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom:colorString start: 0 length: 2];
            red   = [self colorComponentFrom:colorString start: 2 length: 2];
            green = [self colorComponentFrom:colorString start: 4 length: 2];
            blue  = [self colorComponentFrom:colorString start: 6 length: 2];
            break;
        default:
            alpha = 0;
            red = 0;
            blue = 0;
            green = 0;
            break;
    }
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CGFloat)colorComponentFrom:(NSString *) string start:(NSUInteger)start length:(NSUInteger) length{
    
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0f;
}


@end
