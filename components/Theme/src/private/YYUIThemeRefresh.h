//
//  YYUIThemeRefresh.h
//  CocoaLumberjack
//
//  Created by liuxc on 2021/10/24.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CTStringAttributes.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (YYUIThemeRefresh)

/// 判断是否对象为空
- (BOOL)isEmpty;

/// 遍历NSAttributedStringKey所有类型并执行complete块
- (void)forinNSAttributedStringKey:(void (^) (NSString *key, id obj))complete;

/// 遍历UIControlState所有类型并执行complete块。
- (void)forinUIControlState:(void (^)(UIControlState state, id obj))complete;


/// 遍历UIBarMetrics所有类型并执行complete块
- (void)forinUIBarMetrics:(void (^) (UIBarMetrics metrics, id obj))complete;


/// 遍历UIBarPosition所有类型并执行complete块
- (void)forinUIBarPosition:(void (^) (UIBarPosition position, id obj))complete;


/// 遍历UIBarButtonItemStyle所有类型并执行complete块
- (void)forinUIBarButtonItemStyle:(void (^) (UIBarButtonItemStyle style, id obj))complete;


/// 遍历UISearchBarIcon所有类型并执行complete块
- (void)forinUISearchBarIcon:(void (^) (UISearchBarIcon icon, id obj))complete;

@end

@interface NSMutableAttributedString (YYUIThemeRefresh)

@end

@interface NSMutableDictionary (YYUIThemeRefresh)

@end

@interface CALayer (YYUIThemeRefresh)

@property (nonatomic, nullable) UIColor *borderThemeColor;

@property (nonatomic, nullable) UIColor *backgroundThemeColor;

@property (nonatomic, nullable) UIColor *shadowThemeColor;

@property (nonatomic, nullable) UIImage *contentImage;

@end

@interface CATextLayer (YYUIThemeRefresh)

@property (nonatomic, nullable) UIColor *foregroundThemeColor;

@end

@interface CAShapeLayer (YYUIThemeRefresh)

@property (nonatomic, nullable) UIColor *fillThemeColor;

@property (nonatomic, nullable) UIColor *strokeThemeColor;

@end

@interface CAGradientLayer (YYUIThemeRefresh)

@property (nonatomic, nullable) NSArray *themeColors;

@end

@interface UIView (YYUIThemeRefresh)

@end

NS_ASSUME_NONNULL_END
