//
//  YYUIPopupController.m
//  YYUIKit
//
//  Created by liuxc on 2021/12/7.
//

#import "YYUIPopupController.h"
#import <objc/runtime.h>
#import "YYWeakProxy.h"

@interface YYUIPopupController () <UIGestureRecognizerDelegate> {
    NSTimer *_timer;
    BOOL _isKeyboardVisible;
    BOOL _directionalVertical;
    BOOL _isDirectionLocked;
}
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, weak) UIView *proxyView;

@end

@implementation YYUIPopupController

- (void)defaultValueInitialization {
    _isPresenting = NO;
    _maskType = YYUIPopupMaskTypeBlackOpacity;
    _maskAlpha = 0.5;
    _layoutType = YYUIPopupLayoutTypeCenter;
    _presentationStyle = YYUIPopupAnimationStyleFade;
    _dismissonStyle = -1;
    _windowLevel = YYUIPopupWindowLevelNormal;
    _presentationTransformScale = 0.5;
    _dismissonTransformScale = 0.5;
    _dismissOnMaskTouched = YES;
    _dismissAfterDelay = 0;
    _panGestureEnabled = NO;
    _panDismissRatio = 0.5;
    _offsetSpacing = 0;
    _keyboardOffsetSpacing = 0;
    _keyboardChangeFollowed = NO;
    _becomeFirstResponded = NO;
    _directionalVertical = NO;
    _isDirectionLocked = NO;
    _isKeyboardVisible = NO;
}

+ (instancetype)popupWithView:(UIView *)popupView {
    return [[self alloc] initWithView:popupView size:CGSizeZero];
}

+ (instancetype)popupWithController:(UIViewController *)controller {
    return [[self alloc] initWithView:controller.view size:CGSizeZero];
}

- (instancetype)initWithView:(UIView *)aView size:(CGSize)size {
    if (self = [super init]) {
        [self defaultValueInitialization];
        CGSize _size = CGSizeEqualToSize(CGSizeZero, size) ? aView.bounds.size : size;
        aView.frame = CGRectMake(0, 0, _size.width, _size.height);
        _view = aView;
        _view.yyui_popupController = self;
        __weak typeof(self) _self = self;
        self.defaultDismissBlock = ^(YYUIPopupController * _Nonnull popupController) {
            [_self dismiss];
        };
        [self bindNotifications];
    }
    return self;
}

- (void)presentDuration:(NSTimeInterval)duration
                  delay:(NSTimeInterval)delay
                options:(UIViewAnimationOptions)options
                bounced:(BOOL)isBounced
             completion:(void (^)(void))completion {
    if (self.isPresenting) return;
    
    self.maskView.alpha = 0;
    [self prepareSlideStyle];
    self.view.center = [self prepareCenter];
    
    __block void (^finishedCallback)(void) = ^() {
        self->_isPresenting = YES;
        if (self.didPresentBlock) {
            self.didPresentBlock(self);
        } else {
            if ([self.delegate respondsToSelector:@selector(popupControllerDidPresent:)]) {
                [self.delegate popupControllerDidPresent:self];
            }
        }
        
        if (self.dismissAfterDelay > 0) {
            self->_timer = [NSTimer timerWithTimeInterval:self.dismissAfterDelay target:self selector:@selector(timerPerform) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:self->_timer forMode:NSRunLoopCommonModes];
        }
        
        if (completion) completion();
    };
    
    if (self.keyboardChangeFollowed && self.becomeFirstResponded) {
        self.view.center = [self finalCenter];
        if (self.willPresentBlock) {
            self.willPresentBlock(self);
        } else {
            if ([self.delegate respondsToSelector:@selector(popupControllerWillPresent:)]) {
                [self.delegate popupControllerWillPresent:self];
            }
        }
        
        [UIView animateWithDuration:duration delay:delay options:options animations:^{
            self.maskView.alpha = 1;
            [self finalSlideStyle];
        } completion:^(BOOL finished) {
            finishedCallback();
        }];
    } else {
     
        if (self.willPresentBlock) {
            self.willPresentBlock(self);
        } else {
            if ([self.delegate respondsToSelector:@selector(popupControllerWillPresent:)]) {
                [self.delegate popupControllerWillPresent:self];
            }
        }
        
        if (isBounced) {
            [UIView animateWithDuration:duration * 0.25 delay:delay options:options animations:^{
                self.maskView.alpha = 1;
            } completion:NULL];
            
            [UIView animateWithDuration:duration delay:delay usingSpringWithDamping:0.6 initialSpringVelocity:0.25 options:options animations:^{
                [self finalSlideStyle];
                self.view.center = [self finalCenter];
            } completion:^(BOOL finished) {
                finishedCallback();
            }];
        } else {
            [UIView animateWithDuration:duration delay:delay options:options animations:^{
                self.maskView.alpha = 1;
                [self finalSlideStyle];
                self.view.center =  [self finalCenter];
            } completion:^(BOOL finished) {
                finishedCallback();
            }];
        }
        
    }
}
- (void)dismissDuration:(NSTimeInterval)duration
                  delay:(NSTimeInterval)delay
                options:(UIViewAnimationOptions)options
             completion:(void (^)(void))completion {
    if (!self.isPresenting) return;
    _isPresenting = NO;
    if (self.willDismissBlock) {
        self.willDismissBlock(self);
    } else {
        if ([self.delegate respondsToSelector:@selector(popupControllerWillDismiss:)]) {
            [self.delegate popupControllerWillDismiss:self];
        }
    }
    
    [UIView animateWithDuration:duration delay:delay options:options animations:^{
        [self dismissSlideStyle];
        self.view.center = [self dismissedCenter];
        self.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [self finalSlideStyle];
        [self removeSubviews];
        if (self.didDismissBlock) {
            self.didDismissBlock(self);
        } else {
            if ([self.delegate respondsToSelector:@selector(popupControllerDidDismiss:)]) {
                [self.delegate popupControllerDidDismiss:self];
            }
        }
        
        if (self.dismissAfterDelay > 0) {
            [self->_timer invalidate];
            self->_timer = nil;
        }
        
        if (completion) completion();
    }];
}

- (void)timerPerform {
    if (self.defaultDismissBlock) {
        self.defaultDismissBlock(self);
    }
}

- (void)addSubviewBelow:(UIView *)subview {
    [self.proxyView insertSubview:self.maskView belowSubview:subview];
    [self.proxyView insertSubview:self.view aboveSubview:self.maskView];
}

- (void)addSubview {
    [self.proxyView addSubview:self.maskView];
    [self.proxyView addSubview:self.view];
}

- (void)removeSubviews {
    [_view removeFromSuperview];
    [_maskView removeFromSuperview];
}

- (void)prepareSlideStyle {
    [self takeSlideStyle:self.presentationStyle scale:self.presentationTransformScale];
}

- (void)dismissSlideStyle {
    [self takeSlideStyle:self.dismissonStyle < 0 ? self.presentationStyle : self.dismissonStyle scale:self.dismissonTransformScale];
}

- (void)takeSlideStyle:(YYUIPopupAnimationStyle)slideStyle scale:(CGFloat)scale {
    switch (slideStyle) {
        case YYUIPopupAnimationStyleFade: {
            self.view.alpha = 0;
        } break;
        case YYUIPopupAnimationStyleTransform: {
            self.view.alpha = 0;
            self.view.transform = CGAffineTransformMakeScale(scale, scale);
        } break;
        default: break;
    }
}

- (void)finalSlideStyle {
    switch (self.presentationStyle) {
        case YYUIPopupAnimationStyleFade: {
            self.view.alpha = 1;
        } break;
        case YYUIPopupAnimationStyleTransform: {
            self.view.alpha = 1;
            self.view.transform = CGAffineTransformIdentity;
        } break;
        default: break;
    }
}

- (CGPoint)prepareCenter {
    return [self takeCenter:self.presentationStyle];
}

- (CGPoint)dismissedCenter {
    return [self takeCenter:self.dismissonStyle < 0 ? self.presentationStyle : self.dismissonStyle];
}

- (CGPoint)takeCenter:(YYUIPopupAnimationStyle)slideStyle {
    switch (slideStyle) {
        case YYUIPopupAnimationStyleFromTop:
            return CGPointMake([self finalCenter].x,
                               -self.view.bounds.size.height / 2);
        case YYUIPopupAnimationStyleFromLeft:
            return CGPointMake(-self.view.bounds.size.width / 2,
                               [self finalCenter].y);
        case YYUIPopupAnimationStyleFromBottom:
            return CGPointMake([self finalCenter].x,
                               self.maskView.bounds.size.height + self.view.bounds.size.height / 2);
        case YYUIPopupAnimationStyleFromRight:
            return CGPointMake(self.maskView.bounds.size.width + self.view.bounds.size.width / 2,
                               [self finalCenter].y);
        default:
            return [self finalCenter];
    }
}

- (CGPoint)finalCenter {
    switch (self.layoutType) {
        case YYUIPopupLayoutTypeTop:
            return CGPointMake(self.maskView.center.x,
                               self.view.bounds.size.height / 2 + self.offsetSpacing);
        case YYUIPopupLayoutTypeLeft:
            return CGPointMake(self.view.bounds.size.width / 2 + self.offsetSpacing,
                               self.maskView.center.y);
        case YYUIPopupLayoutTypeBottom:
            return CGPointMake(self.maskView.center.x,
                               self.maskView.bounds.size.height - self.view.bounds.size.height / 2 - self.offsetSpacing);
        case YYUIPopupLayoutTypeRight:
            return CGPointMake(self.maskView.bounds.size.width - self.view.bounds.size.width / 2 - self.offsetSpacing,
                               self.maskView.center.y);
        case YYUIPopupLayoutTypeCenter:
            /// only adjust center.y
            return CGPointMake(self.maskView.center.x, self.maskView.center.y + self.offsetSpacing);
        default: break;
    }
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.proxyView.bounds];
        switch (self.maskType) {
            case YYUIPopupMaskTypeDarkBlur: {
                UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
                UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
                blurView.frame = _maskView.bounds;
                [_maskView insertSubview:blurView atIndex:0];
            } break;
            case YYUIPopupMaskTypeLightBlur: {
                UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
                UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
                blurView.frame = _maskView.bounds;
                [_maskView insertSubview:blurView atIndex:0];
            } break;
            case YYUIPopupMaskTypeExtraLightBlur: {
                UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
                UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
                blurView.frame = _maskView.bounds;
                [_maskView insertSubview:blurView atIndex:0];
            } break;
            case YYUIPopupMaskTypeWhite: {
                _maskView.backgroundColor = [UIColor whiteColor];
            } break;
            case YYUIPopupMaskTypeClear: {
                _maskView.backgroundColor = [UIColor clearColor];
            } break;
            case YYUIPopupMaskTypeBlackOpacity: {
                _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:self.maskAlpha];
            } break;
            default: break;
        }
        UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tap.delegate = self;
        [_maskView addGestureRecognizer:tap];
        if (self.panGestureEnabled) {
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
            [self.view addGestureRecognizer:pan];
        }
    }
    return _maskView;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return ![touch.view isDescendantOfView:self.view];
    }
    return YES;
}

- (void)handleTap:(UITapGestureRecognizer *)g {
    if (self.isPresenting && self.dismissOnMaskTouched) {
        if (self.defaultDismissBlock) {
            self.defaultDismissBlock(self);
        }
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)g {
    if (_isKeyboardVisible || !self.panGestureEnabled) return;
    CGPoint p = [g translationInView:self.maskView];
    
    switch (g.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged: {
            
            switch (self.layoutType) {
                case YYUIPopupLayoutTypeTop: {
                    CGFloat boundary = g.view.bounds.size.height + self.offsetSpacing;
                    if ((CGRectGetMinY(g.view.frame) + g.view.bounds.size.height + p.y) < boundary) {
                        g.view.center = CGPointMake(g.view.center.x, g.view.center.y + p.y);
                    } else {
                        g.view.center = [self finalCenter];
                    }
                    self.maskView.alpha = CGRectGetMaxY(g.view.frame) / boundary;
                } break;
                case YYUIPopupLayoutTypeLeft: {
                    CGFloat boundary = g.view.bounds.size.width + self.offsetSpacing;
                    if ((CGRectGetMinX(g.view.frame) + g.view.bounds.size.width + p.x) < boundary) {
                        g.view.center = CGPointMake(g.view.center.x + p.x, g.view.center.y);
                    } else {
                        g.view.center = [self finalCenter];
                    }
                    self.maskView.alpha = CGRectGetMaxX(g.view.frame) / boundary;
                } break;
                case YYUIPopupLayoutTypeBottom: {
                    CGFloat boundary = self.maskView.bounds.size.height - g.view.bounds.size.height - self.offsetSpacing;
                    if ((g.view.frame.origin.y + p.y) > boundary) {
                        g.view.center = CGPointMake(g.view.center.x, g.view.center.y + p.y);
                    } else {
                        g.view.center = [self finalCenter];
                    }
                    self.maskView.alpha = 1 - (CGRectGetMinY(g.view.frame) - boundary) / (self.maskView.bounds.size.height - boundary);
                } break;
                case YYUIPopupLayoutTypeRight: {
                    CGFloat boundary = self.maskView.bounds.size.width - g.view.bounds.size.width - self.offsetSpacing;
                    if ((CGRectGetMinX(g.view.frame) + p.x) > boundary) {
                        g.view.center = CGPointMake(g.view.center.x + p.x, g.view.center.y);
                    } else {
                        g.view.center = [self finalCenter];
                    }
                    self.maskView.alpha = 1 - (CGRectGetMinX(g.view.frame) - boundary) / (self.maskView.bounds.size.width - boundary);
                } break;
                case YYUIPopupLayoutTypeCenter: {
                    [self directionalLock:p];
                    if (_directionalVertical) {
                        g.view.center = CGPointMake(g.view.center.x, g.view.center.y + p.y);
                        CGFloat boundary = self.maskView.bounds.size.height / 2 + self.offsetSpacing - g.view.bounds.size.height / 2;
                        self.maskView.alpha = 1 - (CGRectGetMinY(g.view.frame) - boundary) / (self.maskView.bounds.size.height - boundary);
                    } else {
                        [self directionalUnlock]; // todo...
                    }
                } break;
                default: break;
            }
            
            [g setTranslation:CGPointZero inView:self.maskView];
        } break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded: {
            
            BOOL isDismissNeeded = NO;
            switch (self.layoutType) {
                case YYUIPopupLayoutTypeTop: {
                    isDismissNeeded = CGRectGetMaxY(g.view.frame) < self.maskView.bounds.size.height * self.panDismissRatio;
                } break;
                case YYUIPopupLayoutTypeLeft: {
                    isDismissNeeded = CGRectGetMaxX(g.view.frame) < self.maskView.bounds.size.width * self.panDismissRatio;
                } break;
                case YYUIPopupLayoutTypeBottom: {
                    isDismissNeeded = CGRectGetMinY(g.view.frame) > self.maskView.bounds.size.height * self.panDismissRatio;
                } break;
                case YYUIPopupLayoutTypeRight: {
                    isDismissNeeded = CGRectGetMinX(g.view.frame) > self.maskView.bounds.size.width * self.panDismissRatio;
                } break;
                case YYUIPopupLayoutTypeCenter: {
                    if (_directionalVertical) {
                        isDismissNeeded = CGRectGetMinY(g.view.frame) > self.maskView.bounds.size.height * self.panDismissRatio;
                        [self directionalUnlock];
                    }
                } break;
                default: break;
            }
            
            if (isDismissNeeded) {
                if (self.defaultDismissBlock) {
                    self.defaultDismissBlock(self);
                }
            } else {
                [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.maskView.alpha = 1;
                    g.view.center = [self finalCenter];
                } completion:NULL];
            }
            
        } break;
        default: break;
    }
}

- (void)directionalLock:(CGPoint)translation {
    if (!_isDirectionLocked) {
        _directionalVertical = ABS(translation.x) < ABS(translation.y);
        _isDirectionLocked = YES;
    }
}

- (void)directionalUnlock {
    _isDirectionLocked = NO;
}

- (void)setKeyboardChangeFollowed:(BOOL)keyboardChangeFollowed {
    if (keyboardChangeFollowed) {
        _keyboardChangeFollowed = keyboardChangeFollowed;
        [self bindKeyboardNotifications];
    }
}

- (void)bindKeyboardNotifications {
    if (self.keyboardChangeFollowed) {
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
}

- (void)unbindKeyboardNotifications {
    if (self.keyboardChangeFollowed) {
        [NSNotificationCenter.defaultCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [NSNotificationCenter.defaultCenter removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    }
}

- (void)keyboardWillHide:(NSNotification *)notif {
    _isKeyboardVisible = NO;
    if (_isPresenting) {
        NSDictionary *u = notif.userInfo;
        UIViewAnimationOptions options = [u[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
        NSTimeInterval duration = [u[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView animateWithDuration:duration delay:0 options:options animations:^{
            self.view.center = [self finalCenter];
        } completion:NULL];
    }
}

- (void)keyboardWillChangeFrame:(NSNotification *)notif {
    NSDictionary *u = notif.userInfo;
    CGRect frameBegin = [u[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect frameEnd = [u[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (frameBegin.size.height > 0 && ABS(CGRectGetMinY(frameBegin) - CGRectGetMinY(frameEnd))) {
        CGRect frameConverted = [self.maskView convertRect:frameEnd fromView:nil];
        CGFloat keyboardHeightConverted = self.maskView.bounds.size.height - CGRectGetMinY(frameConverted);
        if (keyboardHeightConverted > 0) {
            _isKeyboardVisible = YES;
        
            CGFloat originY = CGRectGetMaxY(self.view.frame) - CGRectGetMinY(frameConverted);
            CGPoint newCenter = CGPointMake(self.view.center.x, self.view.center.y - originY - self.keyboardOffsetSpacing);
            NSTimeInterval duration = [u[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
            UIViewAnimationOptions options = [u[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
            [UIView animateWithDuration:duration delay:0 options:options animations:^{
                self.view.center = newCenter;
            } completion:NULL];
        }
    }
}

- (void)bindNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusbarOrientation:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

- (void)unbindNotifications {
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

- (void)didChangeStatusbarOrientation:(NSNotification *)notification {
    [self setNeedLayout];
}

- (void)dealloc {
    [self unbindKeyboardNotifications];
    [self unbindNotifications];
}

@end


static void *UIViewYYUIPopupControllersKey = &UIViewYYUIPopupControllersKey;
static void *UIViewYYUIPopupControllerKey = &UIViewYYUIPopupControllerKey;

@implementation UIView (YYUIPopupController)

- (void)setYyui_popupController:(YYUIPopupController *)popupController {
    YYWeakProxy *proxy = [[YYWeakProxy alloc] initWithTarget:popupController];
    objc_setAssociatedObject(self, UIViewYYUIPopupControllersKey, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YYUIPopupController *)yyui_popupController {
    return ((YYWeakProxy *)objc_getAssociatedObject(self, UIViewYYUIPopupControllerKey)).target;
}

- (void)yyui_presentPopupController:(YYUIPopupController *)popupController completion:(void (^)(void))completion {
    return [self yyui_presentPopupController:popupController duration:0.25 completion:completion];
}

- (void)yyui_presentPopupController:(YYUIPopupController *)popupController duration:(NSTimeInterval)duration completion:(void (^)(void))completion {
    return [self yyui_presentPopupController:popupController duration:duration bounced:NO completion:completion];
}

- (void)yyui_presentPopupController:(YYUIPopupController *)popupController duration:(NSTimeInterval)duration bounced:(BOOL)isBounced completion:(void (^)(void))completion {
    return [self yyui_presentPopupController:popupController duration:duration delay:0 options:UIViewAnimationOptionCurveLinear bounced:isBounced completion:completion];
}

- (void)yyui_presentPopupController:(YYUIPopupController *)popupController duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options bounced:(BOOL)isBounced completion:(void (^)(void))completion {
    NSMutableArray<YYUIPopupController *> *_popupControllers = objc_getAssociatedObject(self, UIViewYYUIPopupControllersKey);
    if (!_popupControllers) {
        _popupControllers = [[NSMutableArray alloc] init];
        objc_setAssociatedObject(self, UIViewYYUIPopupControllersKey, _popupControllers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    popupController.proxyView = self;
    
    if (_popupControllers.count > 0) {
        [_popupControllers sortUsingComparator:^NSComparisonResult(YYUIPopupController *obj1, YYUIPopupController *obj2) {
            return obj1.windowLevel < obj2.windowLevel;
        }];
        
        if (popupController.windowLevel >= _popupControllers.lastObject.windowLevel) {
            [popupController addSubview];
        } else {
            for (YYUIPopupController *element in _popupControllers) {
                if (popupController.windowLevel < element.windowLevel) {
                    [popupController addSubviewBelow:element.maskView];
                    break;
                }
            }
        }
    } else {
        [popupController addSubview];
    }
    
    if (![_popupControllers containsObject:popupController]) {
        [_popupControllers addObject:popupController];
    }
    [popupController presentDuration:duration delay:delay options:options bounced:isBounced completion:completion];
}

- (void)yyui_dissmissPopupController:(YYUIPopupController *)popupController completion:(void (^)(void))completion {
    return [self yyui_dissmissPopupController:popupController duration:0.25 completion:completion];
}

- (void)yyui_dissmissPopupController:(YYUIPopupController *)popupController duration:(NSTimeInterval)duration completion:(void (^)(void))completion {
    return [self yyui_dissmissPopupController:popupController duration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut completion:completion];
}

- (void)yyui_dissmissPopupController:(YYUIPopupController *)popupController duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options completion:(void (^)(void))completion {
    NSMutableArray<YYUIPopupController *> *_popupControllers = objc_getAssociatedObject(self, UIViewYYUIPopupControllersKey);
    if (_popupControllers.count > 0) {
        [popupController dismissDuration:duration delay:delay options:options completion:completion];
        [_popupControllers removeObject:popupController];
        if (_popupControllers.count < 1) {
            objc_setAssociatedObject(self, UIViewYYUIPopupControllersKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}

@end


@implementation YYUIPopupController (Convenient)

- (UIWindow *)keyWindow {
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    if (window) return window;
    if (@available(iOS 13.0, *)) {
        return UIApplication.sharedApplication.windows.firstObject;
    } else {
        return UIApplication.sharedApplication.keyWindow;
    }
}

+ (void)dismissAllPopupControllers {
    NSMutableArray<YYUIPopupController *> *_popupControllers = objc_getAssociatedObject(self, UIViewYYUIPopupControllersKey);
    if (_popupControllers) {
        for (YYUIPopupController *popupController in _popupControllers) {
            [popupController dismissWithDuration:0.0 completion:NULL];
        }
    }
}

+ (void)dismissAllPopupControllersForLevel:(NSUInteger)levels {
    NSMutableArray<YYUIPopupController *> *_popupControllers = objc_getAssociatedObject(self, UIViewYYUIPopupControllersKey);
    if (_popupControllers) {
        for (YYUIPopupController *popupController in _popupControllers) {
            if (levels & popupController.windowLevel) {
                [popupController dismissWithDuration:0.0 completion:NULL];
            }
        }
    }
}

+ (void)dismissPopupControllerForView:(UIView *)view animated:(BOOL)animated {
    YYUIPopupController *popupController = view.yyui_popupController;
    if (popupController) {
        [popupController dismissWithDuration:animated ? 0.25 : 0.0 completion:NULL];
    }
}

+ (void)dismissSuperPopupControllerIn:(UIView *)view animated:(BOOL)animated {
    UIView *aView = view;
    while (aView) {
        YYUIPopupController *popupController = view.yyui_popupController;
        if (popupController) {
            [popupController dismissWithDuration:animated ? 0.25 : 0.0 completion:NULL];
            break;
        }
        aView = aView.superview;
    }
}

- (void)show {
    return [self.keyWindow yyui_presentPopupController:self completion:NULL];
}

- (void)showWithDuration:(NSTimeInterval)duration {
    return [self.keyWindow yyui_presentPopupController:self duration:duration completion:NULL];
}

- (void)showWithDuration:(NSTimeInterval)duration completion:(void (^)(void))completion {
    return [self.keyWindow yyui_presentPopupController:self duration:duration completion:completion];
}

- (void)showInView:(UIView *)view completion:(void (^)(void))completion {
    return [view yyui_presentPopupController:self completion:completion];
}

- (void)showInView:(UIView *)view duration:(NSTimeInterval)duration completion:(void (^)(void))completion {
    return [view yyui_presentPopupController:self duration:duration completion:completion];
}

- (void)showInView:(UIView *)view duration:(NSTimeInterval)duration bounced:(BOOL)bounced completion:(void (^)(void))completion {
    return [view yyui_presentPopupController:self duration:duration bounced:bounced completion:completion];
}

- (void)showInView:(UIView *)view duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options bounced:(BOOL)bounced completion:(void (^)(void))completion {
    return [view yyui_presentPopupController:self duration:duration delay:delay options:options bounced:bounced completion:completion];
}

- (void)dismiss {
    return [self.proxyView yyui_dissmissPopupController:self completion:NULL];
}

- (void)dismissWithDuration:(NSTimeInterval)duration completion:(void (^)(void))completion {
    return [self.proxyView yyui_dissmissPopupController:self completion:completion];
}

- (void)dismissWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options completion:(void (^)(void))completion {
    return [self.proxyView yyui_dissmissPopupController:self duration:duration delay:delay options:options completion:completion];
}

- (void)setNeedLayout {
    [_view setNeedsLayout];
    _maskView.frame = self.proxyView.bounds;
    _view.center = [self finalCenter];
}

@end
