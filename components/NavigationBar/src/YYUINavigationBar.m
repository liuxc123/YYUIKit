//
//  YYUINavigationBar.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/17.
//

#import "YYUINavigationBar.h"

@interface YYUINavigationBar ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UINavigationBarAppearance *appearance API_AVAILABLE(ios(13.0));

@end

@implementation YYUINavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    if (@available(iOS 11.0, *)) {
        self.layoutPaddings = UIEdgeInsetsMake(0, 8, 0, 8);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self _layoutSubviews];
}

- (void)_layoutSubviews {
    UIView *background = [self.subviews firstObject];
    if (!background) {
        return;
    }
    background.alpha = self.alpha;
    background.clipsToBounds = YES;
    background.frame = self.bounds;
    
    [self adjustsLayoutMarginsAfterIOS11];
}

- (void)adjustsLayoutMarginsAfterIOS11 {
    if (@available(iOS 11.0, *)) {
        
        self.layoutMargins = UIEdgeInsetsMake(8, 16, 8, 16);
        
        if (!self.contentView) { return; }
        
        if (@available(iOS 13.0, *)) {
            self.contentView.frame = CGRectMake(self.layoutPaddings.left - self.layoutMargins.left,
                                                0,
                                                self.layoutMargins.left
                                                + self.layoutMargins.right
                                                - self.layoutPaddings.left
                                                - self.layoutPaddings.right
                                                + self.contentView.frame.size.width,
                                                self.contentView.frame.size.height);
        } else {
            CGRect frame = self.contentView.frame;
            frame.origin.y = 0;
            self.contentView.frame = frame;
            self.contentView.layoutMargins = self.layoutPaddings;
        }
    }
}

- (void)setViewController:(UIViewController *)viewController {
    _viewController = viewController;
    
    self.backBarButtonItem.navigationController = self.viewController.navigationController;
}

- (void)setBackBarButtonItem:(YYUIBackBarButtonItem *)backBarButtonItem {
    _backBarButtonItem = backBarButtonItem;
    
    _backBarButtonItem.navigationController = self.viewController.navigationController;
    self.viewController.navigationItem.leftBarButtonItem = _backBarButtonItem;
}

- (void)setTitleAlpha:(CGFloat)alpha {
    UIColor *color = self.titleTextAttributes[NSForegroundColorAttributeName] ?: [self defaultTitleColor];
    [self setTitleColor:[color colorWithAlphaComponent:alpha]];
}

- (void)setLargeTitleAlpha:(CGFloat)alpha {
    UIColor *color = self.largeTitleTextAttributes[NSForegroundColorAttributeName] ?: [self defaultTitleColor];
    [self setLargeTitleColor:[color colorWithAlphaComponent:alpha]];
}

- (void)setTintAlpha:(CGFloat)alpha {
    self.tintColor = [self.tintColor colorWithAlphaComponent:alpha];
}

- (UIColor *)defaultTitleColor {
    return self.barStyle == UIBarStyleDefault ? UIColor.blackColor : UIColor.whiteColor;
}

- (void)setTitleColor:(UIColor *)color {
    if (self.titleTextAttributes) {
        NSMutableDictionary<NSAttributedStringKey, id> *titleTextAttributes = [self.titleTextAttributes mutableCopy];
        titleTextAttributes[NSForegroundColorAttributeName] = color;
        self.titleTextAttributes = titleTextAttributes;
    } else {
        self.titleTextAttributes = @{NSForegroundColorAttributeName: color};
    }
}

- (void)setLargeTitleColor:(UIColor *)color API_AVAILABLE(ios(11.0)) {
    if (self.largeTitleTextAttributes) {
        NSMutableDictionary<NSAttributedStringKey, id> *largeTitleTextAttributes = [self.largeTitleTextAttributes mutableCopy];
        largeTitleTextAttributes[NSForegroundColorAttributeName] = color;
        self.largeTitleTextAttributes = largeTitleTextAttributes;
    } else {
        self.largeTitleTextAttributes = @{NSForegroundColorAttributeName: color};
    }
}

- (void)observeNavigationItem:(UINavigationItem *)navigationItem {
  [self setItems:@[navigationItem]];
}

- (void)unobserveNavigationItem {
    [self setItems:@[]];
}

#pragma mark - override

- (void)setTranslucent:(BOOL)translucent {
    [super setTranslucent:translucent];
    
    if (@available(iOS 13.0, *)) {
        if (translucent) { return; }
        self.appearance.backgroundEffect = nil;
        [self updateAppearance:self.appearance];
    }
}

- (void)setAlpha:(CGFloat)alpha {
    [super setAlpha:alpha];
    
    UIView *background = self.subviews.firstObject;
    background.alpha = alpha;
}

- (void)setBarTintColor:(UIColor *)barTintColor {
    [super setBarTintColor:barTintColor];
    
    if (@available(iOS 13.0, *)) {
        self.appearance.backgroundColor = barTintColor;
        [self updateAppearance:self.appearance];
    }
}

/// map to barTintColor
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    self.barTintColor = backgroundColor;
}

- (void)setShadowImage:(UIImage *)shadowImage {
    [super setShadowImage:shadowImage];
    
    if (@available(iOS 13.0, *)) {
        self.appearance.shadowImage = shadowImage;
        [self updateAppearance:self.appearance];
    }
}

- (void)setTitleTextAttributes:(NSDictionary<NSAttributedStringKey,id> *)titleTextAttributes {
    [super setTitleTextAttributes:titleTextAttributes];
    
    if (@available(iOS 13.0, *)) {
        self.appearance.titleTextAttributes = titleTextAttributes;
        [self updateAppearance:self.appearance];
    }
}

- (void)setPrefersLargeTitles:(BOOL)prefersLargeTitles {
    [super setPrefersLargeTitles:prefersLargeTitles];
        
    if (@available(iOS 13.0, *)) {
        [self updateAppearance:self.appearance];
    }
}

- (void)setLargeTitleTextAttributes:(NSDictionary<NSAttributedStringKey,id> *)largeTitleTextAttributes {
    [super setLargeTitleTextAttributes:largeTitleTextAttributes];
     
    if (@available(iOS 13.0, *)) {
        self.appearance.largeTitleTextAttributes = largeTitleTextAttributes;
        [self updateAppearance:self.appearance];
    }
}

- (void)setBackgroundImage:(UIImage *)backgroundImage forBarMetrics:(UIBarMetrics)barMetrics {
    [super setBackgroundImage:backgroundImage forBarMetrics:barMetrics];
    
    if (@available(iOS 13.0, *)) {
        self.appearance.backgroundImage = backgroundImage;
        [self updateAppearance:self.appearance];
    }
}


#pragma mark - private methods

- (UIView *)contentView {
    if (!_contentView) {
        for (UIView *view in self.subviews) {
            if ([NSStringFromClass([view class]) isEqualToString:@"_UINavigationBarContentView"]) {
                _contentView = view;
                break;
            }
        }
    }
    return _contentView;
}

- (UINavigationBarAppearance *)appearance {
    if (!_appearance) {
        _appearance = [[UINavigationBarAppearance alloc] init];
        _appearance.backgroundColor = self.barTintColor;
        _appearance.titleTextAttributes = self.titleTextAttributes ?: @{};
        _appearance.largeTitleTextAttributes = self.largeTitleTextAttributes ?: @{};
    }
    return _appearance;
}

- (void)updateAppearance:(UINavigationBarAppearance *)appearance API_AVAILABLE(ios(13.0)) {
    self.standardAppearance = appearance;
    self.compactAppearance = appearance;
    self.scrollEdgeAppearance = appearance;
}

@end
