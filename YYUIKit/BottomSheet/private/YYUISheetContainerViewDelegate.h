//
//  YYUISheetContainerViewDelegate.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/22.
//

#import <UIKit/UIKit.h>

@class YYUISheetContainerView;

@protocol YYUISheetContainerViewDelegate <NSObject>

- (void)sheetContainerViewDidHide:(nonnull YYUISheetContainerView *)containerView;
- (void)sheetContainerViewWillChangeState:(nonnull YYUISheetContainerView *)containerView
                               sheetState:(YYUIBottomSheetState)sheetState;
- (void)sheetContainerViewDidChangeYOffset:(nonnull YYUISheetContainerView *)containerView
                                   yOffset:(CGFloat)yOffset;

@end
