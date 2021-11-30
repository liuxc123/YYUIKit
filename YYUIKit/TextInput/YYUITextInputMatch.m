//
//  YYUITextInputMatch.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/30.
//

#import "YYUITextInputMatch.h"

@implementation YYUITextInputMatch

- (instancetype)initWithRule:(BOOL (^)(NSString *text))rule
{
    self = [super init];
    if (self) {
        self.rule = rule;
    }
    return self;
}

- (instancetype)initWithPattern:(NSString *)pattern
{
    self = [super init];
    if (self) {
        self.rule = ^BOOL(NSString *text){
            NSError *error = nil;
            NSRegularExpression *reg = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
            if (!error) {
                NSArray<NSTextCheckingResult *> *result = [reg matchesInString:text options:NSMatchingReportCompletion range:NSMakeRange(0, text.length)];
                return (int)result.count > 0;
            }
            return YES;
        };
    }
    return self;
}

@end
