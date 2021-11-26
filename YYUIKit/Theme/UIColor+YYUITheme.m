//
//  UIColor+YYUITheme.m
//  CocoaLumberjack
//
//  Created by liuxc on 2021/10/24.
//

#import "UIColor+YYUITheme.h"
#import "YYUIThemeManager.h"
#import "UIColor+YYAdd.h"
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

@end
