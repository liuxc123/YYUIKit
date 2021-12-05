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
    if (style == YYUIAlertActionStyleDestructive) {
//        self.titleColor = [SPColorStyle alertRedColor];
//        self.titleFont = [UIFont systemFontOfSize:SP_ACTION_TITLE_FONTSIZE];
    } else if (style == YYUIAlertActionStyleCancel) {
//        self.titleColor = [SPColorStyle lightBlack_DarkWhiteColor];
//        self.titleFont = [UIFont boldSystemFontOfSize:SP_ACTION_TITLE_FONTSIZE];
    } else {
//        self.titleColor = [SPColorStyle lightBlack_DarkWhiteColor];
//        self.titleFont = [UIFont systemFontOfSize:SP_ACTION_TITLE_FONTSIZE];
    }
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


#pragma mark - YYUIInterfaceActionItemSeparatorView

@interface YYUIAlertInterfaceActionItemSeparatorView : UIView

@end

@implementation YYUIAlertInterfaceActionItemSeparatorView

@end


#pragma mark - YYUIInterfaceHeaderScrollView

@interface YYUIInterfaceHeaderScrollView : UIScrollView
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, assign) CGSize imageLimitSize;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *messageLabel;
@property (nonatomic, weak) UIStackView *textFieldView;
@property (nonatomic, strong) NSMutableArray *textFields;
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;
@property (nonatomic, copy) void(^headerViewSfeAreaDidChangBlock)(void);
@end

@implementation YYUIInterfaceHeaderScrollView

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
    if (self.headerViewSfeAreaDidChangBlock) {
        self.headerViewSfeAreaDidChangBlock();
    }
    [self setNeedsUpdateConstraints];
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
    
    // 对imageView布局
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
}


@end


#pragma mark - YYUIAlertController

@interface YYUIAlertController () <UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UIView *alertControllerView;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIView *alertView;
@property (nonatomic, strong) UIView *customAlertView;

@end

@implementation YYUIAlertController


- (void)layoutAlertControllerView {

}

#pragma mark - lazy load












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

    [self.overlayView setAppearanceStyle:alertController.coverBlurEffect alpha:alertController.backgroundBlurEffectAlpha];

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


#pragma mark - YYUIAlertAnimation

@interface YYUIAlertAnimation ()

@property (nonatomic, assign) BOOL presenting;

@end

@implementation YYUIAlertAnimation

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
