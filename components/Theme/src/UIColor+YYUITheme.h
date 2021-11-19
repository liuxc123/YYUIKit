//
//  UIColor+YYUITheme.h
//  CocoaLumberjack
//
//  Created by liuxc on 2021/10/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef UIColor *_Nullable(^YYUIColorThemeProvider)(NSString *themeName);

@interface UIColor (YYUITheme)

@property (nonatomic, copy) NSString *themeColorName;
@property (nonatomic, copy) YYUIColorThemeProvider themeProvider;

+ (UIColor *)colorWithHexString:(NSString *)hexString;

+ (UIColor *)themeColor:(NSString *)themeColorName;
+ (CGColorRef)themeCGColor:(NSString *)themeColorName;
+ (UIColor *)colorWithThemeProvider:(YYUIColorThemeProvider)themeProvider;
- (UIColor *)refreshTheme;
- (BOOL)isTheme;

@end

NS_ASSUME_NONNULL_END
