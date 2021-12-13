//
//  YYUITextViewExecutor.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/30.
//

#import "YYUITextInputHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYUITextViewHandler : YYUITextInputHandler <UITextViewDelegate>

@property (nonatomic, weak, readonly) UITextView *textView;

- (instancetype)initWithTextView:(UITextView *)textView delegate:(nullable id)delegate;

@end

NS_ASSUME_NONNULL_END
