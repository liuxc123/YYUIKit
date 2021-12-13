//
//  YYUIActivityIndicatorView.m
//  YYUIKit
//
//  Created by liuxc on 2021/12/13.
//

#import "YYUIActivityIndicatorView.h"

#import "YYUIActivityIndicatorNineDotsAnimation.h"
#import "YYUIActivityIndicatorTriplePulseAnimation.h"
#import "YYUIActivityIndicatorFiveDotsAnimation.h"
#import "YYUIActivityIndicatorRotatingSquaresAnimation.h"
#import "YYUIActivityIndicatorDoubleBounceAnimation.h"
#import "YYUIActivityIndicatorRippleAnimation.h"
#import "YYUIActivityIndicatorTwoDotsAnimation.h"
#import "YYUIActivityIndicatorThreeDotsAnimation.h"
#import "YYUIActivityIndicatorBallPulseAnimation.h"
#import "YYUIActivityIndicatorBallClipRotateAnimation.h"
#import "YYUIActivityIndicatorBallClipRotatePulseAnimation.h"
#import "YYUIActivityIndicatorBallClipRotateMultipleAnimation.h"
#import "YYUIActivityIndicatorBallRotateAnimation.h"
#import "YYUIActivityIndicatorBallZigZagAnimation.h"
#import "YYUIActivityIndicatorBallZigZagDeflectAnimation.h"
#import "YYUIActivityIndicatorBallTrianglePathAnimation.h"
#import "YYUIActivityIndicatorBallScaleAnimation.h"
#import "YYUIActivityIndicatorLineScaleAnimation.h"
#import "YYUIActivityIndicatorLineScalePartyAnimation.h"
#import "YYUIActivityIndicatorBallScaleMultipleAnimation.h"
#import "YYUIActivityIndicatorBallPulseSyncAnimation.h"
#import "YYUIActivityIndicatorBallBeatAnimation.h"
#import "YYUIActivityIndicatorLineScalePulseOutAnimation.h"
#import "YYUIActivityIndicatorLineScalePulseOutRapidAnimation.h"
#import "YYUIActivityIndicatorLineJumpUpAndDownAnimation.h"
#import "YYUIActivityIndicatorBallScaleRippleAnimation.h"
#import "YYUIActivityIndicatorBallScaleRippleMultipleAnimation.h"
#import "YYUIActivityIndicatorTriangleSkewSpinAnimation.h"
#import "YYUIActivityIndicatorBallGridBeatAnimation.h"
#import "YYUIActivityIndicatorBallGridPulseAnimation.h"
#import "YYUIActivityIndicatorRotatingSandglassAnimation.h"
#import "YYUIActivityIndicatorRotatingTrigonAnimation.h"
#import "YYUIActivityIndicatorTripleRingsAnimation.h"
#import "YYUIActivityIndicatorCookieTerminatorAnimation.h"
#import "YYUIActivityIndicatorBallSpinFadeLoader.h"
#import "YYUIActivityIndicatorBallLoopScaleAnimation.h"
#import "YYUIActivityIndicator3DotsExchangePositionAnimation.h"
#import "YYUIActivityIndicatorRotaingCurveEaseOutAnimation.h"
#import "YYUIActivityIndicatorLoadingSuccessAnimation.h"
#import "YYUIActivityIndicatorLoadingFailAnimation.h"
#import "YYUIActivityIndicatorBallRotaingAroundBallAnimation.h"
#import "YYUIActivityIndicator3DotsFadeAnimation.h"

static const CGFloat kYYUIActivityIndicatorDefaultSize = 40.0f;

@interface YYUIActivityIndicatorView ()

@end

@implementation YYUIActivityIndicatorView {
    CALayer *_animationLayer;
}

#pragma mark -
#pragma mark Constructors

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _tintColor = [UIColor whiteColor];
        _size = kYYUIActivityIndicatorDefaultSize;
        [self commonInit];
    }
    return self;
}

- (id)initWithType:(YYUIActivityIndicatorAnimationType)type {
    return [self initWithType:type tintColor:[UIColor whiteColor] size:kYYUIActivityIndicatorDefaultSize];
}

- (id)initWithType:(YYUIActivityIndicatorAnimationType)type tintColor:(UIColor *)tintColor {
    return [self initWithType:type tintColor:tintColor size:kYYUIActivityIndicatorDefaultSize];
}

- (id)initWithType:(YYUIActivityIndicatorAnimationType)type tintColor:(UIColor *)tintColor size:(CGFloat)size {
    self = [super init];
    if (self) {
        _type = type;
        _size = size;
        _tintColor = tintColor;
        [self commonInit];
    }
    return self;
}

#pragma mark -
#pragma mark Methods

- (void)commonInit {
    self.userInteractionEnabled = YES;
    self.hidden = YES;
    
    _animationLayer = [[CALayer alloc] init];
    _animationLayer.frame = self.layer.bounds;
    [self.layer addSublayer:_animationLayer];

    [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}

- (void)setupAnimation {
    _animationLayer.sublayers = nil;
    
    id<YYUIActivityIndicatorAnimationProtocol> animation = [YYUIActivityIndicatorView activityIndicatorAnimationForAnimationType:_type];
    
    if ([animation respondsToSelector:@selector(setupAnimationInLayer:withSize:tintColor:)]) {
        [animation setupAnimationInLayer:_animationLayer withSize:CGSizeMake(_size, _size) tintColor:_tintColor];
        _animationLayer.speed = 0.0f;
    }
}

- (void)startAnimating {
    if (!_animationLayer.sublayers) {
        [self setupAnimation];
    }
    self.hidden = NO;
    _animationLayer.speed = 1.0f;
    _animating = YES;
}

- (void)stopAnimating {
    _animationLayer.speed = 0.0f;
    _animating = NO;
    self.hidden = YES;
}

#pragma mark -
#pragma mark Setters

- (void)setType:(YYUIActivityIndicatorAnimationType)type {
    if (_type != type) {
        _type = type;
        
        [self setupAnimation];
    }
}

- (void)setSize:(CGFloat)size {
    if (_size != size) {
        _size = size;
        
        [self setupAnimation];
        [self invalidateIntrinsicContentSize];
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    if (![_tintColor isEqual:tintColor]) {
        _tintColor = tintColor;
        
        CGColorRef tintColorRef = tintColor.CGColor;
        for (CALayer *sublayer in _animationLayer.sublayers) {
            sublayer.backgroundColor = tintColorRef;
            
            if ([sublayer isKindOfClass:[CAShapeLayer class]]) {
                CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
                shapeLayer.strokeColor = tintColorRef;
                shapeLayer.fillColor = tintColorRef;
            }
        }
    }
}

#pragma mark -
#pragma mark Getters

+ (id<YYUIActivityIndicatorAnimationProtocol>)activityIndicatorAnimationForAnimationType:(YYUIActivityIndicatorAnimationType)type {
    switch (type) {
        case YYUIActivityIndicatorAnimationTypeNineDots:
            return [[YYUIActivityIndicatorNineDotsAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeTriplePulse:
            return [[YYUIActivityIndicatorTriplePulseAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeFiveDots:
            return [[YYUIActivityIndicatorFiveDotsAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeRotatingSquares:
            return [[YYUIActivityIndicatorRotatingSquaresAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeDoubleBounce:
            return [[YYUIActivityIndicatorDoubleBounceAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeRippleAnimation:
            return [[YYUIActivityIndicatorRippleAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeTwoDots:
            return [[YYUIActivityIndicatorTwoDotsAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeThreeDots:
            return [[YYUIActivityIndicatorThreeDotsAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeBallPulse:
            return [[YYUIActivityIndicatorBallPulseAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeBallClipRotate:
            return [[YYUIActivityIndicatorBallClipRotateAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeBallClipRotatePulse:
            return [[YYUIActivityIndicatorBallClipRotatePulseAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeBallClipRotateMultiple:
            return [[YYUIActivityIndicatorBallClipRotateMultipleAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeBallRotate:
            return [[YYUIActivityIndicatorBallRotateAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeBallZigZag:
            return [[YYUIActivityIndicatorBallZigZagAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeBallZigZagDeflect:
            return [[YYUIActivityIndicatorBallZigZagDeflectAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeBallTrianglePath:
            return [[YYUIActivityIndicatorBallTrianglePathAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeBallScale:
            return [[YYUIActivityIndicatorBallScaleAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeLineScale:
            return [[YYUIActivityIndicatorLineScaleAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeLineScaleParty:
            return [[YYUIActivityIndicatorLineScalePartyAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeBallScaleMultiple:
            return [[YYUIActivityIndicatorBallScaleMultipleAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeBallPulseSync:
            return [[YYUIActivityIndicatorBallPulseSyncAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeBallBeat:
            return [[YYUIActivityIndicatorBallBeatAnimation alloc] init];
        case YYUIActivityIndicatorAnimationType3DotsFadeAnimation:
            return [[YYUIActivityIndicator3DotsFadeAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeLineScalePulseOut:
            return [[YYUIActivityIndicatorLineScalePulseOutAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeLineScalePulseOutRapid:
            return [[YYUIActivityIndicatorLineScalePulseOutRapidAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeLineJumpUpAndDownAnimation:
            return [[YYUIActivityIndicatorLineJumpUpAndDownAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeBallScaleRipple:
            return [[YYUIActivityIndicatorBallScaleRippleAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeBallScaleRippleMultiple:
            return [[YYUIActivityIndicatorBallScaleRippleMultipleAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeTriangleSkewSpin:
            return [[YYUIActivityIndicatorTriangleSkewSpinAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeBallGridBeat:
            return [[YYUIActivityIndicatorBallGridBeatAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeBallGridPulse:
            return [[YYUIActivityIndicatorBallGridPulseAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeRotatingSandglass:
            return [[YYUIActivityIndicatorRotatingSandglassAnimation alloc]init];
        case YYUIActivityIndicatorAnimationTypeRotatingTrigons:
            return [[YYUIActivityIndicatorRotatingTrigonAnimation alloc]init];
        case YYUIActivityIndicatorAnimationTypeTripleRings:
            return [[YYUIActivityIndicatorTripleRingsAnimation alloc]init];
        case YYUIActivityIndicatorAnimationTypeCookieTerminator:
            return [[YYUIActivityIndicatorCookieTerminatorAnimation alloc]init];
        case YYUIActivityIndicatorAnimationTypeBallSpinFadeLoader:
            return [[YYUIActivityIndicatorBallSpinFadeLoader alloc] init];
        case YYUIActivityIndicatorAnimationTypeBallLoopScale:
            return [[YYUIActivityIndicatorBallLoopScaleAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeExchangePosition:
            return [[YYUIActivityIndicator3DotsExchangePositionAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeRotaingCurveEaseOut:
            return [[YYUIActivityIndicatorRotaingCurveEaseOutAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeLoadingSuccess:
            return [[YYUIActivityIndicatorLoadingSuccessAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeLoadingFail:
            return [[YYUIActivityIndicatorLoadingFailAnimation alloc] init];
        case YYUIActivityIndicatorAnimationTypeBallRotaingAroundBall:
            return [[YYUIActivityIndicatorBallRotaingAroundBallAnimation alloc] init];
            
    }
    return nil;
}

#pragma mark -
#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _animationLayer.frame = self.bounds;

    BOOL animating = _animating;

    if (animating)
        [self stopAnimating];

    [self setupAnimation];

    if (animating)
        [self startAnimating];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(_size, _size);
}

@end
