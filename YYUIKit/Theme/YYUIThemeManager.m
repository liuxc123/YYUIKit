//
//  YYUIThemeManager.m
//  CocoaLumberjack
//
//  Created by liuxc on 2021/10/24.
//

#import "YYUIThemeManager.h"
#import "NSObject+YYUITheme.h"

static NSString * const YYUIThemeAllThemeKey        = @"YYUIThemeAllThemeKey";
static NSString * const YYUIThemeCurrentThemeKey    = @"YYUIThemeCurrentThemeKey";
static NSString * const YYUIThemeConfigInfoKey      = @"YYUIThemeConfigInfoKey";

#pragma mark - YYUIThemeManager

@interface YYUIThemeManager ()

@property (nonatomic, strong, readwrite) NSString *currentTheme;
@property (nonatomic, strong, readwrite) NSMutableArray *allTheme;
@property (nonatomic, strong, readwrite) NSMutableDictionary *configInfo;
@property (nonatomic, strong, readwrite) NSHashTable *trackedHashTable;

@end

@implementation YYUIThemeManager

#pragma mark - initial

+ (instancetype)sharedManager {
    static YYUIThemeManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [YYUIThemeManager new];
    });
    
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentTheme = [[NSUserDefaults standardUserDefaults] objectForKey:YYUIThemeCurrentThemeKey] ?: @"";
    }
    return self;
}

#pragma mark - public methods

+ (void)defaultTheme:(NSString *)themeName {
    [[YYUIThemeManager sharedManager] defaultTheme:themeName];
}

+ (void)addTheme:(NSDictionary<NSString*, NSDictionary<NSString*, NSString*>*> *)config themeName:(NSString *)name {
    [[YYUIThemeManager sharedManager] addTheme:config themeName:name];
}

+ (void)removeTheme:(NSString *)themeName {
    [[YYUIThemeManager sharedManager] removeTheme:themeName];
}

+ (void)changeTheme:(NSString *)themeName {
    [[YYUIThemeManager sharedManager] changeTheme:themeName];
}

- (void)defaultTheme:(NSString *)themeName {
    
    NSAssert([[YYUIThemeManager sharedManager].configInfo.allKeys containsObject:themeName], @"所启用的主题不存在 - 请检查是否添加了该%@主题的设置" , themeName);
    
    if (!themeName) { return; }
    
    self.currentTheme = themeName;
}

- (void)addTheme:(NSDictionary<NSString*, NSDictionary<NSString*, NSString*>*> *)config themeName:(NSString *)name {
    
    if (!name) { return; }
    
    if (!config) { return; }

    [self.configInfo setValue:config forKey:name];
    
    [self saveConfigInfo];
    
    [YYUIThemeManager addThemeToAllThemes:name];
}

- (void)removeTheme:(NSString *)themeName {
    
    if (!themeName) { return; }
    
    [self.configInfo removeObjectForKey:themeName];
    
    [self saveConfigInfo];
    
    [YYUIThemeManager removeThemeToAllThemes:themeName];
}

- (void)changeTheme:(NSString *)themeName {
    
    NSAssert([[YYUIThemeManager sharedManager].configInfo.allKeys containsObject:themeName], @"所启用的主题不存在 - 请检查是否添加了该%@主题的设置" , themeName);
    
    if (!themeName) { return; }

    self.currentTheme = themeName;
    
    __weak typeof(self) weakSelf = self;
    [self.trackedHashTable.allObjects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf refreshTargetObject:obj];
    }];
    
    /// 发送主题已改变通知
    [[NSNotificationCenter defaultCenter] postNotificationName:ThemeDidChangeNotification object:[YYUIThemeManager sharedManager].currentTheme];
}

+ (NSDictionary *)themeConfig:(NSString *)themeName {
    YYUIThemeManager *manager = [YYUIThemeManager sharedManager];
    return manager.configInfo[themeName];
}

#pragma mark - private methods

- (void)refreshTargetObject:(id)object {
    
    if ([object conformsToProtocol:@protocol(YYUIThemeProtocol)]) {
        
        id<YYUIThemeProtocol> obj = object;

        [obj refreshTheme];
    }
    
    if ([object isKindOfClass:[NSObject class]]) {
        
        NSObject *obj = object;
                
        !obj.themeDidChange ?: obj.themeDidChange(self.currentTheme, obj);
        
    }
} 

+ (void)addTrackedWithObject:(id)object {
    
    [[YYUIThemeManager sharedManager].trackedHashTable addObject:object];
}

+ (void)removeTrackedWithObject:(id)object {
    
    [[YYUIThemeManager sharedManager].trackedHashTable removeObject:object];
}

- (void)setCurrentTheme:(NSString *)currentTheme {
    _currentTheme = currentTheme;
    
    [[NSUserDefaults standardUserDefaults] setObject:currentTheme forKey:YYUIThemeCurrentThemeKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveConfigInfo{
    
    [[NSUserDefaults standardUserDefaults] setObject:self.configInfo forKey:YYUIThemeConfigInfoKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)addThemeToAllThemes:(NSString *)themeName{
    
    if (![[YYUIThemeManager sharedManager].allTheme containsObject:themeName]) {
        
        [[YYUIThemeManager sharedManager].allTheme addObject:themeName];
        
        [[NSUserDefaults standardUserDefaults] setObject:[YYUIThemeManager sharedManager].allTheme forKey:YYUIThemeAllThemeKey];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

+ (void)removeThemeToAllThemes:(NSString *)themeName{
    
    if ([[YYUIThemeManager sharedManager].allTheme containsObject:themeName]) {
        
        [[YYUIThemeManager sharedManager].allTheme removeObject:themeName];
        
        [[NSUserDefaults standardUserDefaults] setObject:[YYUIThemeManager sharedManager].allTheme forKey:YYUIThemeAllThemeKey];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

#pragma mark - Lazy Loading

- (NSHashTable *)trackedHashTable {
    
    if (!_trackedHashTable) {
        _trackedHashTable = [NSHashTable weakObjectsHashTable];
    }
    
    return _trackedHashTable;
}

- (NSMutableArray *)allTheme {
    
    if (!_allTheme) {
        _allTheme = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:YYUIThemeAllThemeKey]];
    }
    
    return _allTheme;
}

- (NSMutableDictionary *)configInfo{
    
    if (!_configInfo) {
        _configInfo = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:YYUIThemeConfigInfoKey]];
    }
    
    return _configInfo;
}

#pragma mark - debug

- (NSString *)description {
    return [NSString stringWithFormat:@"~~~已配置主题：%@\n~~~~主题配置%@", self.allTheme, self.configInfo];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"~~~已配置主题：%@\n~~~所有主题配置%@\n所有存在控件~~~%@", self.allTheme, self.configInfo, self.trackedHashTable];
}

@end
