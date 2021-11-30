//
//  YYUITextInputIR.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/30.
//

#import "YYUITextInputIR.h"

@implementation YYUITextInputIR

- (instancetype)initWithText:(NSString *)text range:(NSRange)range
{
    self = [super init];
    if (self) {
        self.text = text;
        self.range = range;
    }
    return self;
}

+ (instancetype)makeWithText:(NSString *)text range:(NSRange)range {
    return [[self alloc] initWithText:text range:range];
}

@end
