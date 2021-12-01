//
//  UIViewController+YYUIBottomSheet.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/22.
//

#import "UIViewController+YYUIBottomSheet.h"

#import "YYUIBottomSheetPresentationController.h"

@implementation UIViewController (YYUIBottomSheet)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (YYUIBottomSheetPresentationController *)yyui_bottomSheetPresentationController {
  id presentationController = self.presentationController;
  if ([presentationController isKindOfClass:[YYUIBottomSheetPresentationController class]]) {
    return (YYUIBottomSheetPresentationController *)presentationController;
  }
#pragma clang diagnostic pop

  return nil;
}

@end
