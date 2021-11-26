//
//  UIImage+YYUITheme.h
//  CocoaLumberjack
//
//  Created by liuxc on 2021/10/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef UIImage *_Nullable(^YYUIImageThemeProvider)(NSString *themeName);

@interface UIImage (YYUITheme)

@property (nullable, nonatomic, copy) NSString *themeImageName;
@property (nullable, nonatomic, copy) YYUIImageThemeProvider themeProvider;

+ (nullable UIImage *)themeImageNamed:(NSString *)imageName;
+ (nullable UIImage *)themeImageNamed:(NSString *)name inBundle:(nullable NSBundle *)bundle compatibleWithTraitCollection:(nullable UITraitCollection *)traitCollection;

+ (nullable UIImage *)imageWithThemeProvider:(YYUIImageThemeProvider)themeProvider;
- (nullable UIImage *)refreshTheme;
- (BOOL)isTheme;

@end

NS_ASSUME_NONNULL_END
