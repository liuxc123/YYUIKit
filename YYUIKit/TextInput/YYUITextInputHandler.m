//
//  YYUITextInputHandler.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/30.
//

#import "YYUITextInputHandler.h"
#import "YYUIKitMacro.h"
#import "NSString+YYUIAdd.h"

@implementation YYUITextInputHandler

#pragma mark - public methods

- (void)commonInit {
    self.matchs = [NSMutableArray array];
    self.replaces = [NSMutableArray array];
}

- (YYUITextInputIR *)textDidChange:(id<UITextInput>)textInput text:(NSString *)text {
    
    if (textInput.markedTextRange) {
        return nil;
    }
    
    NSValue *range = [self getSelectedTextRange:textInput];
    if (!range) { return nil; }
    
    YYUITextInputIR *ir = [YYUITextInputIR makeWithText:text range:[range rangeValue]];
    return [self replacesWithIR: ir];
}

- (BOOL)shouldChange:(id<UITextInput>)textInput range:(NSRange)range string:(NSString *)string {
    
    if (textInput.markedTextRange) {
        return YES;
    }
    
    UITextRange *allRange = [textInput textRangeFromPosition:[textInput beginningOfDocument] toPosition:[textInput endOfDocument]];
    NSString *text = [textInput textInRange: allRange];
    if (!text) { return YES; }
    
    YYUITextInputIR *ir = [self getAfterInputText:text string:string range:range];
    YYUITextInputIR *ir1 = [self replacesWithIR: ir];

    if (![self matchWithText:ir1.text]) {
        return NO;
    }
    
    return YES;
}

- (void)setSelectedTextRange:(id<UITextInput>)textInput range:(NSValue *)range {
    UITextPosition *beginning = textInput.beginningOfDocument;
    UITextPosition *start = [textInput positionFromPosition:beginning offset:[range rangeValue].location];
    UITextPosition *end = [textInput positionFromPosition:beginning offset:[range rangeValue].location + [range rangeValue].length];
    if (!range) { return; }
    if (!start) { return; }
    if (!end)   { return; }
    UITextRange *selectionRange = [textInput textRangeFromPosition:start toPosition:end];
    textInput.selectedTextRange = selectionRange;
}

- (NSValue *)getSelectedTextRange:(id<UITextInput>)textInput {
    UITextRange *range = textInput.selectedTextRange;
    if (!range) { return nil; }
    NSInteger location = [textInput offsetFromPosition:textInput.beginningOfDocument toPosition:range.start];
    NSInteger length = [textInput offsetFromPosition:range.start toPosition:range.end];
    return [NSValue valueWithRange:NSMakeRange(location, length)];
}

#pragma mark - private methods

- (YYUITextInputIR *)getAfterInputText:(NSString *)text string:(NSString *)string range:(NSRange)range {
    NSString *resultText = text;
    NSRange resultRange = range;
    
    NSUInteger startIndex = range.location;
    NSUInteger endIndex = range.location + range.length;
        
    if (string && ![string isEqualToString:@""]) { // 输入操作
        
        resultRange.length = 0;
        resultRange.location += string.length;
        resultText = [[[resultText substringToIndex:startIndex] stringByAppendingString:string] stringByAppendingString:[resultText substringFromIndex:endIndex]];

    }
    else { // 删除操作
        
        resultRange.length = 0;
        resultRange.location -= string.length;
        resultText = [[resultText substringToIndex:startIndex] stringByAppendingString:[resultText substringFromIndex:endIndex]];
    }
    
    return [YYUITextInputIR makeWithText:resultText range:resultRange];
}

- (BOOL)matchWithText:(NSString *)text {
    
    if (!text || text.length == 0) {
        return YES;
    }
    
    NSMutableArray *matchs = [NSMutableArray arrayWithArray:self.matchs];
    [matchs appendObject:[self workLimitMatch]];
    [matchs appendObject:[self emojiLimitMatch]];

    if (matchs) {
        for (YYUITextInputMatch *match in matchs) {
            if (!match.rule(text)) {
                return false;
            }
        }
    }
    
    return YES;
}

- (YYUITextInputMatch *)workLimitMatch {
    @weakify(self);
    return [[YYUITextInputMatch alloc] initWithRule:^BOOL(NSString * _Nonnull text) {
        @strongify(self);
        if (text.length > self.wordLimit) {
            if (self.overWordLimitEvent) {
                self.overWordLimitEvent(text);
            }
            return NO;
        }
        return YES;
    }];
}

- (YYUITextInputMatch *)emojiLimitMatch {
    @weakify(self);
    return [[YYUITextInputMatch alloc] initWithRule:^BOOL(NSString * _Nonnull text) {
        @strongify(self);
        if (self.emojiLimit) {
            return ![text containsEmoji];
        }
        return YES;
    }];
}

- (YYUITextInputIR *)replacesWithIR:(YYUITextInputIR *)ir {
    return [self replaceWithIR:[self replaceEmojiLimit: [self replaceWordLimit:ir]]];
}

- (YYUITextInputIR *)replaceWithIR:(YYUITextInputIR *)ir {
    if (!(self.replaces && self.replaces.count > 0)) {
        return ir;
    }
    
    NSString *text = ir.text;
    NSRange range = ir.range;
    NSUInteger offset = 0;
    
    for (YYUITextInputReplace *item in self.replaces) {
        NSArray *list = [text componentsSeparatedByString:item.key];
        if (list.count == 0) { continue; }
        offset += (list.count - 1) + (item.value.length - item.key.length);
        text = [list componentsJoinedByString:item.value];
    }

    range.length = MAX(0, range.length + offset);
    range.location = MAX(0, range.location + offset);
    
    return [YYUITextInputIR makeWithText:text range:range];
}

- (YYUITextInputIR *)replaceWordLimit:(YYUITextInputIR *)ir {
    NSString *text = ir.text;
    NSRange range = ir.range;
    
    text = [text substringToIndex:MIN(self.wordLimit, text.length)];
    range.length = MIN(self.wordLimit, range.length);
    range.location = MIN(self.wordLimit, range.location);
    return [YYUITextInputIR makeWithText:text range:range];
}

- (YYUITextInputIR *)replaceEmojiLimit:(YYUITextInputIR *)ir {
    NSString *text = ir.text;
    NSRange range = ir.range;
    NSUInteger offset = 0;

    if (self.emojiLimit) {
        NSString *buffer = [[NSMutableString alloc] initWithCapacity:text.length];
        for (int i = 0; i < text.length; i++) {
            NSString *temp = [text substringWithRange:NSMakeRange(i, 1)];
            if ([temp isEmoji]) {
                offset -= 1;
            } else {
                buffer = [buffer stringByAppendingString:temp];
            }
        }
        text = buffer;
        range.length = MAX(0, range.length + offset);
        range.location = MAX(0, range.location + offset);
    }
    return [YYUITextInputIR makeWithText:text range:range];
}

@end
