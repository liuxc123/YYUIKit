//
//  YYUIAlertView.m
//  YYUIKit
//
//  Created by liuxc on 2021/12/7.
//

#import "YYUIAlertView.h"
#import "UIColor+YYAdd.h"
#import "YYUIKitMacro.h"
#import "UIApplication+YYUIAdd.h"

@interface YYUIAlertView ()

@property (nonatomic) NSArray<YYUIAlertAction *> *actions;
@property (nonatomic) NSArray<UITextField *> *textFields;
@property (nonatomic) NSArray<UIView *> *customViews;
@property (nonatomic) YYUIPopupController *popupController;

@property (strong, nonatomic) UIScrollView      *headerScrollView;
@property (strong, nonatomic) UIScrollView      *actionScrollView;

@property (strong, nonatomic) UIImageView       *imageView;
@property (strong, nonatomic) UILabel           *titleLabel;
@property (strong, nonatomic) UILabel           *messageLabel;
@property (strong, nonatomic) UIView            *headerSeparatorView;
@property (strong, nonatomic) UIView            *verticalSeparatorView;
@property (nonatomic) NSMutableArray<YYUIAlertActionButton *>    *actionButtons;

@end

@implementation YYUIAlertView

#pragma mark - Public

+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message {
    return [[self alloc] initWithImage:nil title:title message:message];
}

+ (instancetype)alertViewWithImage:(UIImage *)image title:(NSString *)title message:(NSString *)message {
    return [[self alloc] initWithImage:image title:title message:message];
}

- (void)setCustomView:(UIView *)customView {
    self.customView = customView;
}

- (void)addAction:(YYUIAlertAction *)action {
    NSMutableArray *actions = self.actions.mutableCopy;
    [actions addObject:action];
    self.actions = actions;
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField * _Nonnull))configurationHandler {
    NSMutableArray *textFields = self.textFields.mutableCopy;
    UITextField *textField = [[UITextField alloc] init];
    if (configurationHandler) { configurationHandler(textField); }
    [textFields addObject:textField];
    self.textFields = textFields;
}

- (void)addCustomView:(UIView *)customView {
    NSMutableArray *customViews = self.customViews.mutableCopy;
    [customViews addObject:customView];
    self.customViews = customViews;
}

- (void)showWithAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [self setupUI];
    [self layoutAlertView];
    [self.popupController showWithDuration:animated ? 0.25 : 0 completion:completion];
}

- (void)dismissWithAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [self.popupController dismissWithDuration:animated ? 0.25 : 0 completion:completion];
}

#pragma mark - Priavte

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title message:(NSString *)message {
    self = [super init];
    if (self) {
        self.image = image;
        self.title = title;
        self.message = message;
    }
    return self;
}

- (void)setupUI {
    
    __weak typeof(self) weakSelf = self;
    
    YYUIAlertViewConfig *config = [YYUIAlertViewConfig globalConfig];

    self.backgroundColor = UIColor.whiteColor;
    
    self.layer.cornerRadius = [YYUIAlertViewConfig globalConfig].cornerRadius;
    
    self.clipsToBounds = YES;
    
    [self addSubview: self.headerScrollView];
    
    [self addSubview: self.actionScrollView];
    
    /// image
    
    self.imageView.image = self.image;
    
    [self.headerScrollView addSubview:self.imageView];
    
    /// title
    
    self.titleLabel.text = self.title;
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.titleLabel.font = config.titleFont;
    
    self.titleLabel.textColor = config.titleColor;
    
    self.titleLabel.numberOfLines = 0;
    
    [self.headerScrollView addSubview:self.titleLabel];
    
    /// message
    
    self.messageLabel.text = self.message;
    
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    
    self.messageLabel.font = config.messageFont;
    
    self.messageLabel.textColor = config.titleColor;
    
    self.messageLabel.numberOfLines = 0;
    
    [self.headerScrollView addSubview:self.messageLabel];

    /// textFields
    
    [self.textFields enumerateObjectsUsingBlock:^(UITextField * _Nonnull textField, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [weakSelf.headerScrollView addSubview:textField];
        
    }];
    
    /// customView
    
    [self.customViews enumerateObjectsUsingBlock:^(UIView * _Nonnull customView, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf.headerScrollView addSubview:customView];
    }];
    
    /// headerSeparatorView

    self.headerSeparatorView.backgroundColor = config.separatorsColor;
    
    [self addSubview: self.headerSeparatorView];
    
    /// actionScrollView

    [self addSubview: self.actionScrollView];
    
    /// actions
    
    for (int i = 0; i < self.actions.count; i++) {
        YYUIAlertActionButton *button = [YYUIAlertActionButton button];
                        
        button.separatorView.backgroundColor = config.separatorsColor;
        
        [button.separatorView setHidden: self.actions.count <= 2 || i == self.actions.count - 1];
        
        YYUIAlertAction *action = self.actions[i];
        
        action.font = action.font ? action.font : config.buttonFont;
        
        switch (action.style) {
            case YYUIAlertActionStyleDefault:
                action.titleColor = action.titleColor ? action.titleColor : config.buttonDefaultColor;
                break;
            case YYUIAlertActionStyleCancel:
                action.titleColor = action.titleColor ? action.titleColor : config.buttonCancelColor;
                break;
            case YYUIAlertActionStyleDestructive:
                action.titleColor = action.titleColor ? action.titleColor : config.buttonDestructiveColor;
                break;
            default:
                break;
        }
        
        [button setAction:action];
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

        [weakSelf.actionButtons addObject:button];
        
        [weakSelf.actionScrollView addSubview:button];
        
    }
    
    /// verticalSeparatorView
    
    if (self.actions.count == 2) {

        self.verticalSeparatorView.backgroundColor = config.separatorsColor;
        
        [self.actionScrollView addSubview: self.verticalSeparatorView];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutAlertView];
}

- (void)layoutAlertView {
    YYUIAlertViewConfig *config = [YYUIAlertViewConfig globalConfig];
    CGFloat maxHeight = kScreenHeight - [UIApplication safeAreaInsets].top - [UIApplication safeAreaInsets].bottom;
    CGSize maxSize = CGSizeMake(config.width, maxHeight);
    
    /// layout header
    [self layoutHeaderWithMaxSize:maxSize];
    
    /// layout action
    [self layoutActionWithMaxSize:maxSize];

    /// layout alertview
    [self layoutAlertViewWithMaxSize:maxSize];
}

- (void)layoutHeaderWithMaxSize:(CGSize)maxSize {
    
    YYUIAlertViewConfig *config = [YYUIAlertViewConfig globalConfig];
    CGFloat innerMargin = config.innerMargin;
    CGFloat itemSpacing = config.itemSpacing;
    CGFloat originY = innerMargin;

    if (self.image) {
        CGRect frame = self.imageView.frame;
        frame.size = [self.imageView sizeThatFits:CGSizeMake(maxSize.width - innerMargin * 2, CGFLOAT_MAX)];
        frame.origin = CGPointMake((maxSize.width - frame.size.width)/2, innerMargin);
        self.imageView.frame = frame;
        originY += self.imageView.frame.size.height;
        originY += itemSpacing;
    }
    
    if (self.title) {
        self.titleLabel.preferredMaxLayoutWidth = maxSize.width - innerMargin * 2;
        
        CGRect frame = self.titleLabel.frame;
        frame.size = [self.titleLabel sizeThatFits:CGSizeMake(maxSize.width - innerMargin * 2, CGFLOAT_MAX)];
        frame.origin = CGPointMake((maxSize.width - frame.size.width)/2, originY);
        self.titleLabel.frame = frame;
        originY += self.titleLabel.frame.size.height;
        originY += itemSpacing;
    }
    
    if (self.message) {
        self.messageLabel.preferredMaxLayoutWidth = maxSize.width - innerMargin * 2;
        
        CGRect frame = self.messageLabel.frame;
        frame.size = [self.messageLabel sizeThatFits:CGSizeMake(maxSize.width - innerMargin * 2, CGFLOAT_MAX)];
        frame.origin = CGPointMake((maxSize.width - frame.size.width)/2, originY);
        self.messageLabel.frame = frame;
        originY += self.messageLabel.frame.size.height;
        originY += itemSpacing;
    }
    
    for (UITextField *textField in self.textFields) {
        CGRect frame = textField.frame;
        frame.size = CGSizeMake(maxSize.width - innerMargin * 2, config.textFieldHeight);
        frame.origin = CGPointMake((maxSize.width - frame.size.width)/2, originY);
        textField.frame = frame;
        originY += textField.frame.size.height;
        originY += itemSpacing;
    }
    
    for (UIView *customView in self.customViews) {
        CGRect frame = customView.frame;
        frame.size = [customView sizeThatFits:CGSizeMake(maxSize.width - innerMargin * 2, CGFLOAT_MAX)];
        frame.origin = CGPointMake((maxSize.width - frame.size.width)/2, originY);
        customView.frame = frame;
        originY += customView.frame.size.height;
        originY += itemSpacing;
    }

    if (self.headerScrollView) {
        CGRect frame = self.headerScrollView.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        frame.size.width = maxSize.width;
        frame.size.height = originY;
        self.headerScrollView.frame = frame;
        self.headerScrollView.contentSize = frame.size;
    }
    
    if (self.headerSeparatorView) {
        CGRect frame = self.headerScrollView.frame;
        frame.origin.x = 0;
        frame.origin.y = originY;
        frame.size.width = maxSize.width;
        frame.size.height = CGFloatFromPixel(1.0);
        self.headerSeparatorView.frame = frame;
    }
}

- (void)layoutActionWithMaxSize:(CGSize)maxSize {
    
    YYUIAlertViewConfig *config = [YYUIAlertViewConfig globalConfig];
    CGFloat buttonHeight = config.buttonHeight;
    CGFloat originY = 0.0f;
    
    if (self.actions.count <= 2) {
        
        for (int i = 0; i < self.actions.count; i++) {
            
            YYUIAlertActionButton *button = self.actionButtons[i];
            CGRect frame = button.frame;
            frame.origin.x = (maxSize.width / self.actions.count) * i;
            frame.origin.y = 0;
            frame.size.width = maxSize.width / self.actions.count;
            frame.size.height = buttonHeight;
            button.frame = frame;
        }
        
        originY += buttonHeight;
        
    } else {
        
        for (int i = 0; i < self.actions.count; i++) {
            
            YYUIAlertActionButton *button = self.actionButtons[i];
            CGRect frame = button.frame;
            frame.origin.x = 0;
            frame.origin.y = originY;
            frame.size.width = maxSize.width;
            frame.size.height = buttonHeight;
            button.frame = frame;
            
            originY += button.frame.size.height;
        }
    }
    
    if (self.verticalSeparatorView) {
        CGRect frame = self.verticalSeparatorView.frame;
        frame.origin.x = (maxSize.width - CGFloatFromPixel(1.0)) / 2;
        frame.origin.y = 0;
        frame.size.width = CGFloatFromPixel(1.0);
        frame.size.height = buttonHeight;
        self.verticalSeparatorView.frame = frame;
    }
    
    if (self.actionScrollView) {
        CGRect frame = self.actionScrollView.frame;
        frame.size.width = maxSize.width;
        frame.size.height = originY;
        self.actionScrollView.frame = frame;
        self.actionScrollView.contentSize = frame.size;
    }
}

- (void)layoutAlertViewWithMaxSize:(CGSize)maxSize {
    /// layout scrollview
    if (self.headerScrollView.contentSize.height + self.actionScrollView.contentSize.height > maxSize.height) {
        
        if (self.headerScrollView) {
            CGRect frame = self.headerScrollView.frame;
            frame.size.height = self.headerScrollView.contentSize.height < maxSize.height/2 ? self.headerScrollView.contentSize.height : maxSize.height/2;
            self.headerScrollView.frame = frame;
        }
        
        if (self.headerSeparatorView) {
            CGRect frame = self.headerSeparatorView.frame;
            frame.origin.y = self.headerScrollView.origin.y + self.headerScrollView.frame.size.height;
            self.headerSeparatorView.frame = frame;
        }
        
        if (self.actionScrollView) {
            CGRect frame = self.actionScrollView.frame;
            frame.origin.y = self.headerSeparatorView.origin.y + self.headerSeparatorView.frame.size.height;
            frame.size.height = self.actionScrollView.contentSize.height < maxSize.height/2 ? self.actionScrollView.contentSize.height : maxSize.height/2;
            self.actionScrollView.frame = frame;
        }
    }
    
    else {
        
        if (self.headerSeparatorView) {
            CGRect frame = self.headerSeparatorView.frame;
            frame.origin.y = self.headerScrollView.origin.y + self.headerScrollView.frame.size.height;
            self.headerSeparatorView.frame = frame;
        }
        
        if (self.actionScrollView) {
            CGRect frame = self.actionScrollView.frame;
            frame.origin.y = self.headerSeparatorView.origin.y + self.headerSeparatorView.frame.size.height;
            self.actionScrollView.frame = frame;
        }
    }
    
    CGRect frame = self.frame;
    frame.size.width = maxSize.width;
    frame.size.height = self.actionScrollView.origin.y + self.actionScrollView.frame.size.height;
    self.frame = frame;
}

#pragma mark Event Response

- (void)buttonAction:(YYUIAlertActionButton *)sender {
    if (!sender.action.dismissOnTouch) {
        return;
    }
    
    [self dismissWithAnimated:YES completion:^{
        if (sender.action.handler) {
            sender.action.handler(sender.action);
        }
    }];
}

#pragma mark - Lazy Load

- (UIScrollView *)headerScrollView {
    if (!_headerScrollView) {
        _headerScrollView = [[UIScrollView alloc] init];
        _headerScrollView.backgroundColor = [YYUIAlertViewConfig globalConfig].backgroundColor;
        _headerScrollView.directionalLockEnabled = YES;
        _headerScrollView.bounces = NO;
    }
    return _headerScrollView;
}

- (UIScrollView *)actionScrollView {
    if (!_actionScrollView) {
        _actionScrollView = [[UIScrollView alloc] init];
        _actionScrollView.backgroundColor = [YYUIAlertViewConfig globalConfig].backgroundColor;
        _actionScrollView.directionalLockEnabled = YES;
        _actionScrollView.bounces = NO;
    }
    return _actionScrollView;
}

- (UIView *)headerSeparatorView {
    if (!_headerSeparatorView) {
        _headerSeparatorView = [[UIView alloc] init];
    }
    return _headerSeparatorView;
}

- (UIView *)verticalSeparatorView {
    if (!_verticalSeparatorView) {
        _verticalSeparatorView = [[UIView alloc] init];
    }
    return _verticalSeparatorView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
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

- (NSArray<UIView *> *)customViews {
    if (!_customViews) {
        _customViews = [NSArray array];
    }
    return _customViews;
}

- (NSMutableArray<YYUIAlertActionButton *> *)actionButtons {
    if (!_actionButtons) {
        _actionButtons = [NSMutableArray array];
    }
    return _actionButtons;
}

- (YYUIPopupController *)popupController {
    if (!_popupController) {
        _popupController = [YYUIPopupController popupWithView:self];
        _popupController.presentationStyle  = YYUIPopupAnimationStyleFade;
        _popupController.dismissonStyle     = YYUIPopupAnimationStyleFade;
        _popupController.layoutType         = YYUIPopupLayoutTypeCenter;
    }
    return _popupController;
}

@end

@interface YYUIAlertViewConfig ()

@end

@implementation YYUIAlertViewConfig

+ (YYUIAlertViewConfig *)globalConfig
{
    static YYUIAlertViewConfig *config;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        config = [YYUIAlertViewConfig new];
        
    });
    
    return config;
}

- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.width          = 275.0f;
        self.maxHeight      = kScreenHeight;
        self.buttonHeight   = 50.0f;
        self.innerMargin    = 25.0f;
        self.itemSpacing    = 20.0f;
        self.cornerRadius   = 10.0f;
        
        self.titleFont          = [UIFont systemFontOfSize:18.0f];
        self.messageFont        = [UIFont systemFontOfSize:14.0f];
        self.buttonFont         = [UIFont systemFontOfSize:17.0f];
        
        self.backgroundColor    = [UIColor colorWithHexString:@"#ffffff"];
        self.titleColor         = [UIColor colorWithHexString:@"#333333"];
        self.detailColor        = [UIColor colorWithHexString:@"#333333"];
        self.separatorsColor    = [UIColor colorWithHexString:@"#cccccc"];
        
        self.buttonDefaultColor     = [UIColor colorWithHexString:@"#333333"];
        self.buttonCancelColor      = [UIColor colorWithHexString:@"#333333"];
        self.buttonDestructiveColor = [UIColor colorWithHexString:@"#cccccc"];
    }
    
    return self;
}

@end
