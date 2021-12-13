//
//  YYUIActivityIndicatorView.h
//  YYUIKit
//
//  Created by liuxc on 2021/12/13.
//

#import <UIKit/UIKit.h>
#import "YYUIActivityIndicatorAnimationProtocol.h"
#import "YYUIEmptyViewLoadingViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YYUIActivityIndicatorAnimationType) {
    YYUIActivityIndicatorAnimationTypeNineDots,
    YYUIActivityIndicatorAnimationTypeTriplePulse,
    YYUIActivityIndicatorAnimationTypeFiveDots,
    YYUIActivityIndicatorAnimationTypeRotatingSquares,
    YYUIActivityIndicatorAnimationTypeDoubleBounce,
    YYUIActivityIndicatorAnimationTypeRippleAnimation,
    YYUIActivityIndicatorAnimationTypeTwoDots,
    YYUIActivityIndicatorAnimationTypeThreeDots,
    YYUIActivityIndicatorAnimationTypeBallPulse,
    YYUIActivityIndicatorAnimationTypeBallClipRotate,
    YYUIActivityIndicatorAnimationTypeBallClipRotatePulse,
    YYUIActivityIndicatorAnimationTypeBallClipRotateMultiple,
    YYUIActivityIndicatorAnimationTypeBallRotate,
    YYUIActivityIndicatorAnimationTypeBallZigZag,
    YYUIActivityIndicatorAnimationTypeBallZigZagDeflect,
    YYUIActivityIndicatorAnimationTypeBallTrianglePath,
    YYUIActivityIndicatorAnimationTypeBallScale,
    YYUIActivityIndicatorAnimationTypeLineScale,
    YYUIActivityIndicatorAnimationTypeLineScaleParty,
    YYUIActivityIndicatorAnimationTypeBallScaleMultiple,
    YYUIActivityIndicatorAnimationTypeBallPulseSync,
    YYUIActivityIndicatorAnimationTypeBallBeat,
    YYUIActivityIndicatorAnimationType3DotsFadeAnimation,
    YYUIActivityIndicatorAnimationTypeLineScalePulseOut,
    YYUIActivityIndicatorAnimationTypeLineScalePulseOutRapid,
    YYUIActivityIndicatorAnimationTypeLineJumpUpAndDownAnimation,
    YYUIActivityIndicatorAnimationTypeBallScaleRipple,
    YYUIActivityIndicatorAnimationTypeBallScaleRippleMultiple,
    YYUIActivityIndicatorAnimationTypeTriangleSkewSpin,
    YYUIActivityIndicatorAnimationTypeBallGridBeat,
    YYUIActivityIndicatorAnimationTypeBallGridPulse,
    YYUIActivityIndicatorAnimationTypeRotatingSandglass,
    YYUIActivityIndicatorAnimationTypeRotatingTrigons,
    YYUIActivityIndicatorAnimationTypeTripleRings,
    YYUIActivityIndicatorAnimationTypeCookieTerminator,
    YYUIActivityIndicatorAnimationTypeBallSpinFadeLoader,
    YYUIActivityIndicatorAnimationTypeBallLoopScale,
    YYUIActivityIndicatorAnimationTypeExchangePosition,
    YYUIActivityIndicatorAnimationTypeRotaingCurveEaseOut,
    YYUIActivityIndicatorAnimationTypeLoadingSuccess,
    YYUIActivityIndicatorAnimationTypeLoadingFail,
    YYUIActivityIndicatorAnimationTypeBallRotaingAroundBall,
};

@interface YYUIActivityIndicatorView : UIView <YYUIEmptyViewLoadingViewProtocol>

- (id)initWithType:(YYUIActivityIndicatorAnimationType)type;
- (id)initWithType:(YYUIActivityIndicatorAnimationType)type tintColor:(UIColor *)tintColor;
- (id)initWithType:(YYUIActivityIndicatorAnimationType)type tintColor:(UIColor *)tintColor size:(CGFloat)size;

@property (nonatomic) YYUIActivityIndicatorAnimationType type;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic) CGFloat size;

@property (nonatomic, readonly) BOOL animating;

+ (id<YYUIActivityIndicatorAnimationProtocol>)activityIndicatorAnimationForAnimationType:(YYUIActivityIndicatorAnimationType)type;

- (void)startAnimating;
- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
