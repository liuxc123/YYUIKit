//
//  YYUISheetView.m
//  YYUIKit
//
//  Created by liuxc on 2021/12/8.
//

#import "YYUISheetView.h"
#import "YYUIKitMacro.h"
#import "UIColor+YYAdd.h"
#import "UIApplication+YYUIAdd.h"
#import "UIView+YYUIAdd.h"

@interface YYUISheetView ()

@property (nonatomic) NSArray<UIView *> *customViews;
@property (nonatomic) YYUIAlertAction *cancelAction;
@property (nonatomic) NSArray<YYUIAlertAction *> *actions;
@property (nonatomic) YYUIPopupController *popupController;

@property (strong, nonatomic) UIScrollView      *headerScrollView;
@property (strong, nonatomic) UIScrollView      *actionScrollView;
@property (strong, nonatomic) UIView            *cancelActionView;

@property (strong, nonatomic) UIImageView       *imageView;
@property (strong, nonatomic) UILabel           *titleLabel;
@property (strong, nonatomic) UILabel           *messageLabel;
@property (strong, nonatomic) UIView            *headerSeparatorView;
@property (strong, nonatomic) UIView            *cancelSeparatorView;
@property (nonatomic) NSMutableArray<YYUIAlertActionButton *>    *actionButtons;

@property (nonatomic) YYUIAlertActionButton *cancelButton;
@property (nonatomic) UIView *cancelSpaceView;

@end

@implementation YYUISheetView

#pragma mark - Public

+ (instancetype)sheetViewWithTitle:(NSString *)title message:(NSString *)message {
    return [[self alloc] initWithImage:nil title:title message:message];
}

+ (instancetype)sheetViewWithImage:(UIImage *)image title:(NSString *)title message:(NSString *)message {
    return [[self alloc] initWithImage:image title:title message:message];
}

- (void)addAction:(YYUIAlertAction *)action {
    
    if (action.style == YYUIAlertActionStyleCancel && self.cancelAction) {
        NSAssert(YES, @"cancelAction is exist");
    }
    
    if (action.style == YYUIAlertActionStyleCancel) {
        self.cancelAction = action;
        return;
    }
    
    NSMutableArray *actions = self.actions.mutableCopy;
    [actions addObject:action];
    self.actions = actions;
}

- (void)addCustomView:(UIView *)customView {
    NSMutableArray *customViews = self.customViews.mutableCopy;
    [customViews addObject:customView];
    self.customViews = customViews;
}

- (void)showWithAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [self setupUI];
    [self layoutSheetView];
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
    
    YYUISheetViewConfig *config = [YYUISheetViewConfig globalConfig];

    self.backgroundColor = UIColor.whiteColor;
        
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
    
    self.messageLabel.textColor = config.messageColor;
    
    self.messageLabel.numberOfLines = 0;
    
    [self.headerScrollView addSubview:self.messageLabel];
    
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
                        
        button.bottomSeparatorView.backgroundColor = config.separatorsColor;
        
        [button.bottomSeparatorView setHidden: NO];
        
        YYUIAlertAction *action = self.actions[i];
        
        [self setupDefaultWithAction:action];
        
        [button setAction:action];
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

        [weakSelf.actionButtons addObject:button];
        
        [weakSelf.actionScrollView addSubview:button];
    }
    
    /// cancelActionView
    
    [self addSubview:self.cancelActionView];

    /// cancel action
    
    if (self.cancelAction) {
        
        /// cancelSpaceView
        
        self.cancelSpaceView.backgroundColor = config.separatorsColor;

        [self.cancelActionView addSubview:self.cancelSpaceView];
        
        YYUIAlertActionButton *button = [YYUIAlertActionButton button];
                        
        button.topSeparatorView.backgroundColor = config.separatorsColor;
        
        [button.topSeparatorView setHidden:NO];
        
        YYUIAlertAction *action = self.cancelAction;
        
        [self setupDefaultWithAction:action];
        
        [button setAction:action];
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.cancelButton = button;
        
        [weakSelf.cancelActionView addSubview:button];
    }
}

- (void)setupDefaultWithAction:(YYUIAlertAction *)action {
    
    YYUISheetViewConfig *config = [YYUISheetViewConfig globalConfig];

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
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutSheetView];
    [self roundCorners: UIRectCornerTopLeft | UIRectCornerTopRight radius:[YYUISheetViewConfig globalConfig].cornerRadius];
}

- (void)layoutSheetView {
    YYUISheetViewConfig *config = [YYUISheetViewConfig globalConfig];
    CGFloat maxHeight = kScreenHeight - [UIApplication safeAreaInsets].top;
    CGSize maxSize = CGSizeMake(config.width, maxHeight);
    
    /// layout header
    [self layoutHeaderWithMaxSize:maxSize];
    
    /// layout action
    [self layoutActionWithMaxSize:maxSize];
    
    /// layout cancel action
    [self layoutCancelActionWithMaxSize:maxSize];

    /// layout sheetview
    [self layoutSheetViewWithMaxSize:maxSize];
}

- (void)layoutHeaderWithMaxSize:(CGSize)maxSize {
    
    YYUISheetViewConfig *config = [YYUISheetViewConfig globalConfig];
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
    
    YYUISheetViewConfig *config = [YYUISheetViewConfig globalConfig];
    CGFloat buttonHeight = config.buttonHeight;
    CGFloat originY = 0.0f;
    
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
        
    if (self.actionScrollView) {
        CGRect frame = self.actionScrollView.frame;
        frame.size.width = maxSize.width;
        frame.size.height = originY;
        self.actionScrollView.frame = frame;
        self.actionScrollView.contentSize = frame.size;
    }
}

- (void)layoutCancelActionWithMaxSize:(CGSize)maxSize {
    
    YYUISheetViewConfig *config = [YYUISheetViewConfig globalConfig];
    CGFloat buttonHeight = config.buttonHeight;
    CGFloat originY = 0.0f;
    
    if (self.cancelButton) {
        
        if (self.cancelSpaceView) {
            CGRect frame = self.cancelSpaceView.frame;
            frame.origin.x = 0;
            frame.origin.y = originY;
            frame.size.width = maxSize.width;
            frame.size.height = 10;
            self.cancelSpaceView.frame = frame;
            
            originY += self.cancelSpaceView.frame.size.height;
        }
        
        if (self.cancelButton) {
            CGRect frame = self.cancelButton.frame;
            frame.origin.x = 0;
            frame.origin.y = self.cancelSpaceView.origin.y + self.cancelSpaceView.frame.size.height;
            frame.size.width = maxSize.width;
            frame.size.height = buttonHeight;
            self.cancelButton.frame = frame;
            
            originY += self.cancelButton.frame.size.height;
        }
    }

    originY += [UIApplication safeAreaInsets].bottom;
    
    if (self.cancelActionView) {
        CGRect frame = self.cancelActionView.frame;
        frame.size.width = maxSize.width;
        frame.size.height = originY;
        self.cancelActionView.frame = frame;
    }
}

- (void)layoutSheetViewWithMaxSize:(CGSize)maxSize {
    
    CGFloat maxHeight = maxSize.height - self.cancelActionView.size.height;
        
    /// layout scrollview
    if (self.headerScrollView.contentSize.height + self.actionScrollView.contentSize.height > maxHeight) {
        
        if (self.headerScrollView) {
            CGRect frame = self.headerScrollView.frame;
            frame.size.height = self.headerScrollView.contentSize.height < maxHeight/2 ? self.headerScrollView.contentSize.height : maxHeight/2;
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
            frame.size.height = self.actionScrollView.contentSize.height < maxHeight/2 ? self.actionScrollView.contentSize.height : maxHeight/2;
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
    
    if (self.cancelActionView) {
        CGRect frame = self.cancelActionView.frame;
        frame.origin.y = self.actionScrollView.origin.y + self.actionScrollView.frame.size.height;
        self.cancelActionView.frame = frame;
    }
    
    CGRect frame = self.frame;
    frame.size.width = maxSize.width;
    frame.size.height = self.actionScrollView.origin.y + self.actionScrollView.frame.size.height + self.cancelActionView.frame.size.height;
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
        _headerScrollView.backgroundColor = [YYUISheetViewConfig globalConfig].backgroundColor;
        _headerScrollView.directionalLockEnabled = YES;
        _headerScrollView.bounces = NO;
    }
    return _headerScrollView;
}

- (UIScrollView *)actionScrollView {
    if (!_actionScrollView) {
        _actionScrollView = [[UIScrollView alloc] init];
        _actionScrollView.backgroundColor = [YYUISheetViewConfig globalConfig].backgroundColor;
        _actionScrollView.directionalLockEnabled = YES;
        _actionScrollView.bounces = NO;
    }
    return _actionScrollView;
}

- (UIView *)cancelActionView {
    if (!_cancelActionView) {
        _cancelActionView = [[UIView alloc] init];
    }
    return _cancelActionView;
}

- (UIView *)headerSeparatorView {
    if (!_headerSeparatorView) {
        _headerSeparatorView = [[UIView alloc] init];
    }
    return _headerSeparatorView;
}

- (UIView *)cancelSeparatorView {
    if (!_cancelSeparatorView) {
        _cancelSeparatorView = [[UIView alloc] init];
    }
    return _cancelSeparatorView;
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

- (UIView *)cancelSpaceView {
    if (!_cancelSpaceView) {
        _cancelSpaceView = [[UIView alloc] init];
    }
    return _cancelSpaceView;
}

- (YYUIPopupController *)popupController {
    if (!_popupController) {
        _popupController = [YYUIPopupController popupWithView:self];
        _popupController.presentationStyle  = YYUIPopupAnimationStyleFromBottom;
        _popupController.dismissonStyle     = YYUIPopupAnimationStyleFromBottom;
        _popupController.layoutType         = YYUIPopupLayoutTypeBottom;
        _popupController.panGestureEnabled  = YES;
    }
    return _popupController;
}

@end

@interface YYUISheetViewConfig ()

@end

@implementation YYUISheetViewConfig

+ (YYUISheetViewConfig *)globalConfig
{
    static YYUISheetViewConfig *config;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        config = [YYUISheetViewConfig new];
        
    });
    
    return config;
}

- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.width          = kScreenWidth;
        self.buttonHeight   = 55.0f;
        self.innerMargin    = 25.0f;
        self.itemSpacing    = 20.0f;
        self.cornerRadius   = 10.0f;
        
        self.titleFont          = [UIFont systemFontOfSize:18.0f];
        self.messageFont        = [UIFont systemFontOfSize:14.0f];
        self.buttonFont         = [UIFont systemFontOfSize:17.0f];
        
        self.backgroundColor    = [UIColor colorWithHexString:@"#ffffff"];
        self.titleColor         = [UIColor colorWithHexString:@"#333333"];
        self.messageColor       = [UIColor colorWithHexString:@"#333333"];
        self.separatorsColor    = [UIColor colorWithHexString:@"#cccccc"];
        
        self.buttonDefaultColor     = [UIColor colorWithHexString:@"#333333"];
        self.buttonCancelColor      = [UIColor colorWithHexString:@"#333333"];
        self.buttonDestructiveColor = [UIColor colorWithHexString:@"#cccccc"];
    }
    
    return self;
}

@end
