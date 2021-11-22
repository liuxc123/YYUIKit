//
//  AppDelegate.m
//  YYUICatalog
//
//  Created by liuxc on 2021/11/16.
//

#import "AppDelegate.h"
#import <CatalogByConvention/CatalogByConvention.h>
#import "YYOverlayWindow.h"
#import "YYTheme.h"
#import "ThemeConstant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // set theme
    [self setupTheme];
    
    self.window = [[YYUIOverlayWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // root
    UIViewController *rootViewController = [[CBCNodeListViewController alloc] initWithNode:CBCCreateNavigationTree()];
    rootViewController.title = @"Catalog by YYUIKit";
    
    
    // nav
    YYUIAppBarNavigationController *nav = [[YYUIAppBarNavigationController alloc] init];
    nav.delegate = self;
    [nav setViewControllers:@[rootViewController]];
    self.window.rootViewController = nav;
    
    // set key and visible
    [self.window makeKeyAndVisible];
    

    
    return YES;
}

- (void)appBarNavigationController:(YYUIAppBarNavigationController *)navigationController willAddAppBarViewController:(YYUIAppBarViewController *)appBarViewController asChildOfViewController:(UIViewController *)viewController {
    appBarViewController.headerView.backgroundColor = [UIColor themeColor:theme_backgroundColor];
    appBarViewController.navigationBar.backgroundColor = [UIColor themeColor:theme_backgroundColor];
    appBarViewController.navigationBar.tintColor = [UIColor themeColor:theme_textlabel1];
    
    appBarViewController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont themeSystemFont:theme_title_font1], NSForegroundColorAttributeName: [UIColor themeColor:theme_textlabel1]};
    appBarViewController.headerView.shadowLayer.hidden = YES;
    appBarViewController.navigationBar.viewController = viewController;
    if (navigationController.viewControllers.count > 1) {
        appBarViewController.navigationBar.backBarButtonItem = [[YYUIBackBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain tintColor:nil];
    }
    appBarViewController.hairlineColor = UIColor.blackColor;
    appBarViewController.showsHairline = YES;
}

- (void)setupTheme {
    
    NSDictionary *defaultThemeConfig = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"theme_default" ofType:@"plist"]];
    [YYUIThemeManager addTheme:defaultThemeConfig themeName: theme_style_default];

    NSDictionary *darkThemeConfig = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"theme_dark" ofType:@"plist"]];
    [YYUIThemeManager addTheme:darkThemeConfig themeName: theme_style_dark];
    
    [YYUIThemeManager defaultTheme:theme_style_default];
}

@end
