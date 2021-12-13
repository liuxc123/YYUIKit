//
//  YYUITextViewHandler.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/30.
//

#import "YYUITextViewHandler.h"

@interface YYUITextViewHandler ()

@property (nonatomic, weak) UITextView *textView;

@end

@implementation YYUITextViewHandler

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.textView];
}

- (instancetype)initWithTextView:(UITextView *)textView delegate:(id)delegate
{
    self = [super init];
    if (self) {
        self.textView = textView;
        self.textInputDelegate = delegate;
        self.textView.delegate = self;
    }
    return self;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.textInputDelegate) {
        return [self.textInputDelegate textViewShouldBeginEditing:textView];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (self.textInputDelegate) {
        return [self.textInputDelegate textViewShouldEndEditing:textView];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.textInputDelegate) {
        [self.textInputDelegate textViewDidBeginEditing:textView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.textInputDelegate) {
        [self.textInputDelegate textViewDidEndEditing:textView];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    if (self.textInputDelegate) {
        [self.textInputDelegate textViewDidChangeSelection:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction API_AVAILABLE(ios(10.0)) {
    if (self.textInputDelegate) {
        return [self.textInputDelegate textView:textView shouldInteractWithURL:URL inRange:characterRange interaction:interaction];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction API_AVAILABLE(ios(10.0)) {
    if (self.textInputDelegate) {
        return [self.textInputDelegate textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange interaction:interaction];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange API_DEPRECATED_WITH_REPLACEMENT("textView:shouldInteractWithURL:inRange:interaction:", ios(7.0, 10.0)) {
    if (self.textInputDelegate) {
        return [self.textInputDelegate textView:textView shouldInteractWithURL:URL inRange:characterRange];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange API_DEPRECATED_WITH_REPLACEMENT("textView:shouldInteractWithTextAttachment:inRange:interaction:", ios(7.0, 10.0)) {
    if (self.textInputDelegate) {
        return [self.textInputDelegate textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([self.textInputDelegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        return [self.textInputDelegate textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    return [self shouldChange:textView range:range string:text];
}

- (void)textViewDidChange:(UITextView *)textView {
    YYUITextInputIR *ir = [self textDidChange:textView text:textView.text];
    if (!ir) {
        if (self.textDidChangeEvent) { self.textDidChangeEvent(ir.text); }
        return;
    }
    
    [textView setText:ir.text];
    [self setSelectedTextRange:textView range:[NSValue valueWithRange:ir.range]];
    if (self.textDidChangeEvent) {  self.textDidChangeEvent(ir.text); }
}

@end
