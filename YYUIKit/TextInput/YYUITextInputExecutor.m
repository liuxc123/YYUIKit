//
//  YYUITextInputExecutor.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/30.
//

#import "YYUITextInputExecutor.h"

@implementation YYUITextInputExecutor

#pragma mark - public methods

- (void)commonInit {}

- (YYUITextInputIR *)textDidChange:(id<UITextInput>)textInput text:(NSString *)text {
    return [YYUITextInputIR makeWithText:text range:NSMakeRange(0, text.length)];
}

- (BOOL)shouldChange:(id<UITextInput>)textInput range:(NSRange)range string:(NSString *)string {
    return YES;
}

- (void)setSelectedTextRange:(id<UITextInput>)textInput range:(NSRange)range {
    UITextPosition *begin = textInput.beginningOfDocument;
    UITextPosition *start = [textInput positionFromPosition:begin offset:range.location];
    UITextPosition *end = [textInput positionFromPosition:begin offset:range.location + range.length];
    textInput.selectedTextRange = [textInput textRangeFromPosition:start toPosition:end];
}

- (NSRange)getSelectedTextRange:(id<UITextInput>)textInput {
    UITextRange *range = textInput.selectedTextRange;
    NSInteger location = [textInput offsetFromPosition:textInput.beginningOfDocument toPosition:range.start];
    NSInteger length = [textInput offsetFromPosition:range.start toPosition:range.end];
    return NSMakeRange(location, length);
}

#pragma mark - private methods

- (BOOL)matchWithText:(NSString *)text {
    
    if (!text || text.length == 0) {
        return YES;
    }
    
    if (self.matchs) {
        for (YYUITextInputMatch *match in self.matchs) {
            if (!match.rule(text)) {
                return false;
            }
        }
    }
    
    return YES;
}

@end
