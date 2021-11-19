//
//  YYUICornerTreatment+CornerTypeInitalizer.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import "YYShapes.h"

#import "YYUICurvedCornerTreatment.h"
#import "YYUICutCornerTreatment.h"
#import "YYUIRoundedCornerTreatment.h"

@interface YYUICornerTreatment (CornerTypeInitalizer)

/**
 Initialize and return an YYUICornerTreatment as an YYUIRoundedCornerTreatment.
 
 @param value The radius to set the rounded corner to.
 @return an YYUIRoundedCornerTreatment.
 */
+ (YYUIRoundedCornerTreatment *)cornerWithRadius:(CGFloat)value;

/**
 Initialize and return an YYUICornerTreatment as an YYUIRoundedCornerTreatment.
 
 @param value The radius to set the rounded corner to.
 @param valueType The value type in which the value is set as. It can be sent either as an
 absolute value, or a percentage value (0.0 - 1.0) of the height of the surface.
 @return an YYUIRoundedCornerTreatment.
 */
+ (YYUIRoundedCornerTreatment *)cornerWithRadius:(CGFloat)value
                                       valueType:(YYUICornerTreatmentValueType)valueType;

/**
 Initialize and return an YYUICornerTreatment as an YYUICutCornerTreatment.
 
 @param value The cut to set the cut corner to.
 @return an YYUICutCornerTreatment.
 */
+ (YYUICutCornerTreatment *)cornerWithCut:(CGFloat)value;

/**
 Initialize and return an YYUICornerTreatment as an YYUIRoundedCornerTreatment.
 
 @param value The cut to set the cut corner to.
 @param valueType The value type in which the value is set as. It can be sent either as an
 absolute value, or a percentage value (0.0 - 1.0) of the height of the surface.
 @return an YYUICutCornerTreatment.
 */
+ (YYUICutCornerTreatment *)cornerWithCut:(CGFloat)value
                                valueType:(YYUICornerTreatmentValueType)valueType;

/**
 Initialize and return an YYUICornerTreatment as an YYUICurvedCornerTreatment.
 
 @param value The size to set the curved corner to.
 @return an YYUICurvedCornerTreatment.
 */
+ (YYUICurvedCornerTreatment *)cornerWithCurve:(CGSize)value;

/**
 Initialize and return an YYUICornerTreatment as an YYUICurvedCornerTreatment.
 
 @param value The curve to set the curved corner to.
 @param valueType The value type in which the value is set as. It can be sent either as an
 absolute value, or a percentage value (0.0 - 1.0) of the height of the surface.
 @return an YYUICurvedCornerTreatment.
 */
+ (YYUICurvedCornerTreatment *)cornerWithCurve:(CGSize)value
                                     valueType:(YYUICornerTreatmentValueType)valueType;

@end

