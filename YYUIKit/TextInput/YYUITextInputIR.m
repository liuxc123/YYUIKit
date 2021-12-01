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

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    YYUITextInputIR *ir = [[[self class] allocWithZone:zone] init];
    ir.text = self.text;
    ir.range = self.range;
    return ir;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"text: %@, range location: %ld, length: %ld", self.text, self.range.location, self.range.length];
}

@end
