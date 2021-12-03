//
//  YYUIAlertAction.m
//  YYUIKit
//
//  Created by liuxc on 2021/12/2.
//

#import "YYUIAlertAction.h"

@interface YYUIAlertAction ()

@property (assign, nonatomic) YYUIAlertActionStyle style;
@property (copy,   nonatomic, nullable) void (^handler)(YYUIAlertAction *action);

@property (readwrite) BOOL userTitleColor;
@property (readwrite) BOOL userTitleColorHighlighted;
@property (readwrite) BOOL userTitleColorDisabled;
@property (readwrite) BOOL userBackgroundColor;
@property (readwrite) BOOL userBackgroundColorHighlighted;
@property (readwrite) BOOL userBackgroundColorDisabled;
@property (readwrite) BOOL userIconImage;
@property (readwrite) BOOL userIconImageHighlighted;
@property (readwrite) BOOL userIconImageDisabled;
@property (readwrite) BOOL userTextAlignment;
@property (readwrite) BOOL userFont;
@property (readwrite) BOOL userNumberOfLines;
@property (readwrite) BOOL userLineBreakMode;
@property (readwrite) BOOL userMinimumScaleFactor;
@property (readwrite) BOOL userAdjustsFontSizeTofitWidth;
@property (readwrite) BOOL userIconPosition;
@property (readwrite) BOOL userEnabled;

@end

@implementation YYUIAlertAction

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(YYUIAlertActionStyle)style handler:(void (^)(YYUIAlertAction * action))handler {
    YYUIAlertAction *action = [[self alloc] init];
    action.title = title;
    action.style = style;
    action.handler = handler;
    action.dismissOnAction = YES;
    return action;
}

- (instancetype)copyWithZone:(nullable NSZone *)zone {
    YYUIAlertAction *action = [[[self class] allocWithZone:zone] init];
    
    action.title = self.title;
    action.titleColor = self.titleColor;
    action.titleColorHighlighted = self.titleColorHighlighted;
    action.titleColorDisabled = self.titleColorDisabled;
    
    action.backgroundColor = self.backgroundColor;
    action.backgroundColorHighlighted = self.backgroundColorHighlighted;
    action.backgroundColorDisabled = self.backgroundColorDisabled;
    
    action.iconImage = self.iconImage;
    action.iconImageHighlighted = self.iconImageHighlighted;
    action.iconImageDisabled = self.iconImageDisabled;
    
    action.textAlignment = self.textAlignment;
    action.font = self.font;
    action.numberOfLines = self.numberOfLines;
    action.lineBreakMode = self.lineBreakMode;
    action.minimumScaleFactor = self.minimumScaleFactor;
    action.adjustsFontSizeToFitWidth = self.adjustsFontSizeToFitWidth;
    action.iconPosition = self.iconPosition;

    action.enabled = self.enabled;
    action.dismissOnAction = self.dismissOnAction;
    action.style = self.style;
    action.handler = self.handler;
    return action;
}

#pragma mark -

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.userTitleColor = YES;
}

- (void)setTitleColorHighlighted:(UIColor *)titleColorHighlighted {
    _titleColorHighlighted = titleColorHighlighted;
    self.userTitleColorHighlighted = YES;
}

- (void)setTitleColorDisabled:(UIColor *)titleColorDisabled {
    _titleColorDisabled = titleColorDisabled;
    self.userTitleColorDisabled = YES;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    self.userBackgroundColor = YES;
}

- (void)setBackgroundColorHighlighted:(UIColor *)backgroundColorHighlighted {
    _backgroundColorHighlighted = backgroundColorHighlighted;
    self.userBackgroundColorHighlighted = YES;
}

- (void)setBackgroundColorDisabled:(UIColor *)backgroundColorDisabled {
    _backgroundColorDisabled = backgroundColorDisabled;
    self.userBackgroundColorDisabled = YES;
}

- (void)setIconImage:(UIImage *)iconImage {
    _iconImage = iconImage;
    self.userIconImage = YES;
}

- (void)setIconImageHighlighted:(UIImage *)iconImageHighlighted {
    _iconImageHighlighted = iconImageHighlighted;
    self.userIconImageHighlighted = YES;
}

- (void)seticonImageDisabled:(UIImage *)iconImageDisabled {
    _iconImageDisabled = iconImageDisabled;
    self.userIconImageDisabled = YES;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
    self.userTextAlignment = YES;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.userFont = YES;
}

- (void)setNumberOfLines:(NSUInteger)numberOfLines {
    _numberOfLines = numberOfLines;
    self.userNumberOfLines = YES;
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    _lineBreakMode = lineBreakMode;
    self.userLineBreakMode = YES;
}

- (void)setMinimumScaleFactor:(CGFloat)minimumScaleFactor {
    _minimumScaleFactor = minimumScaleFactor;
    self.userMinimumScaleFactor = YES;
}

- (void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth {
    _adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;
    self.userAdjustsFontSizeTofitWidth = YES;
}

- (void)setIconPosition:(YYUIAlertViewButtonIconPosition)iconPosition {
    _iconPosition = iconPosition;
    self.userIconPosition = YES;
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    self.userEnabled = YES;
}

@end
