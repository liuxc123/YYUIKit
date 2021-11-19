//
//  YYUIShadowLayer.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import <UIKit/UIKit.h>

/**
 Metrics of the Material shadow effect.

 These can be used if you require your own shadow implementation but want to match the material
 spec.
 */
@interface YYUIShadowMetrics : NSObject
@property(nonatomic, readonly) CGFloat topShadowRadius;
@property(nonatomic, readonly) CGSize topShadowOffset;
@property(nonatomic, readonly) float topShadowOpacity;
@property(nonatomic, readonly) CGFloat bottomShadowRadius;
@property(nonatomic, readonly) CGSize bottomShadowOffset;
@property(nonatomic, readonly) float bottomShadowOpacity;

/**
 The shadow metrics for manually creating shadows given an elevation.

 @param elevation The shadow's elevation in points.
 @return The shadow metrics.
 */
+ (nonnull YYUIShadowMetrics *)metricsWithElevation:(CGFloat)elevation;
@end

/**
 The Material shadow effect.

 Consider rasterizing your YYUIShadowLayer if your view will not generally be animating or
 changing size. If you need to animate a rasterized YYUIShadowLayer, disable rasterization first.

 For example, if self's layerClass is YYUIShadowLayer, you might introduce the following code:

     self.layer.shouldRasterize = YES;
     self.layer.rasterizationScale = [UIScreen mainScreen].scale;
 */
@interface YYUIShadowLayer : CALayer

/**
 The elevation of the layer in points.

 The higher the elevation, the more spread out the shadow is. This is distinct from the layer's
 zPosition which can be used to order overlapping layers, but will have no affect on the size of
 the shadow.

 Negative values act as if zero were specified.

 The default value is 0.
 */
@property(nonatomic, assign) CGFloat elevation;

/**
 Whether to apply the "cutout" shadow layer mask.

 If enabled, then a mask is created to ensure the interior, non-shadow part of the layer is visible.

 Default is YES. Not animatable.
 */
@property(nonatomic, getter=isShadowMaskEnabled, assign) BOOL shadowMaskEnabled;

/**
 Animates the layer's corner radius

 @note At the end of the animation the corner radius is set to your desired corner radius.

 @param cornerRadius The desired corner radius at the end of the animation
 @param timingFunction The timing function you desire for the animation
 @param duration The duration of the animation
 */
- (void)animateCornerRadius:(CGFloat)cornerRadius
         withTimingFunction:(nonnull CAMediaTimingFunction *)timingFunction
                   duration:(NSTimeInterval)duration;

@end

/**
 Subclasses can depend on YYUIShadowLayer implementing CALayerDelegate actionForLayer:forKey: in
 order to implicitly animate 'path' or 'shadowPath' on sublayers.
 */
@interface YYUIShadowLayer (Subclassing) <CALayerDelegate>

/**
 Override point.
 Called by the shadow layer before the instance lays out its sublayers.
 */
- (void)prepareShadowPath;

@end

