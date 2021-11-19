//
//  UIImage+YYUITheme.m
//  CocoaLumberjack
//
//  Created by liuxc on 2021/10/24.
//

#import "UIImage+YYUITheme.h"
#import "YYUIThemeManager.h"
#import <objc/runtime.h>

@implementation UIImage (YYUITheme)

- (void)setThemeImageName:(NSString *)themeImageName {
    objc_setAssociatedObject(self, @selector(themeImageName), themeImageName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)themeImageName {
    return objc_getAssociatedObject(self,  @selector(themeImageName));
}

- (void)setThemeProvider:(YYUIImageThemeProvider)themeProvider {
    objc_setAssociatedObject(self, @selector(themeProvider), themeProvider, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (YYUIImageThemeProvider)themeProvider {
    return objc_getAssociatedObject(self,  @selector(themeProvider));
}

#pragma mark - public

+ (UIImage *)themeImageNamed:(NSString *)themeImageName {
    YYUIThemeManager *manager = [YYUIThemeManager sharedManager];
    NSString *value = manager.configInfo[manager.currentTheme][@"image"][themeImageName];
    UIImage *image = [UIImage imageNamed:value];
    image.themeImageName = themeImageName;
    return image;
}

+ (UIImage *)themeImageNamed:(NSString *)themeImageName inBundle:(nullable NSBundle *)bundle compatibleWithTraitCollection:(nullable UITraitCollection *)traitCollection {
    YYUIThemeManager *manager = [YYUIThemeManager sharedManager];
    NSString *value = manager.configInfo[manager.currentTheme][@"image"][themeImageName];
    UIImage *image = [UIImage imageNamed:value inBundle:bundle compatibleWithTraitCollection:traitCollection];
    image.themeImageName = themeImageName;
    return image;
}

+ (UIImage *)imageWithThemeProvider:(YYUIImageThemeProvider)themeProvider {
    UIImage *tempImage = themeProvider([YYUIThemeManager sharedManager].currentTheme);
    tempImage.themeProvider = themeProvider;
    return tempImage;
}

- (UIImage *)refreshTheme {
    UIImage *tempImage = self;
    
    if (self.themeImageName) {
        tempImage = [UIImage themeImageNamed:self.themeImageName];
    }
    
    if (self.themeProvider) {
        YYUIImageThemeProvider provider = self.themeProvider;
        tempImage = provider([[YYUIThemeManager sharedManager] currentTheme]);
        tempImage.themeProvider = provider;
    }

    return tempImage;
}

- (BOOL)isTheme {
    return self.themeImageName || self.themeProvider;
}

@end
