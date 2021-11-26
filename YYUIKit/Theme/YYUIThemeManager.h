//
//  YYUIThemeManager.h
//  CocoaLumberjack
//
//  Created by liuxc on 2021/10/24.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "YYUIThemeProtocol.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const ThemeDidChangeNotification = @"ThemeDidChangeNotification";

NS_SWIFT_NAME(UIThemeManager)
@interface YYUIThemeManager : NSObject

@property (nonatomic, strong, readonly) NSString *currentTheme;
@property (nonatomic, strong, readonly) NSMutableArray *allTheme;
@property (nonatomic, strong, readonly) NSMutableDictionary *configInfo;
@property (nonatomic, strong, readonly) NSHashTable *trackedHashTable;

+ (instancetype)sharedManager;

+ (void)addTrackedWithObject:(id)object;
+ (void)removeTrackedWithObject:(id)object;

+ (void)defaultTheme:(NSString *)themeName;
+ (void)addTheme:(NSDictionary<NSString*, NSDictionary<NSString*, NSString*>*> *)config themeName:(NSString *)name;
+ (void)removeTheme:(NSString *)themeName;
+ (void)changeTheme:(NSString *)themeName;
+ (NSDictionary *)themeConfig:(NSString *)themeName;

@end

NS_ASSUME_NONNULL_END
