//
//  YYUITextInputIR.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYUITextInputIR : NSObject <NSCopying>

@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) NSRange range;

+ (instancetype)makeWithText:(NSString *)text range:(NSRange)range;
- (instancetype)initWithText:(NSString *)text range:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
