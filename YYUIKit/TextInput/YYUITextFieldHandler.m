//
//  YYUITextFieldHandler.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/30.
//

#import "YYUITextFieldHandler.h"

@interface YYUITextFieldHandler ()

@property (nonatomic, weak) UITextField *textField;

@end

@implementation YYUITextFieldHandler

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.textField];
}

- (instancetype)initWithTextField:(UITextField *)textField delegate:(id)delegate
{
    self = [super init];
    if (self) {
        self.textField = textField;
        self.textInputDelegate = delegate;
        self.textField.delegate = self;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.textInputDelegate) {
        return [self.textInputDelegate textFieldShouldBeginEditing:textField];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.textInputDelegate) {
        return [self.textInputDelegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.textInputDelegate) {
        return [self.textInputDelegate textFieldShouldBeginEditing:textField];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.textInputDelegate) {
        return [self.textInputDelegate textFieldDidEndEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason API_AVAILABLE(ios(10.0)) {
    if (self.textInputDelegate) {
        return [self.textInputDelegate textFieldDidEndEditing:textField reason:reason];
    }
}

- (void)textFieldDidChangeSelection:(UITextField *)textField API_AVAILABLE(ios(13.0)) {
    if (self.textInputDelegate) {
        [self.textInputDelegate textFieldDidChangeSelection:textField];
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (self.textInputDelegate) {
        return [self.textInputDelegate textFieldShouldClear:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.textInputDelegate) {
        return [self.textInputDelegate textFieldShouldReturn:textField];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self.textInputDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.textInputDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return [self shouldChange:textField range:range string:string];
}

- (void)textFieldTextDidChange:(NSNotification *)noti {
    UITextField *textField = (UITextField *)noti.object;
    if (!textField) { return; }
    
    YYUITextInputIR *ir = [self textDidChange:textField text:textField.text];
    if (!ir) {
        if (self.textDidChangeEvent) { self.textDidChangeEvent(textField.text); }
        return;
    }
    [textField setText:ir.text];
    [self setSelectedTextRange:textField range:[NSValue valueWithRange:ir.range]];
    if (self.textDidChangeEvent) {  self.textDidChangeEvent(ir.text); }
}

@end
