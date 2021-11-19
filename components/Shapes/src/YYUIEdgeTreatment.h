//
//  YYUIEdgeTreatment.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import <UIKit/UIKit.h>

@class YYUIPathGenerator;

/**
 YYUIEdgeTreatment is a factory for creating YYUIPathGenerators that represent the
 path of a edge.

 YYUIEdgeTreaments only generate in the top quadrant (i.e. the top edge of a
 rectangle). YYUIShapeModel will transform the generated YYUIPathGenerator to the
 expected position and rotation.
 */
@interface YYUIEdgeTreatment : NSObject <NSCopying>

- (nonnull instancetype)init NS_DESIGNATED_INITIALIZER;

/**
 Generates an YYUIPathGenerator object for an edge with the provided length.

 @param length The length of the edge.
 */
- (nonnull YYUIPathGenerator *)pathGeneratorForEdgeWithLength:(CGFloat)length;

@end
