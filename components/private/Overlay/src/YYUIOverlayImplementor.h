//
//  YYUIOverlayImplementor.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import <Foundation/Foundation.h>

/**
 These variables are intentionally static (even though this is a header file). We don't want
 various YYUIKit components to have to link in the overlay manager just to post overlay change
 notifications. Any implementors who import this file will get copies of the constants which can
 be used without linking the overlay component.
 */

/**
 Overlay implementors should post this notification when a change in overlay frame occurs.

 Use the keys below to define the features of the overlay transition.
 */
static NSString *const YYUIOverlayDidChangeNotification = @"YYUIOverlayDidChangeNotification";

/**
 The user info key indicating the identifier of the overlay.

 Should be an NSString unique to the component in question. Required.
 */
static NSString *const YYUIOverlayIdentifierKey = @"identifier";

/**
 The user info key indicating the frame of the overlay.

 Should only be present if the overlay is onscreen, otherwise omit this key. The value of the key is
 an NSValue containing a CGRect, in absolute screen coordinates (that is, in iOS 8's fixed
 coordinate space).
 */
static NSString *const YYUIOverlayFrameKey = @"frame";

/**
 The user info key indicating the duration of the overlay transition animation.

 Should be an NSNumber containing a NSTimeInterval.
 */
static NSString *const YYUIOverlayTransitionDurationKey = @"duration";

/**
 The user info key indicating the curve of the transition animation.

 Should be an NSNumber containing an NSInteger (UIViewAnimationCurve). If the duration is non-zero,
 either this key or the curve key should be present in the dictionary.
 */
static NSString *const YYUIOverlayTransitionCurveKey = @"curve";

/**
 The user info key indicating the timing function of the transition animation.
 Should be a CAMediaTimingFunction. If the duration is non-zero, either this key or the curve key
 should be present in the dictionary.
 */
static NSString *const YYUIOverlayTransitionTimingFunctionKey = @"timingFunction";

/**
 This key indicates that the given overlay change needs to animate immediately.

 Some animations, such as the iOS keyboard animation, need to run immediately (and cannot be
 coalesced). Should be an NSNumber containing a BOOL.
 */
static NSString *const YYUIOverlayTransitionImmediacyKey = @"runImmediately";

