//
//  YYUIAlertAction.m
//  YYUIKit
//
//  Created by liuxc on 2021/12/7.
//

#import "YYUIAlertAction.h"

@interface YYUIAlertAction ()

@property (nonatomic, assign) YYUIAlertActionStyle style;
@property (nonatomic, copy) void (^handler)(YYUIAlertAction *action);
@property (nonatomic, copy) void (^updateBlock)(YYUIAlertAction *action, BOOL needUpdateConstraints);

@end

@implementation YYUIAlertAction

- (id)copyWithZone:(NSZone *)zone {
    
    YYUIAlertAction *action = [[[self class] alloc] init];
    action.title = self.title;
    action.highlight = self.highlight;
    action.attributedTitle = self.attributedTitle;
    action.attributedHighlight = self.attributedHighlight;
    action.numberOfLines = self.numberOfLines;
    action.textAlignment = self.textAlignment;
    action.font = self.font;
    action.adjustsFontSizeToFitWidth = self.adjustsFontSizeToFitWidth;
    action.lineBreakMode = self.lineBreakMode;
    action.tintColor = self.tintColor;
    action.titleColor = self.titleColor;
    action.highlightColor = self.highlightColor;
    action.backgroundColor = self.backgroundColor;
    action.backgroundHighlightColor = self.backgroundHighlightColor;
    action.backgroundImage = self.backgroundImage;
    action.backgroundHighlightImage = self.backgroundHighlightImage;
    action.image = self.image;
    action.highlightImage = self.highlightImage;
    action.insets = self.insets;
    action.imageEdgeInsets = self.imageEdgeInsets;
    action.titleEdgeInsets = self.titleEdgeInsets;
    action.height = self.height;
    action.enabled = self.enabled;
    action.dismissOnTouch = self.dismissOnTouch;
    action.handler = self.handler;
    action.updateBlock = self.updateBlock;
    return action;
}

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(YYUIAlertActionStyle)style handler:(void (^ __nullable)(YYUIAlertAction *action))handler {
    YYUIAlertAction *action = [[self alloc] initWithTitle:title style:(YYUIAlertActionStyle)style handler:handler];
    return action;
}

- (instancetype)initWithTitle:(nullable NSString *)title style:(YYUIAlertActionStyle)style handler:(void (^ __nullable)(YYUIAlertAction *action))handler {
    self = [self init];
    self.title = title;
    self.style = style;
    self.handler = handler;
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _enabled = YES; // 默认能点击
}

- (void)setTitle:(NSString *)title {
    _title = title;
    if (self.updateBlock) {
        self.updateBlock(self, YES);
    }
}

- (void)setHighlight:(NSString *)highlight {
    self.highlight = highlight;
    if (self.updateBlock) {
        self.updateBlock(self, YES);
    }
}

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle {
    _attributedTitle = attributedTitle;
    if (self.updateBlock) {
        self.updateBlock(self, YES);
    }
}

- (void)setAttributedHighlight:(NSAttributedString *)attributedHighlight {
    _attributedHighlight = attributedHighlight;
    if (self.updateBlock) {
        self.updateBlock(self, YES);
    }
}

- (void)setNumberOfLines:(NSInteger)numberOfLines {
    _numberOfLines = numberOfLines;
    if (self.updateBlock) {
        self.updateBlock(self, YES);
    }
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
    if (self.updateBlock) {
        self.updateBlock(self, YES);
    }
}

- (void)setFont:(UIFont *)font {
    _font = font;
    if (self.updateBlock) {
        self.updateBlock(self, YES);
    }
}

- (void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth {
    _adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;
    if (self.updateBlock) {
        self.updateBlock(self, YES);
    }
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    _lineBreakMode = lineBreakMode;
    if (self.updateBlock) {
        self.updateBlock(self, YES);
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    if (self.updateBlock) {
        self.updateBlock(self, NO);
    }
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    if (self.updateBlock) {
        self.updateBlock(self, NO);
    }
}

- (void)setHighlightColor:(UIColor *)highlightColor {
    _highlightColor = highlightColor;
    if (self.updateBlock) {
        self.updateBlock(self, NO);
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    if (self.updateBlock) {
        self.updateBlock(self, NO);
    }
}

- (void)setBackgroundHighlightColor:(UIColor *)backgroundHighlightColor {
    _backgroundHighlightColor = backgroundHighlightColor;
    if (self.updateBlock) {
        self.updateBlock(self, NO);
    }
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    if (self.updateBlock) {
        self.updateBlock(self, NO);
    }
}

- (void)setBackgroundHighlightImage:(UIImage *)backgroundHighlightImage {
    _backgroundHighlightImage = backgroundHighlightImage;
    if (self.updateBlock) {
        self.updateBlock(self, NO);
    }
}

- (void)setImage:(UIImage *)image {
    _image = image;
    if (self.updateBlock) {
        self.updateBlock(self, YES);
    }
}

- (void)setHighlightImage:(UIImage *)highlightImage {
    _highlightImage = highlightImage;
    if (self.updateBlock) {
        self.updateBlock(self, YES);
    }
}

- (void)setInsets:(UIEdgeInsets)insets {
    _insets = insets;
    if (self.updateBlock) {
        self.updateBlock(self, YES);
    }
}

- (void)setImageEdgeInsets:(UIEdgeInsets)imageEdgeInsets {
    _imageEdgeInsets = imageEdgeInsets;
    if (self.updateBlock) {
        self.updateBlock(self, YES);
    }
}

- (void)setTitleEdgeInsets:(UIEdgeInsets)titleEdgeInsets {
    _titleEdgeInsets = titleEdgeInsets;
    if (self.updateBlock) {
        self.updateBlock(self, YES);
    }
}

- (void)setHeight:(CGFloat)height {
    _height = height;
    if (self.updateBlock) {
        self.updateBlock(self, YES);
    }
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    if (self.updateBlock) {
        self.updateBlock(self, NO);
    }
}

@end
