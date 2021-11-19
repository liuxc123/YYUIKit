//
//  YYUIOverlayObserverOverlay.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import <UIKit/UIKit.h>

#import "YYUIOverlayTransitioning.h"

/**
 Object representing a single overlay being displayed on screen.
 */
@interface YYUIOverlayObserverOverlay : NSObject <YYUIOverlay>

/**
 The unique identifier for the given overlay.
 */
@property(nonatomic, copy) NSString *identifier;

/**
 The frame of the overlay, in screen coordinates.
 */
@property(nonatomic, assign) CGRect frame;

@end
