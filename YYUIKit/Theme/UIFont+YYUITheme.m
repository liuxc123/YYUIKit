//
//  UIFont+YYUITheme.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/19.
//

#import "UIFont+YYUITheme.h"
#import "YYUIThemeManager.h"
#import <objc/runtime.h>

@implementation UIFont (YYUITheme)

- (void)setThemeFontName:(NSString *)themeFontName {
    objc_setAssociatedObject(self, @selector(themeFontName), themeFontName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)themeFontName {
    return objc_getAssociatedObject(self,  @selector(themeFontName));
}

- (void)setThemeProvider:(YYUIFontThemeProvider)themeProvider {
    objc_setAssociatedObject(self, @selector(themeProvider), themeProvider, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (YYUIFontThemeProvider)themeProvider {
    return objc_getAssociatedObject(self,  @selector(themeProvider));
}

#pragma mark - public

+ (UIFont *)themeSystemFont:(NSString *)themeFontName {
    YYUIThemeManager *manager = [YYUIThemeManager sharedManager];
    NSNumber *value = manager.configInfo[manager.currentTheme][@"font"][themeFontName];
    UIFont *font = [UIFont systemFontOfSize:[value floatValue]];
    font.themeFontName = themeFontName;
    return font;
}

+ (UIFont *)themeSystemBoldFont:(NSString *)themeFontName {
    YYUIThemeManager *manager = [YYUIThemeManager sharedManager];
    NSNumber *value = manager.configInfo[manager.currentTheme][@"font"][themeFontName];
    UIFont *font = [UIFont boldSystemFontOfSize:[value floatValue]];
    font.themeFontName = themeFontName;
    return font;
}

+ (UIFont *)themeItalicSystemBoldFont:(NSString *)themeFontName {
    YYUIThemeManager *manager = [YYUIThemeManager sharedManager];
    NSNumber *value = manager.configInfo[manager.currentTheme][@"font"][themeFontName];
    UIFont *font = [UIFont italicSystemFontOfSize:[value floatValue]];
    font.themeFontName = themeFontName;
    return font;
}

+ (UIFont *)fontWithThemeProvider:(YYUIFontThemeProvider)themeProvider {
    UIFont *font = themeProvider([YYUIThemeManager sharedManager].currentTheme);
    font.themeProvider = themeProvider;
    return font;
}

+ (UIFont *)themeFontWithDescriptor:(UIFontDescriptor *)descriptor themeFontName:(NSString *)themeFontName  {
    YYUIThemeManager *manager = [YYUIThemeManager sharedManager];
    NSNumber *value = manager.configInfo[manager.currentTheme][@"font"][themeFontName];
    UIFont *font = [UIFont fontWithDescriptor:descriptor size:[value floatValue]];
    font.themeFontName = themeFontName;
    return font;
}

- (UIFont *)themeFontWithName:(NSString *)themeFontName {
    YYUIThemeManager *manager = [YYUIThemeManager sharedManager];
    NSNumber *value = manager.configInfo[manager.currentTheme][@"font"][themeFontName];
    UIFont *font = [self fontWithSize:[value floatValue]];
    font.themeFontName = themeFontName;
    return font;
}

- (UIFont *)refreshTheme {
    UIFont *tempFont = self;
    
    if (self.themeFontName) {
        tempFont = [self themeFontWithName:self.themeFontName];
    }
    
    if (self.themeProvider) {
        YYUIFontThemeProvider provider = self.themeProvider;
        tempFont = provider([[YYUIThemeManager sharedManager] currentTheme]);
        tempFont.themeProvider = provider;
    }

    return tempFont;
}

- (BOOL)isTheme {
    return self.themeFontName || self.themeProvider;
}


@end
