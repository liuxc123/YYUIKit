//
//  YYUINavigationBar.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/17.
//

#import <UIKit/UIKit.h>
#import "YYUIBackBarButtonItem.h"

@interface YYUINavigationBar : UINavigationBar

/// Current viewcontroller
@property (nonatomic, weak) UIViewController * _Nullable viewController;

/// Back button item
@property (nonatomic, strong, nullable) YYUIBackBarButtonItem *backBarButtonItem;

/// Padding of navigation bar content view.
@property (nonatomic, assign) UIEdgeInsets layoutPaddings API_AVAILABLE(ios(11.0));

- (void)setTitleAlpha:(CGFloat)alpha;

- (void)setLargeTitleAlpha:(CGFloat)alpha API_AVAILABLE(ios(11.0));

- (void)setTintAlpha:(CGFloat)alpha;

- (void)observeNavigationItem:(nonnull UINavigationItem *)navigationItem;

- (void)unobserveNavigationItem;

@end
