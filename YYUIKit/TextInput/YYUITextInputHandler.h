//
//  YYUITextInputHandler.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/30.
//

#import <UIKit/UIKit.h>
#import "YYUITextInputProtocol.h"
#import "YYUITextInputIR.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYUITextInputHandler : NSObject <YYUITextInputProtocol>

@property (nonatomic, strong) NSMutableArray<YYUITextInputMatch *> *matchs;

@property (nonatomic, strong) NSMutableArray<YYUITextInputReplace *> *replaces;

@property (nonatomic, assign) NSInteger wordLimit;

@property (nonatomic, assign) BOOL emojiLimit;

@property (nonatomic, copy) void (^overWordLimitEvent)(NSString *text);

@property (nonatomic, copy) void (^emojiLimitEvent)(NSString *text);

@property (nonatomic, copy) void (^textDidChangeEvent)(NSString *text);

@property (nonatomic, weak, nullable) id textInputDelegate;

- (BOOL)shouldChange:(id<UITextInput>)textInput range:(NSRange)range string:(NSString *)string;
- (YYUITextInputIR *)textDidChange:(id<UITextInput>)textInput text:(NSString *)text;

- (void)setSelectedTextRange:(id<UITextInput>)textInput range:(nullable NSValue *)range;
- (nullable NSValue *)getSelectedTextRange:(id<UITextInput>)textInput;

@end

@interface YYUITextInputHandleConfig : NSObject

@property (nonatomic, strong) NSMutableArray<YYUITextInputMatch *> *matchs;

@property (nonatomic, strong) NSMutableArray<YYUITextInputReplace *> *replaces;

@property (nonatomic, assign) NSInteger wordLimit;

@property (nonatomic, assign) BOOL emojiLimit;

+ (YYUITextInputHandleConfig *)globalConfig;

@end

NS_ASSUME_NONNULL_END
