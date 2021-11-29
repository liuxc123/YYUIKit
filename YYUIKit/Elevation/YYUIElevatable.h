//
//  YYUIElevatable.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/17.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

/**
 Provides APIs for @c UIViews to communicate their elevation throughout the view hierarchy.
 */
@protocol YYUIElevatable <NSObject>

/**
 The current elevation of the conforming @c UIView.
 */
@property(nonatomic, assign, readonly) CGFloat yyui_currentElevation;

/**
 This block is called when the elevation changes for the conforming @c UIView or @c UIViewController
 receiver or one of its direct ancestors in the view hierarchy.

 Use this block to respond to elevation changes in the view or its ancestor views.

 @param absoluteElevation The @c yyui_currentElevation plus the @c yyui_currentElevation of all
 ancestor views. This equates to @c yyui_absoluteElevation of the UIView+YYElevationResponding
 category.
 @param object The receiver (self) which conforms to the protocol.
 */
@property(nonatomic, copy, nullable) void (^yyui_elevationDidChangeBlock)
    (id<YYUIElevatable> _Nonnull object, CGFloat absoluteElevation);

@end
