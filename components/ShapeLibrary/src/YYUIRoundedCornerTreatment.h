//
//  YYUIRoundedCornerTreatment.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import <CoreGraphics/CoreGraphics.h>

#import "YYShapes.h"

/**
 A rounded corner treatment.
 */
@interface YYUIRoundedCornerTreatment : YYUICornerTreatment

/**
 The radius of the corner.
 */
@property(nonatomic, assign) CGFloat radius;

/**
 Initializes an YYUIRoundedCornerTreatment instance with a given radius.
 */
- (nonnull instancetype)initWithRadius:(CGFloat)radius NS_DESIGNATED_INITIALIZER;

/**
 Initializes an YYUIRoundedCornerTreatment instance with a radius of zero.
 */
- (nonnull instancetype)init;

@end
