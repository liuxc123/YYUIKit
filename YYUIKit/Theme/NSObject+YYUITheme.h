//
//  NSObject+YYUITheme.h
//  CocoaLumberjack
//
//  Created by liuxc on 2021/10/24.
//

#import <Foundation/Foundation.h>
#import "YYUIThemeManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (YYUITheme) <YYUIThemeProtocol>

/// APP主题发生改变时回调。
@property (nonatomic, copy) void(^themeDidChange)(NSString *themeName, id bindView);

@end

NS_ASSUME_NONNULL_END
