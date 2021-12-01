//
//  YYUIBottomSheetState.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/22.
//

#import <Foundation/Foundation.h>

/**
 The YYUIBottomSheetState enum provides the different possible states the bottom sheet can be in.
 There are currently 3 different states for the bottom sheet:
 
 - YYUIBottomSheetStateClosed: This state is reached when the bottom sheet is dragged down and is
 dismissed.
 - YYUIBottomSheetStatePreferred: This state is reached when the bottom sheet is half collapsed - when
 it visible but not in full screen. This state is also the default state for the sheet.
 - YYUIBottomSheetStateExtended: This state is reached when the sheet is expanded and is in full screen.
 */
typedef NS_ENUM(NSUInteger, YYUIBottomSheetState) {
    YYUIBottomSheetStateClosed,
    YYUIBottomSheetStatePreferred,
    YYUIBottomSheetStateExtended
};
