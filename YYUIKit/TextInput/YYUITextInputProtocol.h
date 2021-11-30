//
//  YYUITextInputProtocol.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/30.
//

#import <UIKit/UIKit.h>
#import "YYUITextInputMatch.h"
#import "YYUITextInputReplace.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YYUITextInputProtocol <NSObject>

@property (nonatomic, strong) NSArray<YYUITextInputMatch *> *matchs;

@property (nonatomic, strong) NSArray<YYUITextInputReplace *> *replaces;

@property (nonatomic, assign) NSInteger wordLimit;

@property (nonatomic, assign) BOOL emojiLimit;

@property (nonatomic, copy) void (^overWordLimitEvent)(NSString *text);

@property (nonatomic, copy) void (^emojiLimitEvent)(NSString *text);

@property (nonatomic, copy) void (^textDidChangeEvent)(NSString *text);

@end

NS_ASSUME_NONNULL_END
