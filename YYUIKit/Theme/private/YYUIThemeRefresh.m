//
//  YYUIThemeRefresh.m
//  CocoaLumberjack
//
//  Created by liuxc on 2021/10/24.
//

#import "YYUIThemeRefresh.h"

#import "NSObject+YYUITheme.h"
#import "UIColor+YYUITheme.h"
#import "UIImage+YYUITheme.h"
#import "UIFont+YYUITheme.h"
#import "YYUIThemeManager.h"

#import "YYLabel.h"
#import "YYTextView.h"

#import <objc/runtime.h>

@implementation NSObject (YYUIThemeRefresh)

- (BOOL)isEmpty {
    return !(([self respondsToSelector:@selector(length)] && [(NSData *)self length] > 0)
             || ([self respondsToSelector:@selector(count)] && [(NSArray *)self count] > 0)
             || ([self respondsToSelector:@selector(floatValue)] && [(id)self floatValue] != 0.0));
}

- (void)forinNSAttributedStringKey:(void (^)(NSString * _Nonnull, id _Nonnull))complete {
    for (NSString *key in [NSObject AttributedStringKeyArray]) {
        !complete ?: complete(key, self);
    }
}

- (void)forinUIControlState:(void (^)(UIControlState, id))complete {
    for (NSNumber *obj in [NSObject ControlStateArray]) {
        UIControlState state = [obj integerValue];
        !complete ?: complete(state, self);
    }
}

- (void)forinUIBarMetrics:(void (^) (UIBarMetrics metrics, id obj))complete {
    for (NSNumber *obj in [NSObject BarMetricsArray]) {
        UIBarMetrics metrics = [obj integerValue];
        !complete ?: complete(metrics, self);
    }
}

- (void)forinUIBarPosition:(void (^) (UIBarPosition position, id obj))complete {
    for (NSNumber *obj in [NSObject BarPositionArray]) {
        UIBarPosition position = [obj integerValue];
        !complete ?: complete(position, self);
    }
}

- (void)forinUIBarButtonItemStyle:(void (^) (UIBarButtonItemStyle style, id obj))complete {
    for (NSNumber *obj in [NSObject BarButtonItemStyleArray]) {
        UIBarButtonItemStyle style = [obj integerValue];
        !complete ?: complete(style, self);
    }
}

- (void)forinUISearchBarIcon:(void (^) (UISearchBarIcon icon, id obj))complete {
    for (NSNumber *obj in [NSObject SearchBarIconArray]) {
        UISearchBarIcon icon = [obj integerValue];
        !complete ?: complete(icon, self);
    }
}

+ (NSArray<NSNumber *> *)ControlStateArray {
    static NSArray<NSNumber *> *controlStateArtray = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controlStateArtray = @[
            @(UIControlStateNormal),
            @(UIControlStateHighlighted),
            @(UIControlStateDisabled),
            @(UIControlStateSelected),
            @(UIControlStateFocused)
        ];
    });
    return controlStateArtray;
}

+ (NSArray<NSNumber *> *)BarMetricsArray {
    static NSArray<NSNumber *> *barMetricsArray = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        barMetricsArray = @[
            @(UIBarMetricsDefault),
            @(UIBarMetricsCompact)
        ];
    });
    return barMetricsArray;
}

+ (NSArray<NSNumber *> *)BarPositionArray {
    static NSArray<NSNumber *> *BarPositionArray = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BarPositionArray = @[
            @(UIBarPositionAny),
            @(UIBarPositionTop),
            @(UIBarPositionTopAttached)
        ];
    });
    return BarPositionArray;
}

+ (NSArray<NSNumber *> *)BarButtonItemStyleArray {
    static NSArray<NSNumber *> *BarButtonItemStyleArray = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BarButtonItemStyleArray = @[
            @(UIBarButtonItemStylePlain),
            @(UIBarButtonItemStyleDone)
        ];
    });
    return BarButtonItemStyleArray;
}

+ (NSArray<NSNumber *> *)SearchBarIconArray {
    static NSArray<NSNumber *> *SearchBarIconArray = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SearchBarIconArray = @[
            @(UISearchBarIconSearch),
            @(UISearchBarIconClear),
            @(UISearchBarIconBookmark),
            @(UISearchBarIconResultsList)
        ];
    });
    return SearchBarIconArray;
}

+ (NSArray<NSString *> *)AttributedStringKeyArray {
    static NSArray<NSString *> *AttributedStringKeyArray = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AttributedStringKeyArray = @[
            NSForegroundColorAttributeName,
            NSShadowAttributeName,
            NSBackgroundColorAttributeName,
            NSStrikethroughColorAttributeName,
            NSStrokeColorAttributeName,
            NSUnderlineColorAttributeName,
            NSAttachmentAttributeName,
            NSFontAttributeName
        ];
    });
    return AttributedStringKeyArray;
}

@end

@implementation NSMutableAttributedString (YYUIThemeRefresh)

- (void)refreshTheme {
    if ([self isEmpty]) return;

    [self enumerateAttributesInRange:NSMakeRange(0, self.length) options:kNilOptions usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        [self forinNSAttributedStringKey:^(NSString * _Nonnull key, id  _Nonnull obj) {
            id value = [attrs objectForKey:key];
            
            if (!value) return;
            
            if ([value isKindOfClass:UIColor.class]) {
                UIColor *color = (UIColor *)value;
                if (color.isTheme) {
                    color = [color refreshTheme];
                    [self addAttribute:key value:color range:range];
                    if ([key isEqualToString:NSForegroundColorAttributeName]) {
                        [self addAttribute:(id)kCTForegroundColorAttributeName value:(id)color.CGColor range:range];
                    }
                }
                return;
            }
            
            if ([value isKindOfClass:NSShadow.class]) {
                NSShadow *shadow = (NSShadow *)value;
                UIColor *shadowColor = shadow.shadowColor;
                if ([shadowColor isKindOfClass:UIColor.class] &&
                    shadowColor.isTheme) {
                    shadow.shadowColor = [shadowColor refreshTheme];
                    [self addAttribute:key value:shadow range:range];
                }
                return;
            }
            
            if ([value isKindOfClass:NSTextAttachment.class]) {
                NSTextAttachment *attachment = (NSTextAttachment *)value;
                if (attachment.image.isTheme) {
                    attachment.image = [attachment.image refreshTheme];
                    [self addAttribute:key value:attachment range:range];
                }
                return;
            }
            
            if ([value isKindOfClass:UIFont.class]) {
                UIFont *font = (UIFont *)value;
                if (font.isTheme) {
                    font = [font refreshTheme];
                    [self addAttribute:key value:font range:range];
                }
                return;
            }
        }];
    }];
}

@end

@implementation NSMutableDictionary (YYUIThemeRefresh)

- (void)refreshTheme {
    if ([self isEmpty]) return;
    
    [self forinNSAttributedStringKey:^(NSString * _Nonnull key, id  _Nonnull obj) {
        id value = [self objectForKey:key];
        
        if (!value) return;
        
        if ([value isKindOfClass:UIColor.class]) {
            UIColor *color = (UIColor *)value;
            if (color.isTheme) {
                color = [color refreshTheme];
                [self setValue:color forKey:key];
            }
            return;
        }
        
        if ([value isKindOfClass:NSShadow.class]) {
            NSShadow *shadow = (NSShadow *)value;
            UIColor *shadowColor = shadow.shadowColor;
            if ([shadowColor isKindOfClass:UIColor.class] &&
                shadowColor.isTheme) {
                shadow.shadowColor = [shadowColor refreshTheme];
                [self setValue:shadow forKey:key];
            }
            return;
        }
        
        if ([value isKindOfClass:NSTextAttachment.class]) {
            NSTextAttachment *attachment = (NSTextAttachment *)value;
            if (attachment.image.isTheme) {
                attachment.image = [attachment.image refreshTheme];
                [self setValue:attachment forKey:key];
            }
            return;
        }
        
        if ([value isKindOfClass:UIFont.class]) {
            UIFont *font = (UIFont *)value;
            if (font.isTheme) {
                font = [font refreshTheme];
                [self setValue:font forKey:key];
            }
            return;
        }
    }];
}

@end

@implementation CALayer (YYUIThemeRefresh)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setBackgroundColor:)),
                                   class_getInstanceMethod(self, @selector(setBackgroundThemeColor:)));
    
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setBorderColor:)),
                                   class_getInstanceMethod(self, @selector(setBorderThemeColor:)));
    
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setShadowColor:)),
                                   class_getInstanceMethod(self, @selector(setShadowThemeColor:)));
    
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setContents:)),
                                   class_getInstanceMethod(self, @selector(setContentImage:)));
}

- (void)setBackgroundThemeColor:(id)backgroundThemeColor {
    if ([backgroundThemeColor isKindOfClass:UIColor.class]) {
        [self setBackgroundThemeColor:(id)[backgroundThemeColor CGColor]];
        if ([backgroundThemeColor isTheme]) {
            objc_setAssociatedObject(self, @selector(backgroundThemeColor), backgroundThemeColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    } else {
        [self setBackgroundThemeColor:backgroundThemeColor];
    }
}

- (UIColor *)backgroundThemeColor {
    return objc_getAssociatedObject(self, @selector(backgroundThemeColor));
}

- (void)setBorderThemeColor:(id)borderThemeColor {
    if ([borderThemeColor isKindOfClass:UIColor.class]) {
        [self setBorderThemeColor:(id)[borderThemeColor CGColor]];
        if ([borderThemeColor isTheme]) {
            objc_setAssociatedObject(self, @selector(borderThemeColor), borderThemeColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    } else {
        [self setBorderThemeColor:borderThemeColor];
    }
}

- (UIColor *)borderThemeColor {
    return objc_getAssociatedObject(self, @selector(borderThemeColor));
}

- (void)setShadowThemeColor:(UIColor *)shadowThemeColor {
    if ([shadowThemeColor isKindOfClass:UIColor.class]) {
        [self setShadowThemeColor:(id)[shadowThemeColor CGColor]];
        if ([shadowThemeColor isTheme]) {
            objc_setAssociatedObject(self, @selector(shadowThemeColor), shadowThemeColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    } else {
        [self setShadowThemeColor:shadowThemeColor];
    }
}

- (UIColor *)shadowThemeColor {
    return objc_getAssociatedObject(self, @selector(shadowThemeColor));
}

- (void)setContentImage:(id)contentImage {
    if ([contentImage isKindOfClass:UIImage.class]) {
        UIImage *image = (UIImage *)contentImage;
        [self setContentImage:(id)image.CGImage];
        if ([image isTheme]) {
            objc_setAssociatedObject(self, @selector(contentImage), contentImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    } else {
        [self setContentImage:contentImage];
    }
}

- (UIImage *)contentImage {
    return objc_getAssociatedObject(self, @selector(contentImage));
}

#pragma mark - Refresh

- (void)refreshTheme {
    for (CALayer *layer in self.sublayers) {
        [layer refreshSingleLayer];
    }
}

- (void)refreshSingleLayer {

    // 刷新通用属性
    UIColor *backgroundColor = self.backgroundThemeColor;
    if (backgroundColor.isTheme) {
        self.backgroundColor = (__bridge CGColorRef)[backgroundColor refreshTheme];
    }
    
    UIColor *borderColor = self.borderThemeColor;
    if (borderColor.isTheme) {
        self.borderColor = (__bridge CGColorRef)[borderColor refreshTheme];
    }
    
    UIColor *shadowColor = self.shadowThemeColor;
    if (shadowColor.isTheme) {
        self.shadowColor = (__bridge CGColorRef)[shadowColor refreshTheme];
    }
    
    UIImage *image = self.contentImage;
    if (image.isTheme) {
        self.contents = [image refreshTheme];
    }
    
    if ([self isKindOfClass:CATextLayer.class]) {
        CATextLayer *theme_textLayer = (CATextLayer *)self;
        
        UIColor *foregroundColor = theme_textLayer.foregroundThemeColor;
        if (foregroundColor.isTheme) {
            theme_textLayer.foregroundColor = (__bridge CGColorRef)[foregroundColor refreshTheme];
        }
        
        if ([theme_textLayer.string isKindOfClass:NSAttributedString.class]) {
            NSMutableAttributedString *theme_attr = [theme_textLayer.string mutableCopy];
            [theme_attr refreshTheme];
            theme_textLayer.string = theme_attr;
        }
        
        return;
    }
    
    if ([self isKindOfClass:CAShapeLayer.class]) {
        CAShapeLayer *theme_shapeLayer = (CAShapeLayer *)self;
        
        UIColor *fillColor = theme_shapeLayer.fillThemeColor;
        if (fillColor.isTheme) {
            theme_shapeLayer.fillColor = (__bridge CGColorRef)[fillColor refreshTheme];
        }
        
        UIColor *strokeColor = theme_shapeLayer.strokeThemeColor;
        if (strokeColor.isTheme) {
            theme_shapeLayer.strokeColor = (__bridge CGColorRef)[strokeColor refreshTheme];
        }
        return;
    }

}

@end

@implementation CATextLayer (YYUIThemeRefresh)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setForegroundColor:)),
                                   class_getInstanceMethod(self, @selector(setForegroundThemeColor:)));
}

- (void)setForegroundThemeColor:(id)foregroundThemeColor {
    if ([foregroundThemeColor isKindOfClass:UIColor.class]) {
        [self setForegroundThemeColor:(id)[foregroundThemeColor CGColor]];
        if ([foregroundThemeColor isTheme]) {
            objc_setAssociatedObject(self, @selector(foregroundThemeColor), foregroundThemeColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    } else {
        [self setForegroundThemeColor:foregroundThemeColor];
    }
}

- (UIColor *)foregroundThemeColor {
    return objc_getAssociatedObject(self, @selector(foregroundThemeColor));
}

@end

@implementation CAShapeLayer (YYUIThemeRefresh)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setFillColor:)),
                                   class_getInstanceMethod(self, @selector(setFillThemeColor:)));
    
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setStrokeColor:)),
                                   class_getInstanceMethod(self, @selector(setStrokeThemeColor:)));
}

- (void)setFillThemeColor:(id)fillThemeColor {
    if ([fillThemeColor isKindOfClass:UIColor.class]) {
        [self setFillThemeColor:(id)[fillThemeColor CGColor]];
        if ([fillThemeColor isTheme]) {
            objc_setAssociatedObject(self, @selector(fillThemeColor), fillThemeColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    } else {
        [self setFillThemeColor:fillThemeColor];
    }
}

- (UIColor *)fillThemeColor {
    return objc_getAssociatedObject(self, @selector(fillThemeColor));
}

- (void)setStrokeThemeColor:(id)strokeThemeColor {
    if ([strokeThemeColor isKindOfClass:UIColor.class]) {
        [self setStrokeThemeColor:(id)[strokeThemeColor CGColor]];
        if ([strokeThemeColor isTheme]) {
            objc_setAssociatedObject(self, @selector(strokeThemeColor), strokeThemeColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    } else {
        [self setStrokeThemeColor:strokeThemeColor];
    }
}

- (UIColor *)strokeThemeColor {
    return objc_getAssociatedObject(self, @selector(strokeThemeColor));
}

@end

@implementation CAGradientLayer (YYUIThemeRefresh)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setColors:)),
                                   class_getInstanceMethod(self, @selector(setThemeColors:)));
}

- (void)setThemeColors:(NSArray *)themeColors {
    NSMutableArray *theme_arr = [NSMutableArray array];
    BOOL isThemeColor = NO;
    for (UIColor *color in themeColors) {
        if ([color isKindOfClass:UIColor.class]) {
            [theme_arr addObject:(id)color.CGColor];
            if (color.isTheme) isThemeColor = YES;
        } else {
            [theme_arr addObject:color];
        }
    }
    
    if (isThemeColor == YES) {
        objc_setAssociatedObject(self, @selector(themeColors), themeColors, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    [self setThemeColors:theme_arr];
}

- (NSArray *)themeColors {
    return objc_getAssociatedObject(self, @selector(themeColors));
}


@end



@implementation UIView (YYUIThemeRefresh)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(didMoveToSuperview)),
                                   class_getInstanceMethod(self, @selector(theme_didMoveToSuperview)));
    
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setBackgroundColor:)),
                                   class_getInstanceMethod(self, @selector(setTheme_backgroundColor:)));
    
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(backgroundColor)),
                                   class_getInstanceMethod(self, @selector(theme_backgroundColor)));
}

- (void)theme_didMoveToSuperview {
    [self theme_didMoveToSuperview];
    // 缓存实例对象
    [YYUIThemeManager addTrackedWithObject:self];
}

- (void)setTheme_backgroundColor:(UIColor *)theme_backgroundColor {
    objc_setAssociatedObject(self, @selector(theme_backgroundColor), theme_backgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setTheme_backgroundColor:theme_backgroundColor];
}

- (UIColor *)theme_backgroundColor {
    return objc_getAssociatedObject(self, @selector(theme_backgroundColor));
}

#pragma mark - refresh

- (void)refreshTheme {
    
    [self.layer refreshTheme];
    
    if (self.backgroundColor.isTheme) {
        self.backgroundColor = [self.backgroundColor refreshTheme];
    }
    
    if (self.tintColor.isTheme) {
        self.tintColor = [self.tintColor refreshTheme];
    }
    
    if ([self isKindOfClass:UILabel.class]) {
        [self refreshUILabel];
    }
    
    if ([self isKindOfClass:YYLabel.class]) {
        [self refreshYYLabel];
    }
    
    if ([self isKindOfClass:UIButton.class]) {
        [self refreshUIButton];
    }
    
    if ([self isKindOfClass:UIImageView.class]) {
        [self refreshUIImageView];
    }
    
    if ([self isKindOfClass:UITextField.class]) {
        [self refreshUITextField];
    }
    
    if ([self isKindOfClass:UITextView.class]) {
        [self refreshUITextView];
    }
    
    if ([self isKindOfClass:YYTextView.class]) {
        [self refreshYYTextView];
    }
    
    if ([self isKindOfClass:UITableView.class]) {
        [self refreshUITableView];
    }
    
    if ([self isKindOfClass:UIActivityIndicatorView.class]) {
        [self refreshUIActivityIndicatorView];
    }
    
    if ([self isKindOfClass:UIProgressView.class]) {
        [self refreshUIProgressView];
    }
    
    if ([self isKindOfClass:UIPageControl.class]) {
        [self refreshUIPageControl];
    }
    
    if ([self isKindOfClass:UISwitch.class]) {
        [self refreshUISwitch];
    }
    
    if ([self isKindOfClass:UISlider.class]) {
        [self refreshUISlider];
    }
    
    if ([self isKindOfClass:UIStepper.class]) {
        [self refreshUIStepper];
    }
    
    if ([self isKindOfClass:UIRefreshControl.class]) {
        [self refreshUIRefreshControl];
    }
    
    if ([self isKindOfClass:UISegmentedControl.class]) {
        [self refreshUISegmentedControl];
    }
    
    if ([self isKindOfClass:UINavigationBar.class]) {
        [self refreshUINavigationBar];
    }
    
    if ([self isKindOfClass:UIToolbar.class]) {
        [self refreshUIToolBar];
    }
    
    if ([self isKindOfClass:UITabBar.class]) {
        [self refreshUITabBar];
    }
    
    if ([self isKindOfClass:UISearchBar.class]) {
        [self refreshUISearchBar];
    }
}

- (void)refreshUILabel {
    UILabel *label = (UILabel *)self;
    
    if (label.highlightedTextColor.isTheme) {
        label.highlightedTextColor = [label.highlightedTextColor refreshTheme];
    }
    
    if (label.font.isTheme) {
        label.font = [label.font refreshTheme];
    }
    
    NSMutableAttributedString *attr = [label.attributedText mutableCopy];
    [attr refreshTheme];
    label.attributedText = attr;
}

- (void)refreshYYLabel {
    YYLabel *label = (YYLabel *)self;
    
    if (label.shadowColor.isTheme) {
        label.shadowColor = [label.shadowColor refreshTheme];
    }
    
    if (label.textColor.isTheme) {
        label.textColor = [label.textColor refreshTheme];
    }
    
    if (label.font.isTheme) {
        label.font = [label.font refreshTheme];
    }
    
    NSMutableAttributedString *attr = [label.attributedText mutableCopy];
    [attr refreshTheme];
    label.attributedText = attr;
}

- (void)refreshUIButton {
    UIButton *button = (UIButton *)self;
    
    // 刷新font
    if (button.titleLabel.font.isTheme) {
        button.titleLabel.font = [button.titleLabel.font refreshTheme];
    }
    
    [button forinUIControlState:^(UIControlState state, UIButton * _Nonnull obj) {
        // 刷新titleColor
        UIColor *titleColor = [obj titleColorForState:state];
        if (titleColor.isTheme) {
            [obj setTitleColor:[titleColor refreshTheme] forState:state];
        }

        // 刷新shadowColor
        UIColor *shadowColor = [obj titleShadowColorForState:state];
        if (shadowColor.isTheme) {
            [obj setTitleShadowColor:[shadowColor refreshTheme] forState:state];
        }

        // 刷新image
        UIImage *image = [obj imageForState:state];
        if (image.isTheme) {
            [obj setImage:[image refreshTheme] forState:state];
        }

        // 刷新backgroundImage
        UIImage *backgroundImage = [obj backgroundImageForState:state];
        if (backgroundImage.isTheme) {
            [obj setBackgroundImage:[backgroundImage refreshTheme] forState:state];
        }
        
        // 刷新富文本
        NSAttributedString *attr = [obj attributedTitleForState:state];
        NSMutableAttributedString *mutable_attr = [[NSMutableAttributedString alloc] initWithAttributedString:attr];
        [mutable_attr refreshTheme];
        [obj setAttributedTitle:mutable_attr forState:state];
    }];
}

- (void)refreshUIImageView {
    UIImageView *imageView = (UIImageView *)self;
    
    if (imageView.image.isTheme) {
        imageView.image = [imageView.image refreshTheme];
    }
        
    if (imageView.highlightedImage.isTheme) {
        imageView.highlightedImage = [imageView.highlightedImage refreshTheme];
    }
}

- (void)refreshUITextField {
    UITextField *textField = (UITextField *)self;
    
    NSMutableAttributedString *attr = [textField.attributedText mutableCopy];
    [attr refreshTheme];
    textField.attributedText = attr;
    
    NSMutableAttributedString *placeAttr = [textField.attributedPlaceholder mutableCopy];
    [placeAttr refreshTheme];
    textField.attributedPlaceholder = placeAttr;
    
    NSMutableDictionary *typingDict = [textField.typingAttributes mutableCopy];
    [typingDict refreshTheme];
    textField.typingAttributes = typingDict;
    
    if (textField.background.isTheme) {
        textField.background = [textField.background refreshTheme];
    }
    
    if (textField.disabledBackground.isTheme) {
        textField.disabledBackground = [textField.disabledBackground refreshTheme];
    }
    
    if (textField.inputView) {
        [textField.inputView refreshTheme];
    }
    
    if (textField.inputAccessoryView) {
        [textField.inputAccessoryView refreshTheme];
    }
    
    if (textField.textColor.isTheme) {
        textField.textColor = [textField.textColor refreshTheme];
    }
    
    if (textField.font.isTheme) {
        textField.font = [textField.font refreshTheme];
    }
}

- (void)refreshUITextView {
    UITextView *textView = (UITextView *)self;
    
    NSMutableAttributedString *attr = [textView.attributedText mutableCopy];
    [attr refreshTheme];
    textView.attributedText = attr;
    
    NSMutableDictionary *typingDict = [textView.typingAttributes mutableCopy];
    [typingDict refreshTheme];
    textView.typingAttributes = typingDict;
    
    NSMutableDictionary *linkDict = [textView.linkTextAttributes mutableCopy];
    [linkDict refreshTheme];
    textView.linkTextAttributes = linkDict;
    
    if (textView.inputView) {
        [textView.inputView refreshTheme];
    }
    
    if (textView.inputAccessoryView) {
        [textView.inputAccessoryView refreshTheme];
    }
    
    if (textView.font.isTheme) {
        textView.font = [textView.font refreshTheme];
    }
}

- (void)refreshYYTextView {
    YYTextView *textView = (YYTextView *)self;
    
    if (textView.inputView) {
        [textView.inputView refreshTheme];
    }
    
    if (textView.inputAccessoryView) {
        [textView.inputAccessoryView refreshTheme];
    }
    
    NSMutableAttributedString *attr = [textView.attributedText mutableCopy];
    [attr refreshTheme];
    textView.attributedText = attr;
    
    NSMutableDictionary *typingDict = [textView.typingAttributes mutableCopy];
    [typingDict refreshTheme];
    textView.typingAttributes = typingDict;
    
    NSMutableDictionary *linkDict = [textView.linkTextAttributes mutableCopy];
    [linkDict refreshTheme];
    textView.linkTextAttributes = linkDict;
    
    NSMutableDictionary *highlightDict = [textView.highlightTextAttributes mutableCopy];
    [highlightDict refreshTheme];
    textView.highlightTextAttributes = highlightDict;
    
    NSMutableAttributedString *placeholderDict = [textView.placeholderAttributedText mutableCopy];
    [placeholderDict refreshTheme];
    textView.placeholderAttributedText = placeholderDict;
}

- (void)refreshUITableView {
    UITableView *tableView = (UITableView *)self;
    
    if (tableView.sectionIndexColor.isTheme) {
        tableView.sectionIndexColor = [tableView.sectionIndexColor refreshTheme];
    }
    
    if (tableView.sectionIndexBackgroundColor.isTheme) {
        tableView.sectionIndexBackgroundColor = [tableView.sectionIndexBackgroundColor refreshTheme];
    }
    
    if (tableView.sectionIndexTrackingBackgroundColor.isTheme) {
        tableView.sectionIndexTrackingBackgroundColor = [tableView.sectionIndexTrackingBackgroundColor refreshTheme];
    }
}

- (void)refreshUIActivityIndicatorView {
    UIActivityIndicatorView *view = (UIActivityIndicatorView *)self;
    
    if (view.color.isTheme) {
        view.color = [view.color refreshTheme];
    }
}

- (void)refreshUIProgressView {
    UIProgressView *progressView = (UIProgressView *)self;
    
    if (progressView.progressTintColor.isTheme) {
        progressView.progressTintColor = [progressView.progressTintColor refreshTheme];
    }
    
    if (progressView.trackTintColor.isTheme) {
        progressView.trackTintColor = [progressView.trackTintColor refreshTheme];
    }
    
    if (progressView.progressImage.isTheme) {
        progressView.progressImage = [progressView.progressImage refreshTheme];
    }
    
    if (progressView.trackImage.isTheme) {
        progressView.trackImage = [progressView.trackImage refreshTheme];
    }
}

- (void)refreshUIPageControl {
    UIPageControl *pageControl = (UIPageControl *)self;
    
    if (pageControl.pageIndicatorTintColor.isTheme) {
        pageControl.pageIndicatorTintColor = [pageControl.pageIndicatorTintColor refreshTheme];
    }
    
    if (pageControl.currentPageIndicatorTintColor.isTheme) {
        pageControl.currentPageIndicatorTintColor = [pageControl.currentPageIndicatorTintColor refreshTheme];
    }
    
    if (@available(iOS 14.0, *)) {
        if (pageControl.preferredIndicatorImage.isTheme) {
            pageControl.preferredIndicatorImage = [pageControl.preferredIndicatorImage refreshTheme];
        }
        for (NSInteger i = 0; i < pageControl.numberOfPages; i++) {
            UIImage *image = [pageControl indicatorImageForPage:i];
            if (image.isTheme) {
                image = [image refreshTheme];
                [pageControl setIndicatorImage:image forPage:i];
            }
        }
    }
}

- (void)refreshUISwitch {
    UISwitch *theme_switch = (UISwitch *)self;
    
    if (theme_switch.onTintColor.isTheme) {
        theme_switch.onTintColor = [theme_switch.onTintColor refreshTheme];
    }
    
    if (theme_switch.thumbTintColor.isTheme) {
        theme_switch.thumbTintColor = [theme_switch.thumbTintColor refreshTheme];
    }
    
    if (theme_switch.onImage.isTheme) {
        theme_switch.onImage = [theme_switch.onImage refreshTheme];
    }
    
    if (theme_switch.offImage.isTheme) {
        theme_switch.offImage = [theme_switch.offImage refreshTheme];
    }
}

- (void)refreshUISlider {
    UISlider *slider = (UISlider *)self;
    
    if (slider.minimumValueImage.isTheme) {
        slider.minimumValueImage = [slider.minimumValueImage refreshTheme];
    }
    
    if (slider.maximumValueImage.isTheme) {
        slider.maximumValueImage = [slider.maximumValueImage refreshTheme];
    }
    
    if (slider.minimumTrackTintColor.isTheme) {
        slider.minimumTrackTintColor = [slider.minimumTrackTintColor refreshTheme];
    }
    
    if (slider.maximumTrackTintColor.isTheme) {
        slider.maximumTrackTintColor = [slider.maximumTrackTintColor refreshTheme];
    }
    
    if (slider.thumbTintColor.isTheme) {
        slider.thumbTintColor = [slider.thumbTintColor refreshTheme];
    }
    
    [slider forinUIControlState:^(UIControlState state, UISlider * _Nonnull obj) {
        UIImage *thumbImage = [obj thumbImageForState:state];
        if (thumbImage.isTheme) {
            [obj setThumbImage:[thumbImage refreshTheme] forState:state];
        }
        
        UIImage *minimumImage = [obj minimumTrackImageForState:state];
        if (minimumImage.isTheme) {
            [obj setMinimumTrackImage:[minimumImage refreshTheme]  forState:state];
        }
        
        UIImage *maximumImage = [obj maximumTrackImageForState:state];
        if (maximumImage.isTheme) {
            [obj setMaximumTrackImage:[maximumImage refreshTheme] forState:state];
        }
    }];
}

- (void)refreshUIStepper {
    UIStepper *stepper = (UIStepper *)self;
    
    [stepper forinUIControlState:^(UIControlState state, UIStepper * _Nonnull obj) {
        UIImage *backgroundImage = [obj backgroundImageForState:state];
        if (backgroundImage.isTheme) {
            [obj setBackgroundImage:[backgroundImage refreshTheme] forState:state];
        }
        
        UIImage *incrementImage = [obj incrementImageForState:state];
        if (incrementImage.isTheme) {
            [obj setIncrementImage:[incrementImage refreshTheme] forState:state];
        }
        
        UIImage *decrementImage = [obj decrementImageForState:state];
        if (decrementImage.isTheme) {
            [obj setDecrementImage:[decrementImage refreshTheme] forState:state];
        }
        
        [obj forinUIControlState:^(UIControlState state1, UIStepper * _Nonnull obj1) {
            UIImage *dividerImage = [obj1 dividerImageForLeftSegmentState:state rightSegmentState:state1];
            if (dividerImage.isTheme) {
                [obj1 setDividerImage:[dividerImage refreshTheme] forLeftSegmentState:state rightSegmentState:state1];
            }
        }];
    }];
}

- (void)refreshUIRefreshControl {
    UIRefreshControl *refreshControl = (UIRefreshControl *)self;
    
    NSMutableAttributedString *mutable_attr = [[NSMutableAttributedString alloc] initWithAttributedString:refreshControl.attributedTitle];
    [mutable_attr refreshTheme];
    refreshControl.attributedTitle = mutable_attr;
}

- (void)refreshUISegmentedControl {
    UISegmentedControl *segmented = (UISegmentedControl *)self;
    
    if (@available(iOS 13.0, *)) {
        if (segmented.selectedSegmentTintColor.isTheme) {
            segmented.selectedSegmentTintColor = [segmented.selectedSegmentTintColor refreshTheme];
        }
    }
    
    for (NSInteger i = 0; i < segmented.numberOfSegments; i++) {
        UIImage *image = [segmented imageForSegmentAtIndex:i];
        if (image.isTheme) {
            [segmented setImage:[image refreshTheme] forSegmentAtIndex:i];
        }
    }
    
    [segmented forinUIControlState:^(UIControlState state, UISegmentedControl * _Nonnull obj) {
        NSMutableDictionary<NSAttributedStringKey, id> *dict = [[obj titleTextAttributesForState:state] mutableCopy];
        [dict refreshTheme];
        [obj setTitleTextAttributes:dict forState:state];
                
        [obj forinUIBarMetrics:^(UIBarMetrics metrics, UISegmentedControl * _Nonnull obj1) {
            UIImage *backgroundImage = [obj1 backgroundImageForState:state barMetrics:metrics];
            if (backgroundImage.isTheme) {
                [obj1 setBackgroundImage:[backgroundImage refreshTheme] forState:state barMetrics:metrics];
            }
            
            [obj1 forinUIControlState:^(UIControlState state1, UISegmentedControl * _Nonnull obj2) {
                UIImage *dividerImage = [obj2 dividerImageForLeftSegmentState:state rightSegmentState:state1 barMetrics:metrics];
                if (dividerImage.isTheme) {
                    [obj2 setDividerImage:[dividerImage refreshTheme] forLeftSegmentState:state rightSegmentState:state1 barMetrics:metrics];
                }
            }];
        }];
    }];
}

- (void)refreshUINavigationBar {
    UINavigationBar *navigationBar = (UINavigationBar *)self;
    
    UIColor *barTintColor = navigationBar.barTintColor;
    if (barTintColor.isTheme) {
        navigationBar.barTintColor = [barTintColor refreshTheme];
    }
    
    UIImage *shadowImage = navigationBar.shadowImage;
    if (shadowImage.isTheme) {
        navigationBar.shadowImage = [shadowImage refreshTheme];
    }
    
    UIImage *backIndicatorImage = navigationBar.backIndicatorImage;
    if (backIndicatorImage.isTheme) {
        navigationBar.backIndicatorImage = [backIndicatorImage refreshTheme];
    }
    
    UIImage *backIndicatorTransitionMaskImage = navigationBar.backIndicatorTransitionMaskImage;
    if (backIndicatorTransitionMaskImage.isTheme) {
        navigationBar.backIndicatorTransitionMaskImage = [backIndicatorTransitionMaskImage refreshTheme];
    }
    
    NSMutableDictionary *titleTextAttributes = [navigationBar.titleTextAttributes mutableCopy];
    [titleTextAttributes refreshTheme];
    navigationBar.titleTextAttributes = titleTextAttributes;
    
    if (@available(iOS 11.0, *)) {
        NSMutableDictionary *largeTitleTextAttributes = [navigationBar.largeTitleTextAttributes mutableCopy];
        [largeTitleTextAttributes refreshTheme];
        navigationBar.largeTitleTextAttributes = largeTitleTextAttributes;
    }
    
    [navigationBar forinUIBarPosition:^(UIBarPosition position, UINavigationBar * _Nonnull obj) {
        [obj forinUIBarMetrics:^(UIBarMetrics metrics, UINavigationBar * _Nonnull obj1) {
            UIImage *image = [navigationBar backgroundImageForBarPosition:position barMetrics:metrics];
            if (image.isTheme) {
                [obj1 setBackgroundImage:[image refreshTheme] forBarPosition:position barMetrics:metrics];
            }
        }];
    }];
    
    for (UINavigationItem *item in navigationBar.items) {
        [self refreshUINavigationItem:item];
    }
}

- (void)refreshUINavigationItem:(UINavigationItem *)item {
    [item.titleView refreshTheme];
    
    for (UIBarButtonItem *buttonItem in item.leftBarButtonItems) {
        [self refreshUIBarButtonItem:buttonItem];
    }
    
    for (UIBarButtonItem *buttonItem in item.rightBarButtonItems) {
        [self refreshUIBarButtonItem:buttonItem];
    }
    
    if (@available(iOS 11.0, *)) {
        UISearchController *searchController = item.searchController;
        if (searchController.searchBar) {
            [searchController.searchBar refreshTheme];
        }
    }
}

- (void)refreshUIToolBar {
    UIToolbar *toolBar = (UIToolbar *)self;
    
    UIColor *barTintColor = toolBar.barTintColor;
    if (barTintColor.isTheme) {
        toolBar.barTintColor = [barTintColor refreshTheme];
    }
    
    [toolBar forinUIBarPosition:^(UIBarPosition position, UIToolbar * _Nonnull obj) {
        UIImage *shadowImage = [obj shadowImageForToolbarPosition:position];
        if (shadowImage.isTheme) {
            [obj setShadowImage:[shadowImage refreshTheme] forToolbarPosition:position];
        }
        
        [obj forinUIBarMetrics:^(UIBarMetrics metrics, UIToolbar * _Nonnull obj1) {
            UIImage *backgroundImage = [obj1 backgroundImageForToolbarPosition:position barMetrics:metrics];
            if (backgroundImage.isTheme) {
                [obj1 setBackgroundImage:[backgroundImage refreshTheme] forToolbarPosition:position barMetrics:metrics];
            }
        }];
    }];
    
    for (UIBarButtonItem *item in toolBar.items) {
        [self refreshUIBarButtonItem:item];
    }
}


- (void)refreshUITabBar {
    UITabBar *tabBar = (UITabBar *)self;
    
    UIColor *barTintColor = tabBar.barTintColor;
    if (barTintColor.isTheme) {
        tabBar.barTintColor = [barTintColor refreshTheme];
    }
    
    if (@available(iOS 10.0, *)) {
        UIColor *unselectedItemTintColor = tabBar.unselectedItemTintColor;
        if (unselectedItemTintColor.isTheme) {
            tabBar.unselectedItemTintColor = [unselectedItemTintColor refreshTheme];
        }
    }
    
    UIImage *backgroundImage = tabBar.backgroundImage;
    if (backgroundImage.isTheme) {
        tabBar.backgroundImage = [backgroundImage refreshTheme];
    }
    
    UIImage *selectionIndicatorImage = tabBar.selectionIndicatorImage;
    if (selectionIndicatorImage.isTheme) {
        tabBar.selectionIndicatorImage = [selectionIndicatorImage refreshTheme];
    }
    
    UIImage *shadowImage = tabBar.shadowImage;
    if (shadowImage.isTheme) {
        tabBar.shadowImage = [shadowImage refreshTheme];
    }
    
    for (UITabBarItem *item in tabBar.items) {
        [self refreshUITabBarItem:item];
    }
}

- (void)refreshUITabBarItem:(UITabBarItem *)item {
    if (@available(iOS 10.0, *)) {
        UIColor *badgeColor = item.badgeColor;
        if (badgeColor.isTheme) {
            item.badgeColor = [badgeColor refreshTheme];
        }
    }
    
    UIImage *selectedImage = item.selectedImage;
    if (selectedImage.isTheme) {
        item.selectedImage = [selectedImage refreshTheme];
    }
    
    [item forinUIControlState:^(UIControlState state, UITabBarItem * _Nonnull obj) {
        if (@available(iOS 10.0, *)) {
            NSMutableDictionary<NSAttributedStringKey, id> *theme_dict = [[obj badgeTextAttributesForState:state] mutableCopy];
            [theme_dict refreshTheme];
            [obj setBadgeTextAttributes:theme_dict forState:state];
        }
    }];
    
    [self refreshUIBarItem:item];
}

- (void)refreshUIBarButtonItem:(UIBarButtonItem *)item {
    [item.customView refreshTheme];
    
    UIColor *tintColor = item.tintColor;
    if (tintColor.isTheme) {
        item.tintColor = [tintColor refreshTheme];
    }
    
    [item forinUIControlState:^(UIControlState state, UIBarButtonItem * _Nonnull obj) {
        state = state == 4 ? UIControlStateHighlighted : state;
        [obj forinUIBarMetrics:^(UIBarMetrics metrics, UIBarButtonItem * _Nonnull obj1) {
            UIImage *theme_backButtonBackgroundImage = [obj1 backButtonBackgroundImageForState:state barMetrics:metrics];
            if (theme_backButtonBackgroundImage.isTheme) {
                [obj1 setBackButtonBackgroundImage:[theme_backButtonBackgroundImage refreshTheme] forState:state barMetrics:metrics];
            }

            [obj1 forinUIBarButtonItemStyle:^(UIBarButtonItemStyle style, UIBarButtonItem * _Nonnull obj2) {
                UIImage *theme_backgroundImage = [obj2 backgroundImageForState:state style:style barMetrics:metrics];
                if (theme_backgroundImage.isTheme) {
                    [obj2 setBackgroundImage:[theme_backgroundImage refreshTheme] forState:state style:style barMetrics:metrics];
                }
            }];
        }];
    }];
    
    [self refreshUIBarItem:item];
}

- (void)refreshUIBarItem:(UIBarItem *)item {
    UIImage *theme_image = item.image;
    if (theme_image.isTheme) {
        item.image = [theme_image refreshTheme];
    }
    
    if (@available(iOS 11.0, *)) {
        UIImage *theme_largeContentSizeImage = item.largeContentSizeImage;
        if (theme_largeContentSizeImage.isTheme) {
            item.largeContentSizeImage = [theme_largeContentSizeImage refreshTheme];
        }
    }
    
    [item forinUIControlState:^(UIControlState state, UIBarButtonItem * _Nonnull obj) {
        state = state == 4 ? UIControlStateHighlighted : state;
        NSMutableDictionary<NSAttributedStringKey, id> *theme_attributes = [[obj titleTextAttributesForState:state] mutableCopy];
        [theme_attributes refreshTheme];
        [obj setTitleTextAttributes:theme_attributes forState:state];
    }];
}


- (void)refreshUISearchBar {
    UISearchBar *searchBar = (UISearchBar *)self;

    UIView *inputAccessoryView = searchBar.inputAccessoryView;
    [inputAccessoryView refreshTheme];

    UIColor *barTintColor = searchBar.barTintColor;
    if (barTintColor.isTheme) {
        searchBar.barTintColor = [barTintColor refreshTheme];
    }

    UIImage *scopeBarBackgroundImage = searchBar.scopeBarBackgroundImage;
    if (scopeBarBackgroundImage.isTheme) {
        searchBar.scopeBarBackgroundImage = [scopeBarBackgroundImage refreshTheme];
    }

    [searchBar forinUIBarPosition:^(UIBarPosition position, UISearchBar * _Nonnull obj) {
        [obj forinUIBarMetrics:^(UIBarMetrics metrics, UISearchBar * _Nonnull obj1) {
            UIImage *image = [obj1 backgroundImageForBarPosition:position barMetrics:metrics];
            if (image.isTheme) {
                [obj1 setBackgroundImage:[image refreshTheme] forBarPosition:position barMetrics:metrics];
            }
        }];
    }];

    [searchBar forinUIControlState:^(UIControlState state, UISearchBar * _Nonnull obj) {
        UIImage *searchFieldBackgroundImage = [obj searchFieldBackgroundImageForState:state];
        if (searchFieldBackgroundImage.isTheme) {
            [obj setSearchFieldBackgroundImage:[searchFieldBackgroundImage refreshTheme] forState:state];
        }

        UIImage *scopeBarButtonBackgroundImage = [obj scopeBarButtonBackgroundImageForState:state];
        if (scopeBarButtonBackgroundImage.isTheme) {
            [obj setScopeBarButtonBackgroundImage:[scopeBarButtonBackgroundImage refreshTheme] forState:state];
        }

        NSMutableDictionary<NSAttributedStringKey, id> *attributes = [[obj scopeBarButtonTitleTextAttributesForState:state] mutableCopy];
        [attributes refreshTheme];
        [obj setScopeBarButtonTitleTextAttributes:attributes forState:state];

        [obj forinUISearchBarIcon:^(UISearchBarIcon icon, UISearchBar * _Nonnull obj1) {
            UIImage *image = [obj1 imageForSearchBarIcon:icon state:state];
            if (image.isTheme) {
                [obj1 setImage:[image refreshTheme] forSearchBarIcon:icon state:state];
            }
        }];

        [obj forinUIControlState:^(UIControlState state1, UISearchBar * _Nonnull obj1) {
            UIImage *image = [obj1 scopeBarButtonDividerImageForLeftSegmentState:state rightSegmentState:state1];
            if (image.isTheme) {
                [obj1 setScopeBarButtonDividerImage:[image refreshTheme] forLeftSegmentState:state rightSegmentState:state1];
            }
        }];
    }];
}
@end
