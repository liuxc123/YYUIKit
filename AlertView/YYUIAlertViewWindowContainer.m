//
//  YYUIAlertViewWindowContainer.m
//  CatalogByConvention
//
//  Created by liuxc on 2021/12/2.
//

#import "YYUIAlertViewWindowContainer.h"

@implementation YYUIAlertViewWindowContainer

- (instancetype)initWithWindow:(UIWindow *)window {
    self = [super init];
    if (self) {
        self.window = window;
    }
    return self;
}

+ (instancetype)containerWithWindow:(UIWindow *)window {
    return [[self alloc] initWithWindow:window];
}

@end

