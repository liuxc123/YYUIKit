//
//  YYUIAlertController.m
//  YYUIKit
//
//  Created by 刘学成 on 2021/12/5.
//

#import "YYUIAlertController.h"
#import "YYUIKitMacro.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - YYUIAlertAction

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


#pragma mark - YYUIAlertControllerActionItemSeparatorView

@interface YYUIAlertControllerActionItemSeparatorView : UIView
@end
@implementation YYUIAlertControllerActionItemSeparatorView
@end


#pragma mark - YYUIAlertControllerHeaderScrollView

@interface YYUIAlertControllerHeaderScrollView : UIScrollView
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *messageLabel;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, assign) CGSize imageLimitSize;
@property (nonatomic, weak) UIStackView *textFieldView;
@property (nonatomic, strong) NSMutableArray *textFields;
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;
@property (nonatomic, copy) void(^headerViewSafeAreaDidChangeBlock)(void);
@end

@implementation YYUIAlertControllerHeaderScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        self.contentEdgeInsets = UIEdgeInsetsMake(20, 15, 20, 15);
    }
    return self;
}

- (void)addTextField:(UITextField *)textField {
    [self.textFields addObject:textField];
    // 将textView添加到self.textFieldView中的布局队列中，UIStackView会根据设置的属性自动布局
    [self.textFieldView addArrangedSubview:textField];
    // 由于self.textFieldView是没有高度的，它的高度由子控件撑起，所以子控件必须要有高度
    [[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30.0f] setActive:YES];
    [self setNeedsUpdateConstraints];
}

- (NSMutableArray *)textFields {
    if (!_textFields) {
        _textFields = [[NSMutableArray alloc] init];
    }
    return _textFields;
}

- (void)safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];
    CGFloat safeTop    = self.safeAreaInsets.top < 20 ? 20 : self.safeAreaInsets.top+10;
    CGFloat safeLeft   = self.safeAreaInsets.left < 15 ? 15 : self.safeAreaInsets.left;
    CGFloat safeBottom = self.safeAreaInsets.bottom < 20 ? 20 : self.safeAreaInsets.bottom+6;
    CGFloat safeRight  = self.safeAreaInsets.right < 15 ? 15 : self.safeAreaInsets.right;
    _contentEdgeInsets = UIEdgeInsetsMake(safeTop, safeLeft, safeBottom, safeRight);
    // 这个block，主要是更新Label的最大预估宽度
    if (self.headerViewSafeAreaDidChangeBlock) {
        self.headerViewSafeAreaDidChangeBlock();
    }
    [self setNeedsUpdateConstraints];
}

- (YYUIAlertController *)findAlertController {
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[YYUIAlertController class]]) {
            return (YYUIAlertController *)next;
        } else {
            next = [next nextResponder];
        }
    } while (next != nil);
    return nil;
}

- (void)updateConstraints {
    [super updateConstraints];
    UIView *contentView = self.contentView;
    // 对contentView布局
    // 先移除旧约束，再添加新约束
    [NSLayoutConstraint deactivateConstraints:self.constraints];
    [NSLayoutConstraint deactivateConstraints:contentView.constraints];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[contentView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentView)]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[contentView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentView)]];
    [[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0] setActive:YES];
    NSLayoutConstraint *equalHeightConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    equalHeightConstraint.priority = 998.0f; // 优先级不能最高， 最顶层的父view有高度限制，如果子控件撑起后的高度大于限制高度，则scrollView滑动查看全部内容
    equalHeightConstraint.active = YES;

    UIImageView *imageView = _imageView;
    UIStackView *textFieldView = _textFieldView;

    CGFloat leftMargin   = self.contentEdgeInsets.left;
    CGFloat rightMargin  = self.contentEdgeInsets.right;
    CGFloat topMargin    = self.contentEdgeInsets.top;
    CGFloat bottomMargin = self.contentEdgeInsets.bottom;
    
    // imageView布局
    if (imageView.image) {
        NSMutableArray *imageViewConstraints = [NSMutableArray array];
        [imageViewConstraints addObject:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:MIN(imageView.image.size.width, _imageLimitSize.width)]];
        [imageViewConstraints addObject:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:MIN(imageView.image.size.height, _imageLimitSize.height)]];
        [imageViewConstraints addObject:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0]];
        [imageViewConstraints addObject:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTop multiplier:1.f constant:topMargin]];
        if (_titleLabel.text.length || _titleLabel.attributedText.length) {
            [imageViewConstraints addObject:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeTop multiplier:1.f constant:-17]];
        } else if (_messageLabel.text.length || _messageLabel.attributedText.length) {
            [imageViewConstraints addObject:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_messageLabel attribute:NSLayoutAttributeTop multiplier:1.f constant:-17]];
        } else if (_textFields.count) {
            [imageViewConstraints addObject:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:textFieldView attribute:NSLayoutAttributeTop multiplier:1.f constant:-17]];
        } else {
            [imageViewConstraints addObject:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeBottom multiplier:1.f constant:-bottomMargin]];
        }
        [NSLayoutConstraint activateConstraints:imageViewConstraints];
    }
    
    // 对titleLabel和messageLabel布局
    NSMutableArray *titleLabelConstraints = [NSMutableArray array];
    NSMutableArray *labels = [NSMutableArray array];
    if (_titleLabel.text.length || _titleLabel.attributedText.length) {
        [labels insertObject:_titleLabel atIndex:0];
    }
    if (_messageLabel.text.length || _messageLabel.attributedText.length) {
        [labels addObject:_messageLabel];
    }
    [labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL * _Nonnull stop) {
        // 左右间距
        [titleLabelConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(==leftMargin)-[label]-(==rightMargin)-|"] options:0 metrics:@{@"leftMargin":@(leftMargin),@"rightMargin":@(rightMargin)} views:NSDictionaryOfVariableBindings(label)]];
        // 第一个子控件顶部间距
        if (idx == 0) {
            if (!imageView.image) {
                [titleLabelConstraints addObject:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTop multiplier:1.f constant:topMargin]];
            }
        }
        // 最后一个子控件底部间距
        if (idx == labels.count - 1) {
            if (self.textFields.count) {
                [titleLabelConstraints addObject:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:textFieldView attribute:NSLayoutAttributeTop multiplier:1.f constant:-bottomMargin]];
            } else {
                [titleLabelConstraints addObject:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeBottom multiplier:1.f constant:-bottomMargin]];
            }
        }
        // 子控件之间的垂直间距
        if (idx > 0) {
            [titleLabelConstraints addObject:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:labels[idx - 1] attribute:NSLayoutAttributeBottom multiplier:1.f constant:7.5]];
        }
    }];
    [NSLayoutConstraint activateConstraints:titleLabelConstraints];
    
    if (self.textFields.count) {
        NSMutableArray *textFieldViewConstraints = [NSMutableArray array];
        if (!labels.count && !imageView.image) { // 没有titleLabel、messageLabel和iconView，textFieldView的顶部相对contentView,否则不用写,因为前面写好了
            [textFieldViewConstraints addObject:[NSLayoutConstraint constraintWithItem:textFieldView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTop multiplier:1.f constant:topMargin]];
        }
        [textFieldViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(==leftMargin)-[textFieldView]-(==rightMargin)-|"] options:0 metrics:@{@"leftMargin":@(leftMargin),@"rightMargin":@(rightMargin)} views:NSDictionaryOfVariableBindings(textFieldView)]];
        [textFieldViewConstraints addObject:[NSLayoutConstraint constraintWithItem:textFieldView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeBottom multiplier:1.f constant:-bottomMargin]];

        [NSLayoutConstraint activateConstraints:textFieldViewConstraints];
    }
    
    // systemLayoutSizeFittingSize:方法获取子控件撑起contentView后的高度，如果子控件是UILabel，那么子label必须设置preferredMaxLayoutWidth,否则当label多行文本时计算不准确
    NSLayoutConstraint *contentViewHeightConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height];
    contentViewHeightConstraint.active = YES;
}

- (UIView *)contentView {
    if (!_contentView) {
        UIView *contentView = [[UIView alloc] init];
        contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:contentView];
        _contentView = contentView;
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.numberOfLines = 0;
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.font = [UIFont systemFontOfSize:18];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.textColor = [UIColor grayColor];
        messageLabel.numberOfLines = 0;
        messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:messageLabel];
        _messageLabel = messageLabel;
    }
    return _messageLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView insertSubview:imageView atIndex:0];
        _imageView = imageView;
    }
    return _imageView;
}

- (UIStackView *)textFieldView {
    if (!_textFieldView) {
        UIStackView *textFieldView = [[UIStackView alloc] init];
        textFieldView.translatesAutoresizingMaskIntoConstraints = NO;
        textFieldView.distribution = UIStackViewDistributionFillEqually;
        textFieldView.axis = UILayoutConstraintAxisVertical;
        if (self.textFields.count) {
            [self.contentView addSubview:textFieldView];
        }
        _textFieldView = textFieldView;
    }
    return _textFieldView;
}

@end


#pragma mark - YYUIAlertControllerActionView

@interface YYUIAlertControllerActionView : UIView
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL methodAction;
@property (nonatomic, strong) YYUIAlertAction *action;
@property (nonatomic, weak) UIButton *actionButton;
@property (nonatomic, strong) NSMutableArray *actionButtonConstraints;
@property (nonatomic, assign) CGFloat afterSpacing;
- (void)addTarget:(id)target action:(SEL)action;
@end

@implementation YYUIAlertControllerActionView

- (instancetype)init {
    if (self = [super init]) {
        _afterSpacing = CGFloatToPixel(1.0);
    }
    return self;
}

- (void)setAction:(YYUIAlertAction *)action {
    _action = action;
    
    self.clipsToBounds = YES;
    self.actionButton.clipsToBounds = YES;

    if (action.title) [self.actionButton setTitle:action.title forState:UIControlStateNormal];
    
    if (action.highlight) [self.actionButton setTitle:action.highlight forState:UIControlStateHighlighted];
    
    if (action.attributedTitle) [self.actionButton setAttributedTitle:action.attributedTitle forState:UIControlStateNormal];
    
    if (action.attributedHighlight) [self.actionButton setAttributedTitle:action.attributedHighlight forState:UIControlStateHighlighted];
    
    [self.actionButton.titleLabel setNumberOfLines:action.numberOfLines];
    
    [self.actionButton.titleLabel setTextAlignment:action.textAlignment];
    
    if (action.font) [self.actionButton.titleLabel setFont:action.font];
    
    [self.actionButton.titleLabel setAdjustsFontSizeToFitWidth:action.adjustsFontSizeToFitWidth];
    
    [self.actionButton.titleLabel setLineBreakMode:action.lineBreakMode];
    
    if (action.tintColor) [self.actionButton setTintColor:action.tintColor];
    
    if (action.titleColor) [self.actionButton setTitleColor:action.titleColor forState:UIControlStateNormal];
    
    if (action.highlightColor) [self.actionButton setTitleColor:action.highlightColor forState:UIControlStateHighlighted];
    
    if (action.backgroundColor) [self.actionButton setBackgroundImage:[self getImageWithColor:action.backgroundColor] forState:UIControlStateNormal];
    
    if (action.backgroundHighlightColor) [self.actionButton setBackgroundImage:[self getImageWithColor:action.backgroundHighlightColor] forState:UIControlStateHighlighted];
    
    if (action.backgroundImage) [self.actionButton setBackgroundImage:action.backgroundImage forState:UIControlStateNormal];
    
    if (action.backgroundHighlightImage) [self.actionButton setBackgroundImage:action.backgroundHighlightImage forState:UIControlStateHighlighted];
    
    if (action.image) [self.actionButton setImage:action.image forState:UIControlStateNormal];
    
    if (action.highlightImage) [self.actionButton setImage:action.highlightImage forState:UIControlStateHighlighted];
    
    [self.actionButton setContentEdgeInsets:action.insets];

    [self.actionButton setImageEdgeInsets:action.imageEdgeInsets];
    
    [self.actionButton setTitleEdgeInsets:action.titleEdgeInsets];
    
    [self.actionButton setEnabled:action.enabled];
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

- (void)addTarget:(id)target action:(SEL)methodAction {
    _target = target;
    _methodAction = methodAction;
}

- (void)touchUpInside:(UIButton *)sender {
    // 用函数指针实现_target调用_methodAction，相当于[_target performSelector:_methodAction withObject:self];但是后者会报警告
    SEL selector = _methodAction;
    IMP imp = [_target methodForSelector:selector];
    void (*func)(id, SEL,YYUIAlertControllerActionView *) = (void *)imp;
    func(_target, selector, self);
}

- (void)touchDown:(UIButton *)sender {
    sender.backgroundColor = self.action.backgroundHighlightColor;
}

- (void)touchDragExit:(UIButton *)sender {
    sender.backgroundColor = self.action.backgroundColor;
}

- (void)safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];
    self.actionButton.contentEdgeInsets = UIEdgeInsetsAddEdgeInsets(self.safeAreaInsets, _action.titleEdgeInsets);
    [self setNeedsUpdateConstraints];
}

UIEdgeInsets UIEdgeInsetsAddEdgeInsets(UIEdgeInsets i1,UIEdgeInsets i2) {
    return UIEdgeInsetsMake(i1.top+i2.top, i1.left+i2.left, i1.bottom+i2.bottom, i1.right+i2.right);
}

- (void)updateConstraints {
    [super updateConstraints];
    
    UIButton *actionButton = self.actionButton;
    CGFloat actionHeight = self.action.height;

    if (self.actionButtonConstraints) {
        [NSLayoutConstraint deactivateConstraints:self.actionButtonConstraints];
        self.actionButtonConstraints = nil;
    }
    NSMutableArray *actionButtonConstraints = [NSMutableArray array];
    [actionButtonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[actionButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(actionButton)]];
    [actionButtonConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[actionButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(actionButton)]];
    
    // titleLabel的内容自适应的高度
    CGFloat labelH = actionButton.titleLabel.intrinsicContentSize.height;
    // 按钮的上下内边距之和
    CGFloat topBottom_insetsSum = actionButton.contentEdgeInsets.top + actionButton.contentEdgeInsets.bottom;
    // 文字的上下间距之和
    CGFloat topBottom_marginSum = actionHeight - actionButton.font.lineHeight;
    // 按钮高度
    CGFloat buttonH = labelH + topBottom_insetsSum + topBottom_marginSum;
    UIStackView *stackView = (UIStackView *)self.superview;
    NSLayoutRelation relation = NSLayoutRelationEqual;
    if ([stackView isKindOfClass:[UIStackView class]] && stackView.axis == UILayoutConstraintAxisHorizontal) {
        relation = NSLayoutRelationGreaterThanOrEqual;
    }
    // 如果字体保持默认18号，只有一行文字时最终结果约等于SP_ACTION_HEIGHT
    NSLayoutConstraint *buttonHonstraint = [NSLayoutConstraint constraintWithItem:actionButton attribute:NSLayoutAttributeHeight relatedBy:relation toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:buttonH];
    buttonHonstraint.priority = 999;
    [actionButtonConstraints addObject:buttonHonstraint];
    // 给一个最小高度，当按钮字体很小时，如果还按照上面的高度计算，高度会比较小
    NSLayoutConstraint *minHConstraint = [NSLayoutConstraint constraintWithItem:actionButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:actionHeight+topBottom_insetsSum];
    minHConstraint.priority = UILayoutPriorityRequired;
    [self addConstraints:actionButtonConstraints];
    self.actionButtonConstraints = actionButtonConstraints;
}

- (UIButton *)actionButton {
    if (!_actionButton) {
        UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        actionButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        actionButton.translatesAutoresizingMaskIntoConstraints = NO;
        actionButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        actionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        actionButton.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        actionButton.titleLabel.minimumScaleFactor = 0.5;
        [actionButton addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [actionButton addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragInside];
        [actionButton addTarget:self action:@selector(touchDragExit:) forControlEvents:UIControlEventTouchDragExit | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        [self addSubview:actionButton];
        _actionButton = actionButton;
    }
    return _actionButton;
}

@end


#pragma mark - YYUIAlertControllerActionSequenceView

@interface YYUIAlertControllerActionSequenceView : UIView
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIView *cancelView;
@property (nonatomic, weak) YYUIAlertControllerActionItemSeparatorView *cancelActionLine;
@property (nonatomic, weak) UIStackView *stackView;
@property (nonatomic, strong) YYUIAlertAction *cancelAction;
@property (nonatomic, strong) NSMutableArray *actionLineConstraints;
@property (nonatomic, strong) NSMutableArray *actions;
@property (nonatomic, assign) UIStackViewDistribution stackViewDistribution;
@property (nonatomic, assign) UILayoutConstraintAxis axis;
@property (nonatomic, copy) void (^buttonClickedInActionViewBlock)(NSInteger index);
@end

@implementation YYUIAlertControllerActionSequenceView

- (void)setAxis:(UILayoutConstraintAxis)axis {
    _axis = axis;
    self.stackView.axis = axis;
    [self setNeedsUpdateConstraints];
}

- (void)setStackViewDistribution:(UIStackViewDistribution)stackViewDistribution {
    _stackViewDistribution = stackViewDistribution;
    self.stackView.distribution = stackViewDistribution;
    [self setNeedsUpdateConstraints];
}

- (void)buttonClickedInActionView:(YYUIAlertControllerActionView *)actionView {
    NSInteger index = [self.actions indexOfObject:actionView.action];
    if (self.buttonClickedInActionViewBlock) {
        self.buttonClickedInActionViewBlock(index);
    }
}

- (void)setCustomSpacing:(CGFloat)spacing afterActionIndex:(NSInteger)index {
    UIStackView *stackView = self.stackView;
    YYUIAlertControllerActionView *actionView = stackView.arrangedSubviews[index];
    actionView.afterSpacing = spacing;
    if (@available(iOS 11.0, *)) {
        [self.stackView setCustomSpacing:spacing afterView:actionView];
    }
    [self updateLineConstraints];
}

- (CGFloat)customSpacingAfterActionIndex:(NSInteger)index {
    UIStackView *stackView = self.stackView;
    YYUIAlertControllerActionView *actionView = stackView.arrangedSubviews[index];
    if (@available(iOS 11.0, *)) {
       return [self.stackView customSpacingAfterView:actionView];
    } else {
        return 0.0;
    }
}

- (void)addAction:(YYUIAlertAction *)action {
    [self.actions addObject:action];
    UIStackView *stackView = self.stackView;

    YYUIAlertControllerActionView *currentActionView = [[YYUIAlertControllerActionView alloc] init];
    currentActionView.action = action;
    [currentActionView addTarget:self action:@selector(buttonClickedInActionView:)];
    [stackView addArrangedSubview:currentActionView];

    if (stackView.arrangedSubviews.count > 1) { // arrangedSubviews个数大于1，说明本次添加至少是第2次添加，此时要加一条分割线
        [self addLineForStackView:stackView];
    }
    [self setNeedsUpdateConstraints];
}

- (void)addCancelAction:(YYUIAlertAction *)action {
    // 如果已经存在取消样式的按钮，则直接崩溃
    NSAssert(!_cancelAction, @"YYUIAlertController can only have one action with a style of YYUIAlertActionStyleCancel");
    _cancelAction = action;
    [self.actions addObject:action];
    YYUIAlertControllerActionView *cancelActionView = [[YYUIAlertControllerActionView alloc] init];
    cancelActionView.translatesAutoresizingMaskIntoConstraints = NO;
    cancelActionView.action = action;
    [cancelActionView addTarget:self action:@selector(buttonClickedInActionView:)];
    [self.cancelView addSubview:cancelActionView];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[cancelActionView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(cancelActionView)]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[cancelActionView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(cancelActionView)]];
    
    [self setNeedsUpdateConstraints];
}

// 为stackView添加分割线(细节)
- (void)addLineForStackView:(UIStackView *)stackView {
    YYUIAlertControllerActionItemSeparatorView *actionLine = [[YYUIAlertControllerActionItemSeparatorView alloc] init];
    actionLine.translatesAutoresizingMaskIntoConstraints = NO;
    // 这里必须用addSubview:，不能用addArrangedSubview:,因为分割线不参与排列布局
    [stackView addSubview:actionLine];
}

- (YYUIAlertController *)findAlertController {
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[YYUIAlertController class]]) {
            return (YYUIAlertController *)next;
        } else {
            next = [next nextResponder];
        }
    } while (next != nil);
    return nil;
}

// 从一个数组筛选出不在另一个数组中的数组
- (NSArray *)filteredArrayFromArray:(NSArray *)array notInArray:(NSArray *)otherArray {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", otherArray];
    // 用谓词语句筛选出所有的分割线
    NSArray *subArray = [array filteredArrayUsingPredicate:predicate];
    return subArray;
}

// 更新分割线约束(细节)
- (void)updateLineConstraints {

    UIStackView *stackView = self.stackView;
    NSArray *arrangedSubviews = stackView.arrangedSubviews;
    if (arrangedSubviews.count <= 1) return;
    // 用谓词语句筛选出所有的分割线
    NSArray *lines = [self filteredArrayFromArray:stackView.subviews notInArray:stackView.arrangedSubviews];
    if (arrangedSubviews.count < lines.count) return;
    NSMutableArray *actionLineConstraints = [NSMutableArray array];
    if (self.actionLineConstraints) {
        [NSLayoutConstraint deactivateConstraints:self.actionLineConstraints];
        self.actionLineConstraints = nil;
    }
    for (int i = 0; i < lines.count; i++) {
        YYUIAlertControllerActionItemSeparatorView *actionLine = lines[i];
        YYUIAlertControllerActionView *actionView1 = arrangedSubviews[i];
        YYUIAlertControllerActionView *actionView2 = arrangedSubviews[i+1];
        if (self.axis == UILayoutConstraintAxisHorizontal) {
            [actionLineConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[actionLine]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(actionLine)]];
            [actionLineConstraints addObject:[NSLayoutConstraint constraintWithItem:actionLine attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:actionView1 attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
            [actionLineConstraints addObject:[NSLayoutConstraint constraintWithItem:actionLine attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:actionView2 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
            [actionLineConstraints addObject:[NSLayoutConstraint constraintWithItem:actionLine attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:actionView1.afterSpacing]];
        } else {
            [actionLineConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[actionLine]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(actionLine)]];
            [actionLineConstraints addObject:[NSLayoutConstraint constraintWithItem:actionLine attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:actionView1 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
            [actionLineConstraints addObject:[NSLayoutConstraint constraintWithItem:actionLine attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:actionView2 attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
            [actionLineConstraints addObject:[NSLayoutConstraint constraintWithItem:actionLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:actionView1.afterSpacing]];
        }
    }
    [NSLayoutConstraint activateConstraints:actionLineConstraints];
    self.actionLineConstraints = actionLineConstraints;
}

- (void)updateConstraints {
    [super updateConstraints];
    UIView *scrollView = self.scrollView;
    UIView *contentView = self.contentView;
    UIView *cancelView = self.cancelView;
    YYUIAlertControllerActionItemSeparatorView *cancelActionLine = self.cancelActionLine;
    CGFloat actionHeight = [self findAlertController].actionsHeight;

    [NSLayoutConstraint deactivateConstraints:self.constraints];
    if (scrollView && scrollView.superview) {
        // 对scrollView布局
        NSMutableArray *scrollViewConstraints = [NSMutableArray array];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[scrollView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(scrollView)]];
        [scrollViewConstraints addObject:[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        if (cancelActionLine.superview) {
            [scrollViewConstraints addObject:[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cancelActionLine attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        } else {
            [scrollViewConstraints addObject:[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        }
        [NSLayoutConstraint activateConstraints:scrollViewConstraints];
        
        [NSLayoutConstraint deactivateConstraints:scrollView.constraints];
        // 对contentView布局
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[contentView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentView)]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[contentView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentView)]];
        [[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0] setActive:YES];
        NSLayoutConstraint *equalHeightConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
        // 计算scrolView的最小和最大高度，下面这个if语句是保证当actions的g总个数大于4时，scrollView的高度至少为4个半SP_ACTION_HEIGHT的高度，否则自适应内容
        CGFloat minHeight = 0.0;
        if (_axis == UILayoutConstraintAxisVertical) {
            if (self.cancelAction) {
                if (self.actions.count > 4) { // 如果有取消按钮且action总个数大于4，则除去取消按钮之外的其余部分的高度至少为3个半SP_ACTION_HEIGHT的高度,即加上取消按钮就是总高度至少为4个半SP_ACTION_HEIGHT的高度
                    minHeight = actionHeight * 3.5;
                    equalHeightConstraint.priority = 997.0f; // 优先级为997，必须小于998.0，因为头部如果内容过多时高度也会有限制，头部的优先级为998.0.这里定的规则是，当头部和action部分同时过多时，头部的优先级更高，但是它不能高到以至于action部分小于最小高度
                } else { // 如果有取消按钮但action的个数大不于4，则该多高就显示多高
                    equalHeightConstraint.priority = 1000.0f; // 由子控件撑起
                }
            } else {
                if (self.actions.count > 4) {
                    minHeight = actionHeight * 4.5;
                    equalHeightConstraint.priority = 997.0f;
                } else {
                    equalHeightConstraint.priority = 1000.0f;
                }
            }
        } else {
            minHeight = actionHeight;
        }
        NSLayoutConstraint *minHeightConstraint = [NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:minHeight];
        minHeightConstraint.priority = 999.0;// 优先级不能大于对话框的最小顶部间距的优先级(999.0)
        minHeightConstraint.active = YES;
        equalHeightConstraint.active = YES;
        
        UIStackView *stackView = self.stackView;
        [NSLayoutConstraint deactivateConstraints:contentView.constraints];
        // 对stackView布局
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[stackView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(stackView)]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[stackView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(stackView)]];
        
        // 对stackView里面的分割线布局
        [self updateLineConstraints];
    }
  
    if (self.cancelActionLine.superview) { // cancelActionLine有superView则必有scrollView和cancelView
        NSMutableArray *cancelActionLineConstraints = [NSMutableArray array];
        [cancelActionLineConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[cancelActionLine]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(cancelActionLine)]];
        [cancelActionLineConstraints addObject:[NSLayoutConstraint constraintWithItem:cancelActionLine attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cancelView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0]];
        [cancelActionLineConstraints addObject:[NSLayoutConstraint constraintWithItem:cancelActionLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:8.0]];
        [NSLayoutConstraint activateConstraints:cancelActionLineConstraints];
    }
    
    // 对cancelView布局
    if (self.cancelAction) { // 有取消样式的按钮才对cancelView布局
        NSMutableArray *cancelViewConstraints = [NSMutableArray array];
        [cancelViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[cancelView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(cancelView)]];
        [cancelViewConstraints addObject:[NSLayoutConstraint constraintWithItem:cancelView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        if (!self.cancelActionLine.superview) {
            [cancelViewConstraints addObject:[NSLayoutConstraint constraintWithItem:cancelView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        }
        [NSLayoutConstraint activateConstraints:cancelViewConstraints];
    }
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        if (@available(iOS 11.0, *)) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        if ((self.cancelAction && self.actions.count > 1) || (!self.cancelAction && self.actions.count > 0)) {
            [self addSubview:scrollView];
        }
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (UIView *)contentView {
    if (!_contentView) {
        UIView *contentView = [[UIView alloc] init];
        contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.scrollView addSubview:contentView];
        _contentView = contentView;
    }
    return _contentView;
}

- (UIStackView *)stackView {
    if (!_stackView) {
        UIStackView *stackView = [[UIStackView alloc] init];
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
        stackView.distribution = UIStackViewDistributionFillProportionally;
        stackView.spacing = CGFloatToPixel(1.0); // 该间距腾出来的空间显示分割线
        stackView.axis = UILayoutConstraintAxisVertical;
        [self.contentView addSubview:stackView];
        _stackView = stackView;
    }
    return _stackView;
}

- (UIView *)cancelView {
    if (!_cancelView) {
        UIView *cancelView = [[UIView alloc] init];
        cancelView.translatesAutoresizingMaskIntoConstraints = NO;
        if (self.cancelAction) {
            [self addSubview:cancelView];
        }
        _cancelView = cancelView;
    }
    return _cancelView;
}

- (YYUIAlertControllerActionItemSeparatorView *)cancelActionLine {
    if (!_cancelActionLine) {
        YYUIAlertControllerActionItemSeparatorView *cancelActionLine = [[YYUIAlertControllerActionItemSeparatorView alloc] init];
        cancelActionLine.translatesAutoresizingMaskIntoConstraints = NO;
        if (self.cancelView.superview && self.scrollView.superview) {
            [self addSubview:cancelActionLine];
        }
        _cancelActionLine = cancelActionLine;
    }
    return _cancelActionLine;
}

- (NSMutableArray *)actions {
    if (!_actions) {
        _actions = [[NSMutableArray alloc] init];
    }
    return _actions;
}

@end


#pragma mark - YYUIAlertController

@interface YYUIAlertController () <UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UIView *alertControllerView;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIView *alertView;
@property (nonatomic, strong) UIView *customAlertView;
@property (nonatomic, weak) YYUIAlertControllerHeaderScrollView *headerView;
@property (nonatomic, strong) UIView *customHeaderView;
@property (nonatomic, weak) YYUIAlertControllerActionSequenceView *actionSequenceView;
@property (nonatomic, strong) UIView *customActionSequenceView;
@property (nonatomic, strong) UIView *componentView;
@property (nonatomic, assign) CGSize customViewSize;
@property (nonatomic, weak) YYUIAlertControllerActionItemSeparatorView *headerActionLine;
@property (nonatomic, strong) NSMutableArray *headerActionLineConstraints;
@property (nonatomic, weak) YYUIAlertControllerActionItemSeparatorView *componentActionLine;
@property (nonatomic, strong) NSMutableArray *componentViewConstraints;
@property (nonatomic, strong) NSMutableArray *componentActionLineConstraints;
@property (nonatomic, strong) UIView *dimmingKnockoutBackdropView;
@property (nonatomic, strong) NSMutableArray *alertControllerViewConstraints;
@property (nonatomic, strong) NSMutableArray *headerViewConstraints;
@property (nonatomic, strong) NSMutableArray *actionSequenceViewConstraints;
@property (nonatomic, assign) YYUIAlertControllerStyle preferredStyle;
@property (nonatomic, assign) YYUIAlertAnimationType animationType;
@property (nonatomic, assign) UIBlurEffectStyle backgroundViewAppearanceStyle;
@property (nonatomic, assign) CGFloat backgroundViewAlpha;

// action数组
@property (nonatomic) NSArray<YYUIAlertAction *> *actions;
// textFiled数组
@property (nonatomic) NSArray<UITextField *> *textFields;
// 除去取消样式action的其余action数组
@property (nonatomic) NSMutableArray<YYUIAlertAction *> *otherActions;
@property (nonatomic, assign) BOOL isForceLayout; // 是否强制排列，外界设置了actionAxis属性认为是强制
@property (nonatomic, assign) BOOL isForceOffset; // 是否强制偏移，外界设置了offsetForAlert属性认为是强制
@end

@implementation YYUIAlertController
@synthesize title = _title;


#pragma mark - Private

- (instancetype)initWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message
              customAlertView:(UIView *)customAlertView
             customHeaderView:(UIView *)customHeaderView
     customActionSequenceView:(UIView *)customActionSequenceView
                componentView:(UIView *)componentView
               preferredStyle:(YYUIAlertControllerStyle)preferredStyle
                animationType:(YYUIAlertAnimationType)animationType {
    self = [self init];
    _title = title;
    _message = message;
    _preferredStyle = preferredStyle;
    // 如果是默认动画，preferredStyle为alert时动画默认为alpha，preferredStyle为actionShee时动画默认为fromBottom
    if (animationType == YYUIAlertAnimationTypeDefault) {
        if (preferredStyle == YYUIAlertControllerStyleAlert) {
            animationType = YYUIAlertAnimationTypeShrink;
        } else {
            animationType = YYUIAlertAnimationTypeFromBottom;
        }
    }
    _animationType = animationType;
    if (preferredStyle == YYUIAlertControllerStyleAlert) {
        _minDistanceToEdges = (MIN(kScreenWidth, kScreenHeight) - 275) / 2.0;
        _cornerRadius = 6.0;
    } else {
        _minDistanceToEdges = 70;
        _cornerRadius = 13.0;
    }
    if (preferredStyle == YYUIAlertControllerStyleAlert) {
        _actionAxis = UILayoutConstraintAxisHorizontal;
    } else {
        _actionAxis = UILayoutConstraintAxisVertical;
    }
    _customAlertView = customAlertView;
    _customHeaderView = customHeaderView;
    _customActionSequenceView = customActionSequenceView;
    _componentView = componentView; // componentView参数是为了支持老版本的自定义footerView
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    // 视图控制器定义它呈现视图控制器的过渡风格（默认为NO）
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
}


- (void)layoutAlertControllerView {
    if (!self.alertControllerView.superview) return;
    if (self.alertControllerViewConstraints) {
        [NSLayoutConstraint deactivateConstraints:self.alertControllerViewConstraints];
        self.alertControllerViewConstraints = nil;
    }
    if (self.preferredStyle == YYUIAlertControllerStyleAlert) { // alert样式
        [self layoutAlertControllerViewForAlertStyle];
    } else { // actionSheet样式
        [self layoutAlertControllerViewForActionSheetStyle];
    }
}

- (void)layoutAlertControllerViewForAlertStyle {
    UIView *alertControllerView = self.alertControllerView;
    NSMutableArray *alertControllerViewConstraints = [NSMutableArray array];
    CGFloat topValue = _minDistanceToEdges;
    CGFloat bottomValue = _minDistanceToEdges;
    CGFloat maxWidth = MIN(kScreenWidth, kScreenHeight)-_minDistanceToEdges * 2;
    CGFloat maxHeight = kScreenHeight-topValue-bottomValue;
    if (!self.customAlertView) {
        // 当屏幕旋转的时候，为了保持alert样式下的宽高不变，因此取MIN(kScreenWidth, kScreenHeight)
        [alertControllerViewConstraints addObject:[NSLayoutConstraint constraintWithItem:alertControllerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:maxWidth]];
    } else {
        [alertControllerViewConstraints addObject:[NSLayoutConstraint constraintWithItem:alertControllerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:maxWidth]];
        if (_customViewSize.width) { // 如果宽度没有值，则会假定customAlertView水平方向能由子控件撑起
            // 限制最大宽度，且能保证内部约束不报警告
            CGFloat customWidth = MIN(_customViewSize.width, maxWidth);
            [alertControllerViewConstraints addObject:[NSLayoutConstraint constraintWithItem:alertControllerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:customWidth]];
        }
        if (_customViewSize.height) { // 如果高度没有值，则会假定customAlertView垂直方向能由子控件撑起
            CGFloat customHeight = MIN(_customViewSize.height, maxHeight);
            [alertControllerViewConstraints addObject:[NSLayoutConstraint constraintWithItem:alertControllerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:customHeight]];
        }
    }
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:alertControllerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:alertControllerView.superview attribute:NSLayoutAttributeTop multiplier:1.0f constant:topValue];
    topConstraint.priority = 999.0;// 这里优先级为999.0是为了小于垂直中心的优先级，如果含有文本输入框，键盘弹出后，特别是旋转到横屏后，对话框的空间比较小，这个时候优先偏移垂直中心，顶部优先级按理说应该会被忽略，但是由于子控件含有scrollView，所以该优先级仍然会被激活，子控件显示不全scrollView可以滑动。如果外界自定义了整个对话框，且自定义的view上含有文本输入框，子控件不含有scrollView，顶部间距会被忽略
    [alertControllerViewConstraints addObject:topConstraint];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:alertControllerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:alertControllerView.superview attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-bottomValue];
    bottomConstraint.priority = 999.0; // 优先级跟顶部同理
    [alertControllerViewConstraints addObject:bottomConstraint];
    [alertControllerViewConstraints addObject:[NSLayoutConstraint constraintWithItem:alertControllerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:alertControllerView.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant: _offsetForAlert.x]];
    NSLayoutConstraint *alertControllerViewConstraintCenterY = [NSLayoutConstraint constraintWithItem:alertControllerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:alertControllerView.superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:(self.isBeingPresented && !self.isBeingDismissed) ? 0 : _offsetForAlert.y];
    [alertControllerViewConstraints addObject:alertControllerViewConstraintCenterY];
    [NSLayoutConstraint activateConstraints:alertControllerViewConstraints];
    self.alertControllerViewConstraints = alertControllerViewConstraints;
}

- (void)layoutAlertControllerViewForActionSheetStyle {
    switch (self.animationType) {
        case YYUIAlertAnimationTypeFromBottom:
        default:
            [self layoutAlertControllerViewForAnimationTypeWithHV:@"H"
                                                   equalAttribute:NSLayoutAttributeBottom
                                                notEqualAttribute:NSLayoutAttributeTop
                                            lessOrGreaterRelation:NSLayoutRelationGreaterThanOrEqual];
            break;
        case YYUIAlertAnimationTypeFromTop:
            [self layoutAlertControllerViewForAnimationTypeWithHV:@"H"
                                                   equalAttribute:NSLayoutAttributeTop
                                                notEqualAttribute:NSLayoutAttributeBottom
                                            lessOrGreaterRelation:NSLayoutRelationLessThanOrEqual];
            break;
        case YYUIAlertAnimationTypeFromLeft:
            [self layoutAlertControllerViewForAnimationTypeWithHV:@"V"
                                                   equalAttribute:NSLayoutAttributeLeft
                                                notEqualAttribute:NSLayoutAttributeRight
                                            lessOrGreaterRelation:NSLayoutRelationLessThanOrEqual];
            break;
        case YYUIAlertAnimationTypeFromRight:
            [self layoutAlertControllerViewForAnimationTypeWithHV:@"V"
                                                   equalAttribute:NSLayoutAttributeRight
                                                notEqualAttribute:NSLayoutAttributeLeft
                                            lessOrGreaterRelation:NSLayoutRelationLessThanOrEqual];
            break;
    }
}

- (void)layoutAlertControllerViewForAnimationTypeWithHV:(NSString *)hv
                                             equalAttribute:(NSLayoutAttribute)equalAttribute
                                      notEqualAttribute:(NSLayoutAttribute)notEqualAttribute
                                               lessOrGreaterRelation:(NSLayoutRelation)relation {
    UIView *alertControllerView = self.alertControllerView;
    NSMutableArray *alertControllerViewConstraints = [NSMutableArray array];
    if (!self.customAlertView) {
        [alertControllerViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"%@:|-0-[alertControllerView]-0-|",hv] options:0 metrics:nil views:NSDictionaryOfVariableBindings(alertControllerView)]];
    } else {
        NSLayoutAttribute centerXorY = [hv isEqualToString:@"H"] ? NSLayoutAttributeCenterX : NSLayoutAttributeCenterY;
        [alertControllerViewConstraints addObject:[NSLayoutConstraint constraintWithItem:alertControllerView attribute:centerXorY relatedBy:NSLayoutRelationEqual toItem:alertControllerView.superview attribute:centerXorY multiplier:1.0 constant:0]];
        if (_customViewSize.width) { // 如果宽度没有值，则会假定customAlertViewh水平方向能由子控件撑起
            CGFloat alertControllerViewWidth = 0.0;
            if ([hv isEqualToString:@"H"]) {
                alertControllerViewWidth = MIN(_customViewSize.width, kScreenWidth);
            } else {
                alertControllerViewWidth = MIN(_customViewSize.width, kScreenWidth-_minDistanceToEdges);
            }
            [alertControllerViewConstraints addObject:[NSLayoutConstraint constraintWithItem:alertControllerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:alertControllerViewWidth]];
        }
        if (_customViewSize.height) { // 如果高度没有值，则会假定customAlertViewh垂直方向能由子控件撑起
            CGFloat alertControllerViewHeight = 0.0;
            if ([hv isEqualToString:@"H"]) {
                alertControllerViewHeight = MIN(_customViewSize.height, kScreenHeight-_minDistanceToEdges);
            } else {
                alertControllerViewHeight = MIN(_customViewSize.height, kScreenHeight);
            }
            [alertControllerViewConstraints addObject:[NSLayoutConstraint constraintWithItem:alertControllerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:alertControllerViewHeight]];
        }
    }
    [alertControllerViewConstraints addObject:[NSLayoutConstraint constraintWithItem:alertControllerView attribute:equalAttribute relatedBy:NSLayoutRelationEqual toItem:alertControllerView.superview attribute:equalAttribute multiplier:1.0 constant:0]];
    NSLayoutConstraint *someSideConstraint = [NSLayoutConstraint constraintWithItem:alertControllerView attribute:notEqualAttribute relatedBy:relation toItem:alertControllerView.superview attribute:notEqualAttribute multiplier:1.0 constant:_minDistanceToEdges];
    someSideConstraint.priority = 999.0;
    [alertControllerViewConstraints addObject:someSideConstraint];
    [NSLayoutConstraint activateConstraints:alertControllerViewConstraints];
    self.alertControllerViewConstraints = alertControllerViewConstraints;
}

- (void)layoutChildViews {
    // 对头部布局
    [self layoutHeaderView];
    
    // 对头部和action部分之间的分割线布局
    [self layoutHeaderActionLine];
    
    // 对组件view布局
    [self layoutComponentView];

    // 对组件view与action部分之间的分割线布局
    [self layoutComponentActionLine];
    
    // 对action部分布局
    [self layoutActionSequenceView];
}

// 对头部布局，高度由子控件撑起
- (void)layoutHeaderView {
    UIView *headerView = self.customHeaderView ? self.customHeaderView : self.headerView;
    if (!headerView.superview) return;
    UIView *alertView = self.alertView;
    NSMutableArray *headerViewConstraints = [NSMutableArray array];
    if (self.headerViewConstraints) {
        [NSLayoutConstraint deactivateConstraints:self.headerViewConstraints];
        self.headerViewConstraints = nil;
    }
    if (!self.customHeaderView) {
        [headerViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[headerView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(headerView)]];
    } else {
        if (_customViewSize.width) {
            CGFloat maxWidth = [self maxWidth];
            CGFloat headerViewWidth = MIN(maxWidth, _customViewSize.width);
            [headerViewConstraints addObject:[NSLayoutConstraint constraintWithItem:headerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:headerViewWidth]];
        }
        if (_customViewSize.height) {
            NSLayoutConstraint *customHeightConstraint = [NSLayoutConstraint constraintWithItem:headerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_customViewSize.height];
            customHeightConstraint.priority = UILayoutPriorityDefaultHigh;
            [headerViewConstraints addObject:customHeightConstraint];
        }
        [headerViewConstraints addObject:[NSLayoutConstraint constraintWithItem:headerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:alertView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    }
    [headerViewConstraints addObject:[NSLayoutConstraint constraintWithItem:headerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:alertView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    if (!self.headerActionLine.superview) {
        [headerViewConstraints addObject:[NSLayoutConstraint constraintWithItem:headerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:alertView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    }
    [NSLayoutConstraint activateConstraints:headerViewConstraints];
    self.headerViewConstraints = headerViewConstraints;
}

// 对头部和action部分之间的分割线布局
- (void)layoutHeaderActionLine {
    if (!self.headerActionLine.superview) return;
    UIView *headerActionLine = self.headerActionLine;
    UIView *headerView = self.customHeaderView ? self.customHeaderView : self.headerView;
    UIView *actionSequenceView = self.customActionSequenceView ? self.customActionSequenceView : self.actionSequenceView;
    NSMutableArray *headerActionLineConstraints = [NSMutableArray array];
    if (self.headerActionLineConstraints) {
        [NSLayoutConstraint deactivateConstraints:self.headerActionLineConstraints];
        self.headerActionLineConstraints = nil;
    }
    [headerActionLineConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[headerActionLine]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(headerActionLine)]];
    [headerActionLineConstraints addObject:[NSLayoutConstraint constraintWithItem:headerActionLine attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    if (!self.componentView.superview) {
        [headerActionLineConstraints addObject:[NSLayoutConstraint constraintWithItem:headerActionLine attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:actionSequenceView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    }
    [headerActionLineConstraints addObject:[NSLayoutConstraint constraintWithItem:headerActionLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:CGFloatToPixel(1.0)]];

    [NSLayoutConstraint activateConstraints:headerActionLineConstraints];
    self.headerActionLineConstraints = headerActionLineConstraints;
}

// 对组件view布局
- (void)layoutComponentView {
    if (!self.componentView.superview) return;
    UIView *componentView = self.componentView;
    UIView *headerActionLine = self.headerActionLine;
    UIView *componentActionLine = self.componentActionLine;
    NSMutableArray *componentViewConstraints = [NSMutableArray array];
    if (self.componentViewConstraints) {
        [NSLayoutConstraint deactivateConstraints:self.componentViewConstraints];
        self.componentViewConstraints = nil;
    }
    [componentViewConstraints addObject:[NSLayoutConstraint constraintWithItem:componentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:headerActionLine attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [componentViewConstraints addObject:[NSLayoutConstraint constraintWithItem:componentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:componentActionLine attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [componentViewConstraints addObject:[NSLayoutConstraint constraintWithItem:componentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.alertView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    if (_customViewSize.height) {
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:componentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_customViewSize.height];
        heightConstraint.priority = UILayoutPriorityDefaultHigh; // 750
        [componentViewConstraints addObject:heightConstraint];
    }
    if (_customViewSize.width) {
        CGFloat maxWidth = [self maxWidth];
        CGFloat componentViewWidth = MIN(maxWidth, _customViewSize.width);
        [componentViewConstraints addObject:[NSLayoutConstraint constraintWithItem:componentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:componentViewWidth]];
    }
    [NSLayoutConstraint activateConstraints:componentViewConstraints];
    self.componentViewConstraints = componentViewConstraints;
}

// 对组件view和action部分之间的分割线布局
- (void)layoutComponentActionLine {
    if (!self.componentActionLine.superview) return;
    UIView *componentActionLine = self.componentActionLine;
    NSMutableArray *componentActionLineConstraints = [NSMutableArray array];
    if (self.componentActionLineConstraints) {
        [NSLayoutConstraint deactivateConstraints:self.componentActionLineConstraints];
        self.componentActionLineConstraints = nil;
    }
    [componentActionLineConstraints addObject:[NSLayoutConstraint constraintWithItem:componentActionLine attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.actionSequenceView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [componentActionLineConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[componentActionLine]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(componentActionLine)]];
    [componentActionLineConstraints addObject:[NSLayoutConstraint constraintWithItem:componentActionLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:CGFloatToPixel(1.0)]];
    [NSLayoutConstraint activateConstraints:componentActionLineConstraints];
    self.componentActionLineConstraints = componentActionLineConstraints;
}

// 对action部分布局，高度由子控件撑起
- (void)layoutActionSequenceView {
    UIView *actionSequenceView = self.customActionSequenceView ? self.customActionSequenceView : self.actionSequenceView;
    if (!actionSequenceView.superview) return;
    UIView *alertView = self.alertView;
    UIView *headerActionLine = self.headerActionLine;

    NSMutableArray *actionSequenceViewConstraints = [NSMutableArray array];
    if (self.actionSequenceViewConstraints) {
        [NSLayoutConstraint deactivateConstraints:self.actionSequenceViewConstraints];
        self.actionSequenceViewConstraints = nil;
    }
    if (!self.customActionSequenceView) {
        [actionSequenceViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[actionSequenceView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(actionSequenceView)]];
    } else {

        if (_customViewSize.width) {
            CGFloat maxWidth = [self maxWidth];
            if (_customViewSize.width > maxWidth) _customViewSize.width = maxWidth;
            [actionSequenceViewConstraints addObject:[NSLayoutConstraint constraintWithItem:actionSequenceView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_customViewSize.width]];
        }
        if (_customViewSize.height) {
            NSLayoutConstraint *customHeightConstraint = [NSLayoutConstraint constraintWithItem:actionSequenceView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_customViewSize.height];
            customHeightConstraint.priority = UILayoutPriorityDefaultHigh;
            [actionSequenceViewConstraints addObject:customHeightConstraint];
        }
        [actionSequenceViewConstraints addObject:[NSLayoutConstraint constraintWithItem:actionSequenceView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:alertView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    }
    if (!headerActionLine) {
        [actionSequenceViewConstraints addObject:[NSLayoutConstraint constraintWithItem:actionSequenceView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:alertView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    }
    [actionSequenceViewConstraints addObject:[NSLayoutConstraint constraintWithItem:actionSequenceView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:alertView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];

    [NSLayoutConstraint activateConstraints:actionSequenceViewConstraints];
    self.actionSequenceViewConstraints = actionSequenceViewConstraints;
}

- (CGFloat)maxWidth {
    if (self.preferredStyle == YYUIAlertControllerStyleAlert) {
        return MIN(kScreenWidth, kScreenHeight)-_minDistanceToEdges * 2;
    } else {
        return kScreenWidth;
    }
}

// 文字显示不全处理
- (void)handleIncompleteTextDisplay {
    // alert样式下水平排列时如果文字显示不全则垂直排列
    if (!self.isForceLayout) { // 外界没有设置排列方式
        if (self.preferredStyle == YYUIAlertControllerStyleAlert) {
            for (YYUIAlertAction *action in self.actions) {
                // 预估按钮宽度
                CGFloat preButtonWidth = (MIN(kScreenWidth, kScreenHeight) - _minDistanceToEdges * 2 - CGFloatToPixel(1.0) * (self.actions.count - 1)) / self.actions.count - action.titleEdgeInsets.left - action.titleEdgeInsets.right;
                // 如果action的标题文字总宽度，大于按钮的contentRect的宽度，则说明水平排列会导致文字显示不全，此时垂直排列
                if (action.attributedTitle) {
                    if (ceil([action.attributedTitle boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.actionsHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.width) > preButtonWidth) {
                        _actionAxis = UILayoutConstraintAxisVertical;
                        [self updateActionAxis];
                        [self.actionSequenceView setNeedsUpdateConstraints];
                        break; // 一定要break，只要有一个按钮文字过长就垂直排列
                    }
                } else {
                    if (ceil([action.title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.actionsHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:action.font} context:nil].size.width) > preButtonWidth) {
                        _actionAxis = UILayoutConstraintAxisVertical;
                        [self updateActionAxis];
                        [self.actionSequenceView setNeedsUpdateConstraints];
                        break;
                    }
                }
            }
        }
    }
}

// 专门处理第三方IQKeyboardManager,非自定义view时禁用IQKeyboardManager移动textView/textField效果，自定义view时取消禁用
- (void)handleIQKeyboardManager {
    SEL selector = NSSelectorFromString(@"sharedManager");
    IMP imp = [NSClassFromString(@"IQKeyboardManager") methodForSelector:selector];
    if (imp != NULL) {
        NSObject *(*func)(id, SEL) = (void *)imp;
        NSObject *mgr = func(NSClassFromString(@"IQKeyboardManager"), selector);
        if ([mgr isKindOfClass:NSClassFromString(@"IQKeyboardManager")]) {
            @try {
                NSMutableSet *disabledDistanceHandlingClasses = [mgr valueForKey:@"_disabledDistanceHandlingClasses"];
                NSMutableSet *disabledToolbarClasses = [mgr valueForKey:@"_disabledToolbarClasses"];
                if (![disabledDistanceHandlingClasses containsObject:NSClassFromString(@"YYUIAlertController")]) {
                    [disabledDistanceHandlingClasses addObject:NSClassFromString(@"YYUIAlertController")];
                    [disabledToolbarClasses addObject:NSClassFromString(@"YYUIAlertController")];
                }
            } @catch (NSException *exception) {
                NSLog(@"exception = %@",exception);
            } @finally {
                
            }
        }
    }
}

- (void)configureHeaderView {
    if (self.image) {
        self.headerView.imageLimitSize = _imageLimitSize;
        self.headerView.imageView.image = _image;
        self.headerView.imageView.tintColor = _imageTintColor;
        [self.headerView setNeedsUpdateConstraints];
    }
    if(self.attributedTitle.length) {
        self.headerView.titleLabel.attributedText = self.attributedTitle;
        [self setupPreferredMaxLayoutWidthForLabel:self.headerView.titleLabel];
    } else if(self.title.length) {
        self.headerView.titleLabel.text = _title;
        self.headerView.titleLabel.font = _titleFont;
        self.headerView.titleLabel.textColor = _titleTextColor;
        self.headerView.titleLabel.textAlignment = _titleTextAlignment;
        [self setupPreferredMaxLayoutWidthForLabel:self.headerView.titleLabel];
    }
    if (self.attributedMessage.length) {
        self.headerView.messageLabel.attributedText = self.attributedMessage;
        [self setupPreferredMaxLayoutWidthForLabel:self.headerView.messageLabel];
    } else if (self.message.length) {
        self.headerView.messageLabel.text = _message;
        self.headerView.messageLabel.font = _messageFont;
        self.headerView.messageLabel.textColor = _messageTextColor;
        self.headerView.messageLabel.textAlignment = _messageTextAlignment;
        [self setupPreferredMaxLayoutWidthForLabel:self.headerView.messageLabel];
    }
}

- (void)setupPreferredMaxLayoutWidthForLabel:(UILabel *)textLabel {
    if (self.preferredStyle == YYUIAlertControllerStyleAlert) {
        textLabel.preferredMaxLayoutWidth = MIN(kScreenWidth, kScreenHeight) - self.minDistanceToEdges * 2 - self.headerView.contentEdgeInsets.left - self.headerView.contentEdgeInsets.right;
    } else {
        textLabel.preferredMaxLayoutWidth  = kScreenWidth - self.headerView.contentEdgeInsets.left - self.headerView.contentEdgeInsets.right;
    }
}

// 这个方法是实现点击回车切换到下一个textField，如果没有下一个，会自动退出键盘. 不能在代理方法里实现，因为如果设置了代理，外界就不能成为textFiled的代理了，通知也监听不到回车
- (void)textFieldDidEndOnExit:(UITextField *)textField {
    NSInteger index = [self.textFields indexOfObject:textField];
    if (self.textFields.count > index + 1) {
        UITextField *nextTextField = [self.textFields objectAtIndex:index + 1];
        [textField resignFirstResponder];
        [nextTextField becomeFirstResponder];
    }
}

// 更新action的排列方式
- (void)updateActionAxis {
    self.actionSequenceView.axis = _actionAxis;
    if (_actionAxis == UILayoutConstraintAxisVertical) {
        self.actionSequenceView.stackViewDistribution = UIStackViewDistributionFillProportionally;// 布局方式为子控件自适应内容高度
    } else {
        self.actionSequenceView.stackViewDistribution = UIStackViewDistributionFillEqually; // 布局方式为子控件等宽
    }
}

- (void)makeViewOffsetWithAnimated:(BOOL)animated {
    if (!self.beingPresented && !self.beingDismissed) {
        [self layoutAlertControllerView];
        if (animated) {
            [UIView animateWithDuration:0.25 animations:^{
                [self.view.superview layoutIfNeeded];
            }];
        }
    }
}

// 获取自定义view的大小
- (CGSize)sizeForCustomView:(UIView *)customView {
    [customView layoutIfNeeded];
    CGSize settingSize = customView.frame.size;
    CGSize fittingSize = [customView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return CGSizeMake(MAX(settingSize.width, fittingSize.width), MAX(settingSize.height, fittingSize.height));
}

#pragma mark - system methods

- (void)loadView {
    // 重新创建self.view，这样可以采用自己的一套布局，轻松改变控制器view的大小
    self.view = self.alertControllerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureHeaderView];
        
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self handleIQKeyboardManager];
    
    if (!_isForceOffset && !_customAlertView && !_customHeaderView && !_customActionSequenceView && !_componentView) {
        // 监听键盘改变frame，键盘frame改变需要移动对话框
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    if (self.textFields.count) {
        UITextField *firstTextfield = [self.textFields firstObject];
        if (!firstTextfield.isFirstResponder) {
            [firstTextfield becomeFirstResponder];
        }
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    // 屏幕旋转后宽高发生了交换，头部的label最大宽度需要重新计算
    [self setupPreferredMaxLayoutWidthForLabel:self.headerView.titleLabel];
    [self setupPreferredMaxLayoutWidthForLabel:self.headerView.messageLabel];
    // 对自己创建的alertControllerView布局，在这个方法里，self.view才有父视图，有父视图才能改变其约束
    [self layoutAlertControllerView];
    [self layoutChildViews];
    
    if (self.preferredStyle == YYUIAlertControllerStyleActionSheet) {
        [self setCornerRadius:_cornerRadius];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self handleIncompleteTextDisplay];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 键盘通知

- (void)keyboardFrameWillChange:(NSNotification *)notification {
    if (!_isForceOffset && (_offsetForAlert.y == 0.0 || _textFields.lastObject.isFirstResponder)) {
        CGRect keyboardEndFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardEndY = keyboardEndFrame.origin.y;
        CGFloat diff = fabs((kScreenHeight - keyboardEndY) * 0.5);
        _offsetForAlert.y = -diff;
        [self makeViewOffsetWithAnimated:YES];
    }
}

#pragma mark - setterx



#pragma mark - lazy load

- (UIView *)alertControllerView {
    if (!_alertControllerView) {
        UIView *alertControllerView = [[UIView alloc] init];
        alertControllerView.translatesAutoresizingMaskIntoConstraints = NO;
        _alertControllerView = alertControllerView;
    }
    return _alertControllerView;
}

- (UIView *)containerView {
    if (!_containerView) {
        UIView *containerView = [[UIView alloc] init];
        containerView.frame = self.alertControllerView.bounds;
        containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        if (_preferredStyle == YYUIAlertControllerStyleAlert) {
            containerView.layer.cornerRadius = _cornerRadius;
            containerView.layer.masksToBounds = YES;
        } else {
            if (_cornerRadius > 0.0) {
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                containerView.layer.mask = maskLayer;
            }
        }
        [self.alertControllerView addSubview:containerView];
        
        _containerView = containerView;
    }
    return _containerView;
}

- (UIView *)alertView {
    if (!_alertView) {
        UIView *alertView = [[UIView alloc] init];
        alertView.frame = self.alertControllerView.bounds;
        alertView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        if (!self.customAlertView) {
            [self.containerView addSubview:alertView];
        }
        _alertView = alertView;
    }
    return _alertView;
}

- (UIView *)customAlertView {
    // customAlertView有值但是没有父view
    if (_customAlertView && !_customAlertView.superview) {
        if (CGSizeEqualToSize(_customViewSize, CGSizeZero)) {
            // 获取_customAlertView的大小
            _customViewSize = [self sizeForCustomView:_customAlertView];
        }
        // 必须在在下面2行代码之前获取_customViewSize
        _customAlertView.frame = self.alertControllerView.bounds;
        _customAlertView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.containerView addSubview:_customAlertView];
    }
    return _customAlertView;
}

- (YYUIAlertControllerHeaderScrollView *)headerView {
    if (!_headerView) {
        YYUIAlertControllerHeaderScrollView *headerView = [[YYUIAlertControllerHeaderScrollView alloc] init];
        headerView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        headerView.translatesAutoresizingMaskIntoConstraints = NO;
        __weak typeof(self) weakSelf = self;
        headerView.headerViewSafeAreaDidChangeBlock = ^{
            [weakSelf setupPreferredMaxLayoutWidthForLabel:weakSelf.headerView.titleLabel];
            [weakSelf setupPreferredMaxLayoutWidthForLabel:weakSelf.headerView.messageLabel];
        };
        if (!self.customHeaderView) {
            if ((self.title.length || self.attributedTitle.length || self.message.length || self.attributedMessage.length || self.textFields.count || self.image)) {
                [self.alertView addSubview:headerView];
            }
        }
        _headerView = headerView;
    }
    return _headerView;
}

- (UIView *)customHeaderView {
    // _customHeaderView有值但是没有父view
    if (_customHeaderView && !_customHeaderView.superview) {
        // 获取_customHeaderView的大小
        if (CGSizeEqualToSize(_customViewSize, CGSizeZero)) {
            // 获取_customHeaderView的大小
            _customViewSize = [self sizeForCustomView:_customHeaderView];
        }
        _customHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.alertView addSubview:_customHeaderView];
    }
    return _customHeaderView;
}

- (YYUIAlertControllerActionSequenceView *)actionSequenceView {
    if (!_actionSequenceView) {
        YYUIAlertControllerActionSequenceView *actionSequenceView = [[YYUIAlertControllerActionSequenceView alloc] init];
        actionSequenceView.translatesAutoresizingMaskIntoConstraints = NO;
        __weak typeof(self) weakSelf = self;
        actionSequenceView.buttonClickedInActionViewBlock = ^(NSInteger index) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            YYUIAlertAction *action = weakSelf.actions[index];
            if (action.handler) {
                action.handler(action);
            }
        };
        if (self.actions.count && !self.customActionSequenceView) {
            [self.alertView addSubview:actionSequenceView];
        }
        _actionSequenceView = actionSequenceView;
    }
    return _actionSequenceView;
}

- (UIView *)customActionSequenceView {
    // _customActionSequenceView有值但是没有父view
    if (_customActionSequenceView && !_customActionSequenceView.superview) {
        // 获取_customHeaderView的大小
        if (CGSizeEqualToSize(_customViewSize, CGSizeZero)) {
            // 获取_customActionSequenceView的大小
            _customViewSize = [self sizeForCustomView:_customActionSequenceView];
        }
        _customActionSequenceView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.alertView addSubview:_customActionSequenceView];
    }
    return _customActionSequenceView;
}

- (YYUIAlertControllerActionItemSeparatorView *)headerActionLine {
    if (!_headerActionLine) {
        YYUIAlertControllerActionItemSeparatorView *headerActionLine = [[YYUIAlertControllerActionItemSeparatorView alloc] init];
        headerActionLine.translatesAutoresizingMaskIntoConstraints = NO;
        if ((self.headerView.superview || self.customHeaderView.superview) && (self.actionSequenceView.superview || self.customActionSequenceView.superview)) {
            [self.alertView addSubview:headerActionLine];
        }
        _headerActionLine = headerActionLine;
    }
    return _headerActionLine;
}

- (UIView *)componentView {
    if (_componentView && !_componentView.superview) {
        NSAssert(self.headerActionLine.superview, @"Due to the -componentView is added between the -head and the -action section, the -head and -action must exist together");
        // 获取_componentView的大小
        if (CGSizeEqualToSize(_customViewSize, CGSizeZero)) {
            // 获取_componentView的大小
            _customViewSize = [self sizeForCustomView:_componentView];
        }
        _componentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.alertView addSubview:_componentView];
    }
    return _componentView;
}

- (YYUIAlertControllerActionItemSeparatorView *)componentActionLine {
    if (!_componentActionLine) {
        YYUIAlertControllerActionItemSeparatorView *componentActionLine = [[YYUIAlertControllerActionItemSeparatorView alloc] init];
        componentActionLine.translatesAutoresizingMaskIntoConstraints = NO;
        // 必须组件view和action部分同时存在
        if (self.componentView.superview && (self.actionSequenceView.superview || self.customActionSequenceView.superview)) {
            [self.alertView addSubview:componentActionLine];
        }
        _componentActionLine = componentActionLine;
    }
    return _componentActionLine;
}

- (NSArray<YYUIAlertAction *> *)actions {
    if (!_actions) {
        _actions = [NSArray array];
    }
    return _actions;
}

- (NSArray<UITextField *> *)textFields {
    if (!_textFields) {
        _textFields = [NSArray array];
    }
    return _textFields;
}

- (NSMutableArray *)otherActions {
    if (!_otherActions) {
        _otherActions = [[NSMutableArray alloc] init];
    }
    return _otherActions;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [YYUIAlertTransitionController animationIsPresenting:YES];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    [self.view endEditing:YES];
    return [YYUIAlertTransitionController animationIsPresenting:NO];
}

- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source NS_AVAILABLE_IOS(8_0) {
    return [[YYUIAlertPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

@end


#pragma mark - YYUIOverlayView

@interface YYUIOverlayView: UIView
@property (nonatomic, strong) UIView *presentedView;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@end

@implementation YYUIOverlayView

- (void)setAppearanceStyle:(UIBlurEffect *)blur color:(UIColor *)color alpha:(CGFloat)alpha {
    if (blur) {
        [self createVisualEffectViewWithBlur:blur alpha:alpha];
        return;
    }
    else {
        [self.effectView removeFromSuperview];
        self.effectView = nil;
        if (alpha < 0) {
            alpha = 0.5;
        }
        self.backgroundColor = color ?: [UIColor colorWithWhite:0 alpha:alpha];
        self.alpha = 0;
    }
}

- (void)createVisualEffectViewWithBlur:(UIBlurEffect *)blur alpha:(CGFloat)alpha {
    self.backgroundColor = [UIColor clearColor];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = self.bounds;
    effectView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    effectView.userInteractionEnabled = NO;
    effectView.alpha = alpha;
    [self addSubview:effectView];
    _effectView = effectView;
}

@end


#pragma mark - YYUIAlertPresentationController

@interface YYUIAlertPresentationController ()
@property (nonatomic, strong) YYUIOverlayView *overlayView;
@end

@implementation YYUIAlertPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    if (self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController]) {
    }
    return self;
}

- (void)containerViewWillLayoutSubviews {
    [super containerViewWillLayoutSubviews];
    self.overlayView.frame = self.containerView.bounds;
}

- (void)presentationTransitionWillBegin {
    [super presentationTransitionWillBegin];
    
    YYUIAlertController *alertController = (YYUIAlertController *)self.presentedViewController;
    
    [self.overlayView setAppearanceStyle:alertController.coverBlurEffect color:alertController.coverColor alpha:alertController.coverAlpha];
    
    // 遮罩的alpha值从0～1变化，UIViewControllerTransitionCoordinator协是一个过渡协调器，当执行模态过渡或push过渡时，可以对视图中的其他部分做动画
    id <UIViewControllerTransitionCoordinator> coordinator = [self.presentedViewController transitionCoordinator];
    if (coordinator) {
        [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            self.overlayView.alpha = 1.0;
        } completion:nil];
    } else {
        self.overlayView.alpha = 1.0;
    }
    if ([alertController.delegate respondsToSelector:@selector(willPresentAlertController:)]) {
        [alertController.delegate willPresentAlertController:alertController];
    }
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    [super presentationTransitionDidEnd:completed];
    
    YYUIAlertController *alertController = (YYUIAlertController *)self.presentedViewController;
    if ([alertController.delegate respondsToSelector:@selector(didPresentAlertController:)]) {
        [alertController.delegate didPresentAlertController:alertController];
    }
}

- (void)dismissalTransitionWillBegin {
    [super dismissalTransitionWillBegin];
    // 遮罩的alpha值从1～0变化，UIViewControllerTransitionCoordinator协议执行动画可以保证和转场动画同步
    id <UIViewControllerTransitionCoordinator> coordinator = [self.presentedViewController transitionCoordinator];
    if (coordinator) {
        [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            self.overlayView.alpha = 0.0;
        } completion:nil];
    } else {
        self.overlayView.alpha = 0.0;
    }
    YYUIAlertController *alertController = (YYUIAlertController *)self.presentedViewController;
    if ([alertController.delegate respondsToSelector:@selector(willDismissAlertController:)]) {
        [alertController.delegate willDismissAlertController:alertController];
    }
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    [super dismissalTransitionDidEnd:completed];
    if (completed) {
        [_overlayView removeFromSuperview];
        _overlayView = nil;
    }
    YYUIAlertController *alertController = (YYUIAlertController *)self.presentedViewController;
    if ([alertController.delegate respondsToSelector:@selector(didDismissAlertController:)]) {
        [alertController.delegate didDismissAlertController:alertController];
    }
}

- (CGRect)frameOfPresentedViewInContainerView{
    return self.presentedView.frame;
}

- (void)tapOverlayView {
    YYUIAlertController *alertController = (YYUIAlertController *)self.presentedViewController;
    if (alertController.dismissOnTouchBackground) {
        [alertController dismissViewControllerAnimated:YES completion:^{}];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (YYUIOverlayView *)overlayView {
    if (!_overlayView) {
        _overlayView = [[YYUIOverlayView alloc] init];
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOverlayView)];
        [_overlayView addGestureRecognizer:tap];
        [self.containerView addSubview:_overlayView];
    }
    return _overlayView;
}

@end


#pragma mark - YYUIAlertTransitionController

@interface YYUIAlertTransitionController ()

@property (nonatomic, assign) BOOL presenting;

@end

@implementation YYUIAlertTransitionController

+ (instancetype)animationIsPresenting:(BOOL)isPresenting {
    return [[self alloc] initWithPresenting:isPresenting];
}

- (instancetype)initWithPresenting:(BOOL)isPresenting {
    if (self = [super init]) {
        self.presenting = isPresenting;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.27f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (self.presenting) {
        [self presentAnimationTransition:transitionContext];
    } else {
        [self dismissAnimationTransition:transitionContext];
    }
}

- (void)presentAnimationTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    YYUIAlertController *alertController = (YYUIAlertController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    switch (alertController.animationType) {
        case YYUIAlertAnimationTypeFromBottom:
            [self raiseUpWhenPresentForController:alertController transition:transitionContext];
            break;
        case YYUIAlertAnimationTypeFromRight:
            [self fromRightWhenPresentForController:alertController transition:transitionContext];
            break;
        case YYUIAlertAnimationTypeFromTop:
            [self dropDownWhenPresentForController:alertController transition:transitionContext];
            break;
        case YYUIAlertAnimationTypeFromLeft:
            [self fromLeftWhenPresentForController:alertController transition:transitionContext];
            break;
        case YYUIAlertAnimationTypeFade:
            [self alphaWhenPresentForController:alertController transition:transitionContext];
            break;
        case YYUIAlertAnimationTypeExpand:
            [self expandWhenPresentForController:alertController transition:transitionContext];
            break;
        case YYUIAlertAnimationTypeShrink:
            [self shrinkWhenPresentForController:alertController transition:transitionContext];
            break;
        case YYUIAlertAnimationTypeNone:
            [self noneWhenPresentForController:alertController transition:transitionContext];
            break;
        default:
            break;
    }
}

- (void)dismissAnimationTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    YYUIAlertController *alertController = (YYUIAlertController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if ([alertController isKindOfClass:[YYUIAlertController class]]) {
        switch (alertController.animationType) {
            case YYUIAlertAnimationTypeFromBottom:
                [self dismissCorrespondingRaiseUpForController:alertController transition:transitionContext];
                break;
            case YYUIAlertAnimationTypeFromRight:
                [self dismissCorrespondingFromRightForController:alertController transition:transitionContext];
                break;
            case YYUIAlertAnimationTypeFromLeft:
                [self dismissCorrespondingFromLeftForController:alertController transition:transitionContext];
                break;
            case YYUIAlertAnimationTypeFromTop:
                [self dismissCorrespondingDropDownForController:alertController transition:transitionContext];
                break;
            case YYUIAlertAnimationTypeFade:
                [self dismissCorrespondingAlphaForController:alertController transition:transitionContext];
                break;
            case YYUIAlertAnimationTypeExpand:
                [self dismissCorrespondingExpandForController:alertController transition:transitionContext];
                break;
            case YYUIAlertAnimationTypeShrink:
                [self dismissCorrespondingShrinkForController:alertController transition:transitionContext];
                break;
            case YYUIAlertAnimationTypeNone:
                [self dismissCorrespondingNoneForController:alertController transition:transitionContext];
                break;
            default:
                break;
        }
    }
}

// 从底部弹出的present动画
- (void)raiseUpWhenPresentForController:(YYUIAlertController *)alertController transition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    // 将alertController的view添加到containerView上
    [containerView addSubview:alertController.view];
    // 标记需要刷新布局
    [containerView setNeedsLayout];
    // 在有标记刷新布局的情况下立即布局，这行代码很重要，第一：立即布局会立即调用YYUIAlertController的viewWillLayoutSubviews的方法，第二：立即布局后可以获取到alertController.view的frame
    [containerView layoutIfNeeded];
    
    // 这3行代码不能放在[containerView layoutIfNeeded]之前，如果放在之前，[containerView layoutIfNeeded]强制布局后会将以下设置的frame覆盖
    CGRect controlViewFrame = alertController.view.frame;
    controlViewFrame.origin.y = kScreenHeight;
    alertController.view.frame = controlViewFrame;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect controlViewFrame = alertController.view.frame;
        if (alertController.preferredStyle == YYUIAlertControllerStyleActionSheet) {
            controlViewFrame.origin.y = kScreenHeight-controlViewFrame.size.height;
        } else {
            controlViewFrame.origin.y = (kScreenHeight-controlViewFrame.size.height) / 2.0;
            [self offSetCenter:alertController];
        }
        alertController.view.frame = controlViewFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
        [alertController layoutAlertControllerView];
    }];
}

// 从底部弹出对应的dismiss动画
- (void)dismissCorrespondingRaiseUpForController:(YYUIAlertController *)alertController transition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        CGRect controlViewFrame = alertController.view.frame;
        controlViewFrame.origin.y = kScreenHeight;
        alertController.view.frame = controlViewFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
}

// 从右边弹出的present动画
- (void)fromRightWhenPresentForController:(YYUIAlertController *)alertController transition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *containerView = [transitionContext containerView];
    // 将alertController的view添加到containerView上
    [containerView addSubview:alertController.view];
    // 标记需要刷新布局
    [containerView setNeedsLayout];
    // 在有标记刷新布局的情况下立即布局，这行代码很重要，第一：立即布局会立即调用YYUIAlertController的viewWillLayoutSubviews的方法，第二：立即布局后可以获取到alertController.view的frame
    [containerView layoutIfNeeded];
    
    // 这3行代码不能放在[containerView layoutIfNeeded]之前，如果放在之前，[containerView layoutIfNeeded]强制布局后会将以下设置的frame覆盖
    CGRect controlViewFrame = alertController.view.frame;
    controlViewFrame.origin.x = kScreenWidth;
    alertController.view.frame = controlViewFrame;
    
    if (alertController.preferredStyle == YYUIAlertControllerStyleAlert) {
        [self offSetCenter:alertController];
    }
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect controlViewFrame = alertController.view.frame;
        if (alertController.preferredStyle == YYUIAlertControllerStyleActionSheet) {
            controlViewFrame.origin.x = kScreenWidth-controlViewFrame.size.width;
        } else {
            controlViewFrame.origin.x = (kScreenWidth-controlViewFrame.size.width) / 2.0;
        }
        alertController.view.frame = controlViewFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
        [alertController layoutAlertControllerView];
    }];
}

// 从右边弹出对应的dismiss动画
- (void)dismissCorrespondingFromRightForController:(YYUIAlertController *)alertController transition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        CGRect controlViewFrame = alertController.view.frame;
        controlViewFrame.origin.x = kScreenWidth;
        alertController.view.frame = controlViewFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
}

// 从左边弹出的present动画
- (void)fromLeftWhenPresentForController:(YYUIAlertController *)alertController transition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *containerView = [transitionContext containerView];
    // 将alertController的view添加到containerView上
    [containerView addSubview:alertController.view];
    // 标记需要刷新布局
    [containerView setNeedsLayout];
    // 在有标记刷新布局的情况下立即布局，这行代码很重要，第一：立即布局会立即调用YYUIAlertController的viewWillLayoutSubviews的方法，第二：立即布局后可以获取到alertController.view的frame
    [containerView layoutIfNeeded];
    
    // 这3行代码不能放在[containerView layoutIfNeeded]之前，如果放在之前，[containerView layoutIfNeeded]强制布局后会将以下设置的frame覆盖
    CGRect controlViewFrame = alertController.view.frame;
    controlViewFrame.origin.x = -controlViewFrame.size.width;
    alertController.view.frame = controlViewFrame;
    
    if (alertController.preferredStyle == YYUIAlertControllerStyleAlert) {
        [self offSetCenter:alertController];
    }
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect controlViewFrame = alertController.view.frame;
        if (alertController.preferredStyle == YYUIAlertControllerStyleActionSheet) {
            controlViewFrame.origin.x = 0;
        } else {
            controlViewFrame.origin.x = (kScreenWidth-controlViewFrame.size.width) / 2.0;
        }
        alertController.view.frame = controlViewFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
        [alertController layoutAlertControllerView];
    }];
}

// 从左边弹出对应的dismiss动画
- (void)dismissCorrespondingFromLeftForController:(YYUIAlertController *)alertController transition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        CGRect controlViewFrame = alertController.view.frame;
        controlViewFrame.origin.x = -controlViewFrame.size.width;
        alertController.view.frame = controlViewFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
}

// 从顶部弹出的present动画
- (void)dropDownWhenPresentForController:(YYUIAlertController *)alertController transition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *containerView = [transitionContext containerView];
    // 将alertController的view添加到containerView上
    [containerView addSubview:alertController.view];
    // 标记需要刷新布局
    [containerView setNeedsLayout];
    // 在有标记刷新布局的情况下立即布局，这行代码很重要，第一：立即布局会立即调用YYUIAlertController的viewWillLayoutSubviews的方法，第二：立即布局后可以获取到alertController.view的frame
    [containerView layoutIfNeeded];
    
    // 这3行代码不能放在[containerView layoutIfNeeded]之前，如果放在之前，[containerView layoutIfNeeded]强制布局后会将以下设置的frame覆盖
    CGRect controlViewFrame = alertController.view.frame;
    controlViewFrame.origin.y = -controlViewFrame.size.height;
    alertController.view.frame = controlViewFrame;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect controlViewFrame = alertController.view.frame;
        if (alertController.preferredStyle == YYUIAlertControllerStyleActionSheet) {
            controlViewFrame.origin.y = 0;
        } else {
            controlViewFrame.origin.y = (kScreenHeight-controlViewFrame.size.height) / 2.0;
            [self offSetCenter:alertController];
        }
        alertController.view.frame = controlViewFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
        [alertController layoutAlertControllerView];
    }];
}

// 从顶部弹出对应的dismiss动画
- (void)dismissCorrespondingDropDownForController:(YYUIAlertController *)alertController transition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        CGRect controlViewFrame = alertController.view.frame;
        controlViewFrame.origin.y = -controlViewFrame.size.height;
        alertController.view.frame = controlViewFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
}

// alpha值从0到1变化的present动画
- (void)alphaWhenPresentForController:(YYUIAlertController *)alertController transition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:alertController.view];
    
    // 标记需要刷新布局
    [containerView setNeedsLayout];
    // 在有标记刷新布局的情况下立即布局，这行代码很重要，第一：立即布局会立即调用YYUIAlertController的viewWillLayoutSubviews的方法，第二：立即布局后可以获取到alertController.view的frame,不仅如此，走了viewWillLayoutSubviews键盘就会弹出，此后可以获取到alertController.offset
    [containerView layoutIfNeeded];
    
    alertController.view.alpha = 0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self offSetCenter:alertController];
        alertController.view.alpha = 1;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
        [alertController layoutAlertControllerView];
    }];
}

// alpha值从0到1变化对应的的dismiss动画
- (void)dismissCorrespondingAlphaForController:(YYUIAlertController *)alertController transition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        alertController.view.alpha = 0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
}

// 发散的prensent动画
- (void)expandWhenPresentForController:(YYUIAlertController *)alertController transition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:alertController.view];
    
    // 标记需要刷新布局
    [containerView setNeedsLayout];
    // 在有标记刷新布局的情况下立即布局，这行代码很重要，第一：立即布局会立即调用YYUIAlertController的viewWillLayoutSubviews的方法，第二：立即布局后可以获取到alertController.view的frame,不仅如此，走了viewWillLayoutSubviews键盘就会弹出，此后可以获取到alertController.offset
    [containerView layoutIfNeeded];
    
    alertController.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
    alertController.view.alpha = 0.0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self offSetCenter:alertController];
        alertController.view.transform = CGAffineTransformIdentity;
        alertController.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
        [alertController layoutAlertControllerView];
    }];
}

// 发散对应的dismiss动画
- (void)dismissCorrespondingExpandForController:(YYUIAlertController *)alertController transition:(id<UIViewControllerContextTransitioning>)transitionContext {
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        alertController.view.transform = CGAffineTransformIdentity;
        alertController.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
}

// 收缩的present动画
- (void)shrinkWhenPresentForController:(YYUIAlertController *)alertController transition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:alertController.view];
    
    // 标记需要刷新布局
    [containerView setNeedsLayout];
    // 在有标记刷新布局的情况下立即布局，这行代码很重要，第一：立即布局会立即调用YYUIAlertController的viewWillLayoutSubviews的方法，第二：立即布局后可以获取到alertController.view的frame,不仅如此，走了viewWillLayoutSubviews键盘就会弹出，此后可以获取到alertController.offset
    [containerView layoutIfNeeded];
    
    alertController.view.transform = CGAffineTransformMakeScale(1.1, 1.1);
    alertController.view.alpha = 0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self offSetCenter:alertController];
        alertController.view.transform = CGAffineTransformIdentity;
        alertController.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
        [alertController layoutAlertControllerView];
    }];
}

// 收缩对应的的dismiss动画
- (void)dismissCorrespondingShrinkForController:(YYUIAlertController *)alertController transition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // 与发散对应的dismiss动画相同
    [self dismissCorrespondingExpandForController:alertController transition:transitionContext];
}

// 无动画
- (void)noneWhenPresentForController:(YYUIAlertController *)alertController transition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:alertController.view];
    [transitionContext completeTransition:transitionContext.animated];
}

- (void)dismissCorrespondingNoneForController:(YYUIAlertController *)alertController transition:(id<UIViewControllerContextTransitioning>)transitionContext {
    [transitionContext completeTransition:transitionContext.animated];
}

- (void)offSetCenter:(YYUIAlertController *)alertController {
    if (!CGPointEqualToPoint(alertController.offsetForAlert, CGPointZero)) {
        CGPoint controlViewCenter = alertController.view.center;
        controlViewCenter.x = kScreenWidth / 2.0 + alertController.offsetForAlert.x;
        controlViewCenter.y = kScreenHeight / 2.0 + alertController.offsetForAlert.y;
        alertController.view.center = controlViewCenter;
    }
}

@end

#pragma clang diagnostic pop
