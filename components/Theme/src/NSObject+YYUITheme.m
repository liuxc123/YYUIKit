//
//  NSObject+YYUITheme.m
//  CocoaLumberjack
//
//  Created by liuxc on 2021/10/24.
//

#import "NSObject+YYUITheme.h"
#import "YYUIThemeManager.h"
#import <objc/runtime.h>

@implementation NSObject (YYUITheme)

- (void)setThemeDidChange:(void (^)(NSString*, id))themeDidChange {
    objc_setAssociatedObject(self, @selector(themeDidChange), themeDidChange, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (themeDidChange) {
        [YYUIThemeManager addTrackedWithObject:self];
    } else {
        [YYUIThemeManager removeTrackedWithObject:self];
    }
}

- (void (^)(NSString*, id))themeDidChange {
    return objc_getAssociatedObject(self, @selector(themeDidChange));
}

- (void)refreshTheme {}

@end
