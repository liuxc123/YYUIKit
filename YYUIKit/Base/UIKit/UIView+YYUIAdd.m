//
//  UIView+YYUIAdd.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/29.
//

#import "UIView+YYUIAdd.h"
#import "UIApplication+YYAdd.h"

@implementation UIView (YYUIAdd)

- (UIEdgeInsets)yyui_safeAreaInsets {
    if (@available(iOS 11.0, *)) {
        return [UIApplication sharedExtensionApplication].keyWindow.safeAreaInsets;
    } else {
        return [UIApplication sharedExtensionApplication].keyWindow.layoutMargins;
    }
}

@end
