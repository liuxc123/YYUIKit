//
//  YYUITextInputReplace.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/30.
//

#import "YYUITextInputReplace.h"

@implementation YYUITextInputReplace

- (instancetype)initWithFrom:(NSString *)from of:(NSString *)of
{
    self = [super init];
    if (self) {
        self.key = from;
        self.value = of;
    }
    return self;
}

- (NSInteger)offset {
    return self.key.length - self.value.length;
}


@end
