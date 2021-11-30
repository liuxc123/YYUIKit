//
//  AppDelegate.m
//  YYUICatalog
//
//  Created by liuxc on 2021/11/16.
//

#import "AppDelegate.h"
#import <CatalogByConvention/CatalogByConvention.h>
#import <YYUIKit/YYUIKit.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // root
    UIViewController *rootViewController = [[CBCNodeListViewController alloc] initWithNode:CBCCreateNavigationTree()];
    rootViewController.title = @"Catalog by YYUIKit";
    
    
    // nav
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    self.window.rootViewController = nav;
    
    // set key and visible
    [self.window makeKeyAndVisible];
            
    return YES;
}

@end
