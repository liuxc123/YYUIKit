//
//  AppDelegate.m
//  YYUICatalog
//
//  Created by liuxc on 2021/11/16.
//

#import "AppDelegate.h"
#import <CatalogByConvention/CatalogByConvention.h>
#import "YYOverlayWindow.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

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
    appBarViewController.headerView.backgroundColor = UIColor.whiteColor;
    appBarViewController.navigationBar.backgroundColor = UIColor.whiteColor;
    appBarViewController.navigationBar.tintColor = UIColor.blackColor;
//    appBarViewController.navigationBar.viewController = viewController;
//    if (navigationController.viewControllers.count > 1) {
//        appBarViewController.navigationBar.backBarButtonItem = [[YYUIBackBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain tintColor:nil];
//    }
    appBarViewController.hairlineColor = UIColor.blackColor;
    appBarViewController.showsHairline = YES;
  
}

@end
