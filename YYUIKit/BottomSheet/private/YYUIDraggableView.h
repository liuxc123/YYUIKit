//
//  YYUIDraggableView.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/22.
//

#import <UIKit/UIKit.h>

@protocol YYUIDraggableViewDelegate;

@interface YYUIDraggableView : UIView

/**
 * The @c UIScrollView passed in the initializer.
 */
@property(nonatomic, strong, readonly, nullable) UIScrollView *scrollView;

/**
 When @c scrollView is @c nil , the draggable view simulates the @c UIScrollView bouncing effect.
 When this property is set to @c NO, the simulated bouncing effect is turned off.  When  @c
 scrollView is not @c nil, this property doesn't do anything.
 */
@property(nonatomic, assign) BOOL simulateScrollViewBounce;

/**
 * Delegate for handling drag events.
 */
@property(nonatomic, weak, nullable) id<YYUIDraggableViewDelegate> delegate;

/**
 * Initializes a YYUIDraggableView.
 *
 * @param frame Initial frame for the view.
 * @param scrollView A @c UIScrollView contained as a subview of this view. The view will block
 *  scrolling of the content in the scrollview when it is being drag-resized. This can be nil.
 */
- (nonnull instancetype)initWithFrame:(CGRect)frame
                           scrollView:(nullable UIScrollView *)scrollView NS_DESIGNATED_INITIALIZER;

- (nonnull instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(nullable NSCoder *)aDecoder NS_UNAVAILABLE;

@end
