//
//  YYUIBottomSheetController.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/22.
//

#import <UIKit/UIKit.h>
// TODO(b/151929968): Delete import of YYUIBottomSheetControllerDelegate.h when client code has been
// migrated to no longer import YYUIBottomSheetControllerDelegate as a transitive dependency.
#import "YYUIBottomSheetControllerDelegate.h"
#import "YYUISheetState.h"
#import "YYElevation.h"
#import "YYShapes.h"

@protocol YYUIBottomSheetControllerDelegate;

/**
 A view controller for presenting other view controllers as bottom sheets.

 https://material.io/go/design-sheets-bottom

 Show a bottom sheet by creating an YYUIBottomSheetController instance with a contentViewController
 and presenting it with -[UIViewController presentViewController:animated:completion].
 YYUIBottomSheetController automatically sets the appropriate presentation style and
 transitioningDelegate for the bottom sheet behavior.
 */
@interface YYUIBottomSheetController : UIViewController <YYUIElevatable, YYUIElevationOverriding>

/**
 The view controller being presented as a bottom sheet.
 */
@property(nonatomic, strong, nonnull, readonly) UIViewController *contentViewController;

/**
 Interactions with the tracking scroll view will affect the bottom sheet's drag behavior.

 If no trackingScrollView is provided, then one will be inferred from the associated view
 controller.

 Changes to this value will be ignored after the bottom sheet controller has been presented.
 */
@property(nonatomic, weak, nullable) UIScrollView *trackingScrollView;

/**
 This property determines if @c showFlashIndicators is called by default when @c
 YYUIBottomSheetController calls @c viewDidAppear.

 @note Defaults to @c NO.
 */
@property(nonatomic, assign) BOOL shouldFlashScrollIndicatorsOnAppearance;

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
 A Boolean value that controls whether the height of the keyboard should affect
 the bottom sheet's frame when the keyboard shows on the screen.

 The default value is @c NO.
 */
@property(nonatomic) BOOL ignoreKeyboardHeight;

/**
 The color applied to the sheet's background when presented by YYUIBottomSheetPresentationController.

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
 The bottom sheet delegate.
 */
@property(nonatomic, weak, nullable) id<YYUIBottomSheetControllerDelegate> delegate;

/**
 The current state of the bottom sheet.
 */
@property(nonatomic, readonly) YYUISheetState state;

/**
 The elevation of the bottom sheet. Defaults to @c YYUIShadowElevationModalBottomSheet.
 */
@property(nonatomic, assign) CGFloat elevation;

/**
 Whether or not the height of the bottom sheet should adjust to include extra height for any bottom
 safe area insets. If, for example, this is set to @c YES, and the preferred content size height is
 100 and the screen has a bottom safe area inset of 10, the total height of the displayed bottom
 sheet height would be 110. If set to @c NO, the height would be 100.

 Defaults to @c YES.
 */
@property(nonatomic, assign) BOOL adjustHeightForSafeAreaInsets;

/**
 Bottom sheet controllers must be created with @c initWithContentViewController:.
 */
- (nonnull instancetype)init NS_UNAVAILABLE;

/**
 Initializes the controller with a content view controller.

 @param contentViewController The view controller to be presented as a bottom sheet.
 */
- (nonnull instancetype)initWithContentViewController:
    (nonnull UIViewController *)contentViewController;

/**
 Sets the shape generator for state that is used to define the bottom sheet's shape for that state.

 note: If a layer property is explicitly set after the shapeGenerator has been set,
 it can lead to unexpected behavior. As an example, changes to the view layer's properties such as
 cornerRadius, mask, or shadow properties are not advised when the shapeGenerator is set.

 When the shapeGenerator for a state is nil, YYUIBottomSheetController will use the default view's
 underlying layer (self.view.layer) with its default settings.

 @param shapeGenerator The shape generator holding the desired shape of the sheet.
 @param state The state of the bottom sheet.
 */
- (void)setShapeGenerator:(nullable id<YYUIShapeGenerating>)shapeGenerator
                 forState:(YYUISheetState)state;

/**
 Returns the shape generator for an YYUISheetState state.

 @param state The state of the bottom sheet
 @return the shape generator for the state given.
 */
- (nullable id<YYUIShapeGenerating>)shapeGeneratorForState:(YYUISheetState)state;

/**
 A block that is invoked when the @c YYUIBottomSheetController receives a call to @c
 traitCollectionDidChange:. The block is called after the call to the superclass.
 */
@property(nonatomic, copy, nullable) void (^traitCollectionDidChangeBlock)
    (YYUIBottomSheetController *_Nonnull bottomSheetController,
     UITraitCollection *_Nullable previousTraitCollection);

@end
