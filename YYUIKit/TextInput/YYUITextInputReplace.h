//
//  YYUITextInputReplace.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYUITextInputReplace : NSObject

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, assign, readonly) NSInteger offset;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrom:(NSString *)from of:(NSString *)of;

@end

NS_ASSUME_NONNULL_END
