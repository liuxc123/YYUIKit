//
//  UIApplication+YYUIAppExtensions.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import "UIApplication+YYUIAppExtensions.h"

@implementation UIApplication (YYUIAppExtensions)

+ (UIApplication *)yyui_safeSharedApplication {
  static UIApplication *application;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    if (![self yyui_isAppExtension]) {
      // We can't call sharedApplication directly or else this won't build for app extensions.
      application = [[UIApplication class] performSelector:@selector(sharedApplication)];
    }
  });
  return application;
}

+ (BOOL)yyui_isAppExtension {
  static BOOL isAppExtension;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    isAppExtension =
        [[[NSBundle mainBundle] executablePath] rangeOfString:@".appex/"].location != NSNotFound;
  });
  return isAppExtension;
}

@end
