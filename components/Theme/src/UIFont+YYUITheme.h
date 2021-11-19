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

+ (UIFont *)fontWithThemeProvider:(YYUIFontThemeProvider)themeProvider;
- (UIFont *)refreshTheme;
- (BOOL)isTheme;

@end

NS_ASSUME_NONNULL_END
