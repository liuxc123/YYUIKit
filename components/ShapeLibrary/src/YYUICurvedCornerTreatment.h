//
//  YYUICurvedCornerTreatment.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import <CoreGraphics/CoreGraphics.h>

#import "YYShapes.h"

/**
 A curved corner treatment. Distinct from YYUIRoundedCornerTreatment in that YYUIurvedCornerTreatment
 also supports asymmetric curved corners.
 */
@interface YYUICurvedCornerTreatment : YYUICornerTreatment

/**
 The size of the curve.
 */
@property(nonatomic, assign) CGSize size;

/**
 Initializes an YYUICurvedCornerTreatment instance with a given corner size.
 */
- (nonnull instancetype)initWithSize:(CGSize)size NS_DESIGNATED_INITIALIZER;

/**
 Initializes an YYUICurvedCornerTreatment instance with a corner size of zero.
 */
- (nonnull instancetype)init;

@end
