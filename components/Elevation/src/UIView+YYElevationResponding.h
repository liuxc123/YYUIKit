//
//  UIView+YYElevationResponding.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/17.
//

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

/**
 Allows elevation changes to propagate down the view hierarchy and allows objects conforming to
 @c YYUIElevatable to react to those changes accordingly.
 */
@interface UIView (YYElevationResponding)

/**
 Returns the sum of all @c yyui_currentElevation of the superviews going up the view hierarchy
 recursively.

 If a view in the hierarchy conforms to @c YYUIElevationOveriding and  @c yyui_overrideBaseElevation
 is non-negative, then  the sum of the current total plus the value of @c yyui_overrideBaseElevation
 is returned.

 If a @c UIViewController conforms to @c YYUIElevatable or @c YYUIElevationOveriding then its @c view
 will report the view controllers base elevation.
 */
@property(nonatomic, assign, readonly) CGFloat yyui_baseElevation;

/**
 Returns the sum of the view's @c yyui_currentElevation with the @c yyui_currentElevation of its
 superviews going up the view hierarchy recursively.

 This value is effectively the sum of @c yyui_baseElevation and @c yyui_currentElevation.
 */
@property(nonatomic, assign, readonly) CGFloat yyui_absoluteElevation;

/**
 Should be called when the view's @c yyui_currentElevation has changed. Will be called on the
 receiver's @c subviews.

 If a @c UIView views conform to @c YYUIElevation then @c yyui_elevationDidChangeBlock: is called.
 */
- (void)yyui_elevationDidChange;

@end

