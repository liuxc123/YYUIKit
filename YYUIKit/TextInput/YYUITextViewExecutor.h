//
//  YYUITextViewExecutor.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/30.
//

#import "YYUITextInputExecutor.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYUITextViewExecutor : YYUITextInputExecutor <UITextViewDelegate>

@property (nonatomic, weak, readonly) UITextView *textView;

- (instancetype)initWithTextView:(UITextView *)textView delegate:(id)delegate;

@end

NS_ASSUME_NONNULL_END
