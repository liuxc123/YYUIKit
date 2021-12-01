//
//  YYUIBottomSheetPresentationControllerDelegate.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/22.
//

#import <UIKit/UIKit.h>

@class YYUIBottomSheetPresentationController;

/**
 Delegate for YYUIBottomSheetPresentationController.
 */
@protocol YYUIBottomSheetPresentationControllerDelegate <UIAdaptivePresentationControllerDelegate>
@optional

/**
 Called before the bottom sheet is presented.

 @param bottomSheet The YYUIBottomSheetPresentationController being presented.
 */
- (void)prepareForBottomSheetPresentation:
    (nonnull YYUIBottomSheetPresentationController *)bottomSheet;

/**
 Invoked immediately after @c dismissViewControllerAnimated:completed: is passed to the
 presentingController. The bottom sheet controller calls this method only in response to user
 actions such as tapping the background or dragging the sheet offscreen. This method is not called
 if the bottom sheet is dismissed programmatically.

 @param bottomSheet The @c YYUIBottomSheetPresentationController that was dismissed.
 */
- (void)bottomSheetPresentationControllerDidDismissBottomSheet:
    (nonnull YYUIBottomSheetPresentationController *)bottomSheet;

/**
 Informs the delegate that the bottom sheet has completed animating offscreen. As with
 @c bottomSheetPresentationControllerDidDismissBottomSheet, this method is not called if the bottom
 sheet is dismissed programmatically.

 @param bottomSheet The @c YYUIBottomSheetPresentationController that was dismissed.
 */
- (void)bottomSheetPresentationControllerDismissalAnimationCompleted:
    (nonnull YYUIBottomSheetPresentationController *)bottomSheet;

/**
 Called when the state of the bottom sheet changes.

 Note: See what states the sheet can transition to by looking at YYUIBottomSheetState.

 @param bottomSheet The YYUIBottomSheetPresentationController that its state changed.
 @param sheetState The state the sheet changed to.
 */
- (void)bottomSheetWillChangeState:(nonnull YYUIBottomSheetPresentationController *)bottomSheet
                        sheetState:(YYUIBottomSheetState)sheetState;

/**
 Called when the Y offset of the sheet's changes in relation to the top of the screen.

 @param bottomSheet The YYUIBottomSheetPresentationController that its Y offset changed.
 @param yOffset The Y offset the bottom sheet changed to.
 */
- (void)bottomSheetDidChangeYOffset:(nonnull YYUIBottomSheetPresentationController *)bottomSheet
                            yOffset:(CGFloat)yOffset;
@end
