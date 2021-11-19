//
//  YYUICurvedRectShapeGenerator.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

#import "YYShapes.h"

/**
 A curved rectangle shape generator.
 */
@interface YYUICurvedRectShapeGenerator : NSObject <YYUIShapeGenerating>

/**
 The size of the curved corner.
 */
@property(nonatomic, assign) CGSize cornerSize;

/**
 Initializes an YYUICurvedRectShapeGenerator instance with a given cornerSize.
 */
- (instancetype)initWithCornerSize:(CGSize)cornerSize NS_DESIGNATED_INITIALIZER;

@end
