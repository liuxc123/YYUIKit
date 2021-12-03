//
//  UIApplication+YYUIAdd.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/29.
//

#import "UIApplication+YYUIAdd.h"

@implementation UIApplication (YYUIAdd)

+ (UIEdgeInsets)safeAreaInsets {
    if (@available(iOS 11.0, *)) {
        return [UIApplication sharedExtensionApplication].keyWindow.safeAreaInsets;
    } else {
        return [UIApplication sharedExtensionApplication].keyWindow.layoutMargins;
    }
}

@end
