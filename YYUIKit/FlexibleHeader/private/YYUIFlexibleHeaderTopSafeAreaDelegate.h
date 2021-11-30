//
//  YYUIFlexibleHeaderTopSafeAreaDelegate.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/17.
//

#import <UIKit/UIKit.h>

@class YYUIFlexibleHeaderTopSafeArea;

/**
 The delegate protocol through which YYUIFlexibleHeaderTopSafeArea communicates changes in the top
 safe area inset.
 */
@protocol YYUIFlexibleHeaderTopSafeAreaDelegate
@required

/**
 Informs the receiver that the topSafeAreaInset value has changed.
 */
- (void)flexibleHeaderSafeAreaTopSafeAreaInsetDidChange:(nonnull YYUIFlexibleHeaderTopSafeArea *)safeAreas;

/**
 Asks the receiver whether the status bar is likely shifted off-screen by the owner.
 */
- (BOOL)flexibleHeaderSafeAreaIsStatusBarShifted:(nonnull YYUIFlexibleHeaderTopSafeArea *)safeAreas;

/**
 Asks the receiver to return the device's top safe area inset.
 */
- (CGFloat)flexibleHeaderSafeAreaDeviceTopSafeAreaInset:(nonnull YYUIFlexibleHeaderTopSafeArea *)safeAreas;

@end
