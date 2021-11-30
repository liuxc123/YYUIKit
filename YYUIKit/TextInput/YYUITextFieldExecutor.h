//
//  YYUITextFieldExecutor.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/30.
//

#import "YYUITextInputExecutor.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYUITextFieldExecutor : YYUITextInputExecutor <UITextFieldDelegate>

@property (nonatomic, weak, readonly) UITextField *textField;

- (instancetype)initWithTextField:(UITextField *)textField delegate:(id)delegate;

@end

NS_ASSUME_NONNULL_END
