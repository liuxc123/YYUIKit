//
//  AppDelegate.m
//  YYUICatalog
//
//  Created by liuxc on 2021/11/16.
//

#import "AppDelegate.h"

@interface AppDelegate () <YYUIAppBarNavigationControllerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // root
    UIViewController *rootViewController = [[CBCNodeListViewController alloc] initWithNode:CBCCreateNavigationTree()];
    rootViewController.title = @"Catalog by YYUIKit";
    
    // nav
    YYUIAppBarNavigationController *nav = [[YYUIAppBarNavigationController alloc] initWithRootViewController:rootViewController];
    nav.delegate = self;
    self.window.rootViewController = nav;
    
    // set key and visible
    [self.window makeKeyAndVisible];
            
    return YES;
}

- (void)appBarNavigationController:(YYUIAppBarNavigationController *)navigationController
       willAddAppBarViewController:(YYUIAppBarViewController *)appBarViewController asChildOfViewController:(UIViewController *)viewController {
    
}

@end
