//
//  UIFont+YYUITheme.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef UIFont *_Nullable(^YYUIFontThemeProvider)(NSString *themeName);

@interface UIFont (YYUITheme)

@property (nonatomic, copy) NSString *themeFontName;
@property (nonatomic, copy) YYUIFontThemeProvider themeProvider;

+ (UIFont *)themeSystemFont:(NSString *)themeFontName;
+ (UIFont *)themeSystemBoldFont:(NSString *)themeFontName;
+ (UIFont *)themeItalicSystemBoldFont:(NSString *)themeFontName;
+ (UIFont *)fontWithThemeProvider:(YYUIFontThemeProvider)themeProvider;
+ (UIFont *)themeFontWithDescriptor:(UIFontDescriptor *)descriptor themeFontName:(NSString *)themeFontName;

- (UIFont *)themeFontWithName:(NSString *)themeFontName;
- (UIFont *)refreshTheme;
- (BOOL)isTheme;

@end

NS_ASSUME_NONNULL_END
