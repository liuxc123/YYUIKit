//
//  YYUITextInputMatch.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYUITextInputMatch : NSObject

@property (nonatomic, copy) bool (^rule)(NSString *text);

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithRule:(BOOL (^)(NSString *text))rule;
- (instancetype)initWithPattern:(NSString *)pattern;

@end

NS_ASSUME_NONNULL_END
