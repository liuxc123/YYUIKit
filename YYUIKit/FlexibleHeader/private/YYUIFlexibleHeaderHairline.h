//
//  YYUIFlexibleHeaderHairline.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 A hairline is a narrow line shown at the bottom edge of a Flexible Header.

 The hairline can be shown or hidden and its color can be customized.

 This class acts as a controller for a hairline view.
 */
__attribute__((objc_subclassing_restricted)) @interface YYUIFlexibleHeaderHairline : NSObject

/**
 Initializes the instance with a given container view.
 */
- (nonnull instancetype)initWithContainerView:(nonnull UIView *)containerView
    NS_DESIGNATED_INITIALIZER;

/**
 The container view to which the hairline should be added.

 Note: this is weak because it is common for the container view to own the hairline instance.
 */
@property(nonatomic, weak, nullable) UIView *containerView;

#pragma mark Configuration

/**
 A Boolean value that governs whether the hairline is hidden.

 Defaults to YES.
 */
@property(nonatomic) BOOL hidden;

/**
 The color of the hairline.

 Defaults to black.
 */
@property(nonatomic, strong, nonnull) UIColor *color;

#pragma mark Unavailable methods

- (nonnull instancetype)init NS_UNAVAILABLE;

@end
