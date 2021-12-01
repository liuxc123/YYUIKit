//
//  NSString+YYUIAdd.m
//  YYUIKit
//
//  Created by liuxc on 2021/12/1.
//

#import "NSString+YYUIAdd.h"

@implementation NSString (YYUIAdd)

/*
 支持版本为 Unicode 14.0 及以下，即 iOS15.0 及以下
 Unicode 和 Emoji 版本更新后需要及时更新码点枚举值
 */

- (BOOL)containsEmoji {
    __block BOOL containsEmoji = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop)
     {
        if ([substring isEmoji]) {
            containsEmoji = YES;
            *stop = YES;
        }
    }];
    return containsEmoji;
}

- (BOOL)isEmoji {
    // 确保字符不为空
    if (self.length <= 0) {
        return NO;
    }
    // 确保字符为单字符
    __block BOOL isSingalString = YES;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop)
     {
        if (substringRange.location > 0) {
            isSingalString = NO;
            *stop = YES;
        }
    }];
    if (!isSingalString) {
        return NO;
    }
    // 取一个 UTF-16 单元即前两个字节判断是否为 UTF-32 编码
    const unichar hs = [self characterAtIndex:0];
    if (0xd800 <= hs && hs <= 0xdbff) {
        // 对 UTF-32 格式编码进行码点转换
        if (self.length > 1) {
            const unichar ls = [self characterAtIndex:1];
            const unsigned long long codepoint = (((unsigned long long)hs - 0xd800) * 0x400) + ((unsigned long long)ls - 0xdc00) + 0x10000;
            // 码点模糊匹配
            if (0x1d000 <= codepoint && codepoint <= 0x1faff) {
                return YES;
            } else {
                return NO;
            }
        } else {
            return NO;
        }
    } else if (self.length > 1) {
        // 特殊的组合编码 Emoji 枚举
        const unichar ls = [self characterAtIndex:1];
        return ls == 0x20e3 || ls == 0xfe0f || ls == 0xd83c;
    } else {
        // UTF-16 格式的 Emoji 枚举
        if (0x2100 <= hs && hs <= 0x278a) {
            return YES;
        } else if (0x2793 <= hs && hs <= 0x27ff) {
            return YES;
        } else if (0x2b05 <= hs && hs <= 0x2b07) {
            return YES;
        } else if (0x2b1b <= hs && hs <= 0x2b1c) {
            return YES;
        } else if (0x2b50 == hs) {
            return YES;
        } else if (0x2b55 == hs) {
            return YES;
        } else if (0x2934 <= hs && hs <= 0x2935) {
            return YES;
        } else if (0x3030 == hs) {
            return YES;
        } else if (0x303d == hs) {
            return YES;
        } else if (0x3297 <= hs && hs <= 0x3299) {
            return YES;
        } else if (hs == 0xae) {
            return YES;
        } else if (hs == 0xae) {
            return YES;
        } else {
            return NO;
        }
    }
}

@end
