//
//  UIViewController+YYBottomSheet.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/22.
//

#import <UIKit/UIKit.h>

@class YYUIBottomSheetPresentationController;

/**
 Material Dialog UIViewController Category
 */
@interface UIViewController (YYBottomSheet)

/**
 The Material bottom sheet presentation controller that is managing the current view controller.

 @return nil if the view controller is not managed by a Material bottom sheet presentation
 controller.
 */
@property(nonatomic, nullable, readonly)
    YYUIBottomSheetPresentationController *yyui_bottomSheetPresentationController;

@end
