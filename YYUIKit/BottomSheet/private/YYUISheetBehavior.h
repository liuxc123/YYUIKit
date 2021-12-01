//
//  YYUISheetBehavior.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/22.
//

#import <UIKit/UIKit.h>

@interface YYUISheetBehavior : UIDynamicBehavior

/**
 * The final center-point for the item to arrive at.
 */
@property(nonatomic) CGPoint targetPoint;

/**
 * The initial velocity for the behavior.
 */
@property(nonatomic) CGPoint velocity;

/**
 * Initializes a @c YYUISheetBehavior.
 * @param item The dynamic item (a view) to apply the sheet behavior to.
 * @param simulateScrollViewBounce If the user has specified that they do not want to simulate the
 * scrollview bouncing in the absence of a bottom sheet's trackingScrollView we should also tone
 * down the bounce effect the UIKit dynamics provide.
 */
- (nonnull instancetype)initWithItem:(nonnull id<UIDynamicItem>)item
            simulateScrollViewBounce:(BOOL)simulateScrollViewBounce NS_DESIGNATED_INITIALIZER;

- (nonnull instancetype)init NS_UNAVAILABLE;

@end

