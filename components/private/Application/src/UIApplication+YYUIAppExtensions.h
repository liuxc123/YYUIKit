//
//  UIApplication+YYUIAppExtensions.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import <UIKit/UIKit.h>

/**
 UIApplication extension for working with sharedApplication inside of app extensions.
 */
@interface UIApplication (YYUIAppExtensions)

/**
 Returns sharedApplication if it is available otherwise returns nil.

 This is a wrapper around sharedApplication which is safe to compile and use in app extensions.
 */
+ (UIApplication *)yyui_safeSharedApplication;

/**
 Returns YES if called inside an application extension otherwise returns NO.
 */
+ (BOOL)yyui_isAppExtension;

@end
