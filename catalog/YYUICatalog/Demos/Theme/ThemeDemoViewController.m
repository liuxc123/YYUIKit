//
//  ThemeDemoViewController.m
//  YYUICatalog
//
//  Created by liuxc on 2021/11/22.
//

#import "ThemeDemoViewController.h"
#import "ThemeConstant.h"
#import "YYTheme.h"

@interface ThemeDemoViewController ()

@end

@implementation ThemeDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.title = @"Theme Demo1";
    self.view.backgroundColor = [UIColor themeColor:theme_backgroundColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.3 animations:^{
        if ([[YYUIThemeManager sharedManager].currentTheme isEqualToString:theme_style_default]) {
            [YYUIThemeManager changeTheme:theme_style_dark];
        } else {
            [YYUIThemeManager changeTheme:theme_style_default];
        }
    }];
}

@end

@implementation ThemeDemoViewController (CatalogByConvention)

+ (NSDictionary *)catalogMetadata {
    return @{
        @"breadcrumbs" : @[ @"Theme", @"Theme Demo1" ],
        @"primaryDemo" : @NO,
        @"presentable" : @NO,
    };
}

- (BOOL)catalogShouldHideNavigation {
    return YES;
}

@end
