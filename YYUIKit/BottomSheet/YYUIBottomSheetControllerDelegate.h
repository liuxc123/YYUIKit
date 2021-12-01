//
//  YYUIBottomSheetControllerDelegate.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/22.
//

#import <UIKit/UIKit.h>

#import "YYUIBottomSheetState.h"

@class YYUIBottomSheetController;

/**
 Delegate for YYUIBottomSheetController.
 */
@protocol YYUIBottomSheetControllerDelegate <NSObject>
@optional
/**
 Called when the user taps the dimmed background or swipes the bottom sheet off to dismiss the
 bottom sheet. Also called with accessibility escape "two finger Z" gestures.

 This method is not called if the bottom sheet is dismissed programatically.

 @param controller The YYUIBottomSheetController that was dismissed.
 */
- (void)bottomSheetControllerDidDismissBottomSheet:(nonnull YYUIBottomSheetController *)controller;

/**
 Called when the state of the bottom sheet changes.

 Note: See what states the sheet can transition to by looking at YYUIBottomSheetState.

 @param controller The YYUIBottomSheetController that its state changed.
 @param state The state the sheet changed to.
 */
- (void)bottomSheetControllerStateChanged:(nonnull YYUIBottomSheetController *)controller
                                    state:(YYUIBottomSheetState)state;

/**
 Called when the Y offset of the sheet's changes in relation to the top of the screen.

 @param controller The YYUIBottomSheetController that its Y offset changed.
 @param yOffset The Y offset the bottom sheet changed to.
 */
- (void)bottomSheetControllerDidChangeYOffset:(nonnull YYUIBottomSheetController *)controller
                                      yOffset:(CGFloat)yOffset;
@end

