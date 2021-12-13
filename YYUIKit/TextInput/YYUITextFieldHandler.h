//
//  YYUITextFieldHandler.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/30.
//

#import "YYUITextInputHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYUITextFieldHandler : YYUITextInputHandler <UITextFieldDelegate>

@property (nonatomic, weak, readonly) UITextField *textField;

- (instancetype)initWithTextField:(UITextField *)textField delegate:(nullable id)delegate;

@end

NS_ASSUME_NONNULL_END
