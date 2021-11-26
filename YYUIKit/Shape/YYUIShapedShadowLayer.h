//
//  YYUIShapedShadowLayer.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import <QuartzCore/QuartzCore.h>

#import "YYUIShadowLayer.h"

@protocol YYUIShapeGenerating;

/*
 A shaped and Material-shadowed layer.
 */
@interface YYUIShapedShadowLayer : YYUIShadowLayer

/*
 Sets the shaped background color of the layer.

 Use shapedBackgroundColor instead of backgroundColor to ensure the background appears correct with
 or without a valid shape.

 @note If you set shapedBackgroundColor, you should not manually write to backgroundColor or
 fillColor.
 */
@property(nonatomic, copy, nullable) UIColor *shapedBackgroundColor;

/*
 Sets the shaped border color of the layer.

 Use shapedBorderColor instead of borderColor to ensure the border appears correct with or without
 a valid shape.

 @note If you set shapedBorderColor, you should not manually write to borderColor.
 */
@property(nonatomic, copy, nullable) UIColor *shapedBorderColor;

/*
 Sets the shaped border width of the layer.

 Use shapedBorderWidth instead of borderWidth to ensure the border appears correct with or without
 a valid shape.

 @note If you set shapedBorderWidth, you should not manually write to borderWidth.
 */
@property(nonatomic, assign) CGFloat shapedBorderWidth;

/*
 The YYUIShapeGenerating object used to set the shape's path and shadow path.

 The path will be set upon assignment of this property and whenever layoutSublayers is called.
 */
@property(nonatomic, strong, nullable) id<YYUIShapeGenerating> shapeGenerator;

/*
 The created CAShapeLayer representing the generated shape path for the implementing UIView
 from the shapeGenerator.

 This layer is exposed to easily mask subviews of the implementing UIView so they won't spill
 outside the layer to fit the bounds.
 */
@property(nonatomic, strong, nonnull) CAShapeLayer *shapeLayer;

/*
 A sublayer of @c shapeLayer that is responsible for the background color of the shape layer.

 The colorLayer imitates the path of shapeLayer and is added as a sublayer. It is updated when
 shapedBackgroundColor is set on the layer.
 */
@property(nonatomic, strong, nonnull) CAShapeLayer *colorLayer;

@end

