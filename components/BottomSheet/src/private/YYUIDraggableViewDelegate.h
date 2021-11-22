//
//  YYUIDraggableViewDelegate.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/22.
//

#import <UIKit/UIKit.h>

@class YYUIDraggableView;

/**
 * Delegate protocol to control when dragging should be allowed and to respond to dragging events.
 */
@protocol YYUIDraggableViewDelegate <NSObject>

/**
 * Allows the delegate to specify a maximum threshold height that the view cannot be dragged above.
 * @param view The draggable view.
 * @return The maximum height this view can be dragged to be.
 */
- (CGFloat)maximumHeightForDraggableView:(nonnull YYUIDraggableView *)view;

/**
 * Called when an attempt is made to drag the view up or down.
 * @return NO to prevent a new drag from starting.
 * @param view The draggable view.
 * @param velocity The current velocity of the drag gesture. This only contains a vertical
 *   component.
 */
- (BOOL)draggableView:(nonnull YYUIDraggableView *)view
    shouldBeginDraggingWithVelocity:(CGPoint)velocity;

/**
 * Called when a new drag starts.
 * @param view The draggable view.
 */
- (void)draggableViewBeganDragging:(nonnull YYUIDraggableView *)view;

/**
 * Called when a drag ends.
 * @param view The draggable view.
 * @param velocity The current velocity of the drag gesture. This only contains a vertical
 *   component.
 */
- (void)draggableView:(nonnull YYUIDraggableView *)view draggingEndedWithVelocity:(CGPoint)velocity;

- (void)draggableView:(nonnull YYUIDraggableView *)view didPanToOffset:(CGFloat)offset;

@end
