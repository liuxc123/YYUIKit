//
//  YYUICornerTreatment.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import <UIKit/UIKit.h>

@class YYUIPathGenerator;

/**
 This enum consists of the different types of shape values that can be provided.
 
 - YYUICornerTreatmentValueTypeAbsolute: If an absolute corner value is provided.
 - YYUICornerTreatmentValueTypePercentage: If a relative corner value is provided.
 
 See YYUIShapeCorner's @c size property for additional details.
 */
typedef NS_ENUM(NSInteger, YYUICornerTreatmentValueType) {
    YYUICornerTreatmentValueTypeAbsolute,
    YYUICornerTreatmentValueTypePercentage,
};

/**
 YYUICornerTreatment is a factory for creating YYUIPathGenerators that represent
 the path of a corner.
 
 YYUICornerTreatments should only generate corners in the top-left quadrant (i.e.
 the top-left corner of a rectangle). YYUIShapeModel will translate the generated
 YYUIPathGenerator to the expected position and rotation.
 */
@interface YYUICornerTreatment : NSObject <NSCopying>

/**
 The value type of our corner treatment.
 
 When YYUICornerTreatmentValueType is YYUICornerTreatmentValueTypeAbsolute, then the accepted corner
 values are an absolute size.
 When YYUIShapeSizeType is YYUICornerTreatmentValueTypePercentage, values are expected to be in the
 range of 0 to 1 (0% - 100%). These values are percentages based on the height of the surface.
 */
@property(assign, nonatomic) YYUICornerTreatmentValueType valueType;

- (nonnull instancetype)init NS_DESIGNATED_INITIALIZER;

/**
 Creates an YYUIPathGenerator object for a corner with the provided angle.
 
 @param angle The internal angle of the corner in radians. Typically M_PI/2.
 */
- (nonnull YYUIPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)angle;

/**
 Creates an YYUIPathGenerator object for a corner with the provided angle.
 Given that the provided valueType is YYUICornerTreatmentValueTypePercentage, we also need
 the size of the view to calculate the corner size percentage relative to the view height.
 
 @param angle the internal angle of the corner in radius. Typically M_PI/2.
 @param size the size of the view.
 @return returns an YYUIPathGenerator.
 */
- (nonnull YYUIPathGenerator *)pathGeneratorForCornerWithAngle:(CGFloat)angle
                                                   forViewSize:(CGSize)size;

@end

