//
//  YYUIElevationOverriding.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/17.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

/**
 Provides APIs for @c UIViews to communicate their elevation throughout the view hierarchy.
 */
@protocol YYUIElevationOverriding

/**
 Used by @c YYUIElevationResponding instead of @c yyui_baseElevation.

 This can be used in cases where there is elevation behind an object that is not part of the
 view hierarchy, like a @c UIPresentationController.

 Note: If set to a negative value, this property is ignored as part of the @c yyui_baseElevation
 calculation.
 */
@property(nonatomic, assign, readwrite) CGFloat yyui_overrideBaseElevation;

@end
