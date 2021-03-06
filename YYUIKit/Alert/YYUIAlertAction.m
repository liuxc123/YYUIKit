//
//  YYUIAlertAction.m
//  YYUIKit
//
//  Created by liuxc on 2021/12/9.
//

#import "YYUIAlertAction.h"
#import "YYUIKitMacro.h"

@interface YYUIAlertAction ()

@end

@implementation YYUIAlertAction

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(YYUIAlertActionStyle)style handler:(void (^ __nullable)(YYUIAlertAction *action))handler {
    YYUIAlertAction *action = [[YYUIAlertAction alloc] init];
    action.title = title;
    action.style = style;
    action.handler = handler;
    return action;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dismissOnTouch = YES;
        _numberOfLines = 1;
        _textAlignment = NSTextAlignmentCenter;
        _adjustsFontSizeToFitWidth = NO;
        _lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return self;
}

@end

@implementation YYUIAlertActionButton

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    self.action = self.action;
}

+ (YYUIAlertActionButton *)button{
    
    return [YYUIAlertActionButton buttonWithType:UIButtonTypeCustom];;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topSeparatorView];
        [self addSubview:self.bottomSeparatorView];
    }
    return self;
}

- (void)setAction:(YYUIAlertAction *)action {
    _action = action;
    
    self.clipsToBounds = YES;
    
    if (action.title) [self setTitle:action.title forState:UIControlStateNormal];
    
    if (action.highlight) [self setTitle:action.highlight forState:UIControlStateHighlighted];
    
    if (action.attributedTitle) [self setAttributedTitle:action.attributedTitle forState:UIControlStateNormal];
    
    if (action.attributedHighlight) [self setAttributedTitle:action.attributedHighlight forState:UIControlStateHighlighted];
    
    [self.titleLabel setNumberOfLines:action.numberOfLines];
    
    [self.titleLabel setTextAlignment:action.textAlignment];
    
    if (action.font) [self.titleLabel setFont:action.font];
    
    [self.titleLabel setAdjustsFontSizeToFitWidth:action.adjustsFontSizeToFitWidth];
    
    [self.titleLabel setLineBreakMode:action.lineBreakMode];
    
    if (action.titleColor) [self setTitleColor:action.titleColor forState:UIControlStateNormal];
    
    if (action.titleColorHighlighted) [self setTitleColor:action.titleColorHighlighted forState:UIControlStateHighlighted];
    
    if (action.titleColorDisabled) [self setTitleColor:action.titleColorDisabled forState:UIControlStateDisabled];
    
    if (action.backgroundColor) [self setBackgroundImage:[self getImageWithColor:action.backgroundColor] forState:UIControlStateNormal];
    
    if (action.backgroundColorHighlighted) [self setBackgroundImage:[self getImageWithColor:action.backgroundColorHighlighted] forState:UIControlStateHighlighted];
    
    if (action.backgroundColorDisabled) [self setBackgroundImage:[self getImageWithColor:action.backgroundColorDisabled] forState:UIControlStateDisabled];
    
    if (action.backgroundImage) [self setBackgroundImage:action.backgroundImage forState:UIControlStateNormal];
    
    if (action.backgroundImageHighlighted) [self setBackgroundImage:action.backgroundImageHighlighted forState:UIControlStateHighlighted];
    
    if (action.backgroundImageDisabled) [self setBackgroundImage:action.backgroundImageDisabled forState:UIControlStateDisabled];
        
    if (action.image) [self setImage:action.image forState:UIControlStateNormal];
    
    if (action.highlightImage) [self setImage:action.highlightImage forState:UIControlStateHighlighted];
            
    [self setImageEdgeInsets:action.imageEdgeInsets];
    
    [self setTitleEdgeInsets:action.titleEdgeInsets];
}

- (UIView *)topSeparatorView {
    if (!_topSeparatorView) {
        _topSeparatorView = [[UIView alloc] init];
        [_topSeparatorView setHidden:YES];
    }
    return _topSeparatorView;
}

- (UIView *)bottomSeparatorView {
    if (!_bottomSeparatorView) {
        _bottomSeparatorView = [[UIView alloc] init];
        [_bottomSeparatorView setHidden:YES];
    }
    return _bottomSeparatorView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.topSeparatorView.frame = CGRectMake(0, 0, self.width, CGFloatFromPixel(1.0));
    self.bottomSeparatorView.frame = CGRectMake(0, self.height - CGFloatFromPixel(1.0), self.width, CGFloatFromPixel(1.0));
}

- (UIImage *)getImageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
