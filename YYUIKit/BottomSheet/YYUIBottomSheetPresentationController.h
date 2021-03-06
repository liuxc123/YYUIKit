//
//  YYUIBottomSheetPresentationController.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/22.
//

#import <UIKit/UIKit.h>
#import "YYUIBottomSheetController.h"
// TODO(b/151929968): Delete import of YYUIBottomSheetPresentationControllerDelegate.h when client
// code has been migrated to no longer import YYUIBottomSheetPresentationControllerDelegate as a
// transitive dependency.
#import "YYUIBottomSheetPresentationControllerDelegate.h"

@class YYUIBottomSheetPresentationController;
@protocol YYUIBottomSheetPresentationControllerDelegate;

/**
 A UIPresentationController for presenting a modal view controller as a bottom sheet.
 */
@interface YYUIBottomSheetPresentationController : UIPresentationController

/**
 Interactions with the tracking scroll view will affect the bottom sheet's drag behavior.

 If no trackingScrollView is provided, then one will be inferred from the associated view
 controller.
 */
@property(nonatomic, weak, nullable) UIScrollView *trackingScrollView;

/**
 When @c trackingScrollView is @c nil and this property is @ YES, the bottom sheet simulates the @c
 UIScrollView bouncing effect. When @c trackingScrollView is @c nil and this property is set to @c
 NO, the simulated bouncing effect is turned off. When  @c trackingScrollView is NOT @c nil, this
 property doesn't do anything.

 Defaults to @c YES.
 */
@property(nonatomic, assign) BOOL simulateScrollViewBounce;

/**
 A Boolean value that controls whether the height of the keyboard should affect
 the bottom sheet's frame when the keyboard shows on the screen.

 The default value is @c NO.
 */
@property(nonatomic) BOOL ignoreKeyboardHeight;

/**
 When set to false, the bottom sheet controller can't be dismissed by tapping outside of sheet area.
 */
@property(nonatomic, assign) BOOL dismissOnBackgroundTap;

/**
 When set to false, the bottom sheet controller can't be dismissed by dragging the sheet down.

 Defaults to @c YES.
 */
@property(nonatomic, assign) BOOL dismissOnDraggingDownSheet;

/**
 When this property is set to @c YES the YYUIBottomSheetController's @c safeAreaInsets are set as @c
 additionalSafeAreaInsets on the presented view controller. This property only works on iOS 11 and
 above.

 @note Defaults to @c NO.
 */
@property(nonatomic, assign) BOOL shouldPropagateSafeAreaInsetsToPresentedViewController;

/**
 This is used to set a custom height on the sheet view.

 @note If a positive value is passed then the sheet view will be that height even if
 perferredContentSize has been set. Otherwise the sheet will open up to half the screen height or
 the size of the presentedViewController's preferredContentSize whatever value is smaller.
 @note The preferredSheetHeight can never be taller than the height of the content, if the content
 is smaller than the value passed to preferredSheetHeight then the sheet view will be the size of
 the content height.
 */
@property(nonatomic, assign) CGFloat preferredSheetHeight;

/**
Whether or not the height of the bottom sheet should adjust to include extra height for any bottom
safe area insets. If, for example, this is set to @c YES, and the preferredSheetHeight is
100 and the screen has a bottom safe area inset of 10, the total height of the displayed bottom
sheet height would be 110. If set to @c NO, the height would be 100.

Defaults to @c YES.
*/
@property(nonatomic, assign) BOOL adjustHeightForSafeAreaInsets;

/**
 Customize the color of the background scrim.

 Defaults to a semi-transparent Black.
 */
@property(nonatomic, strong, nullable) UIColor *scrimColor;

/**
 If @c YES, then the dimmed scrim view will act as an accessibility element for dismissing the
 bottom sheet.

 Defaults to @c NO.
 */
@property(nonatomic, assign) BOOL isScrimAccessibilityElement;

/**
 The @c accessibilityLabel value of the dimmed scrim view.

 Defaults to @c nil.
 */
@property(nullable, nonatomic, copy) NSString *scrimAccessibilityLabel;

/**
 The @c accessibilityHint value of the dimmed scrim view.

 Defaults to @c nil.
 */
@property(nullable, nonatomic, copy) NSString *scrimAccessibilityHint;

/**
 The @c accessibilityTraits of the dimmed scrim view.

 Defaults to @c UIAccessibilityTraitButton.
 */
@property(nonatomic, assign) UIAccessibilityTraits scrimAccessibilityTraits;

/**
 Delegate to tell the presenter when to dismiss.
 */
@property(nonatomic, weak, nullable) id<YYUIBottomSheetPresentationControllerDelegate> delegate;

/**
 A block that is invoked when the @c YYUIBottomSheetPresentationController receives a call to @c
 traitCollectionDidChange:. The block is called after the call to the superclass.
 */
@property(nonatomic, copy, nullable) void (^traitCollectionDidChangeBlock)
    (YYUIBottomSheetPresentationController *_Nonnull bottomSheetPresentationController,
     UITraitCollection *_Nullable previousTraitCollection);

@end

