//
//  YYUIFlexibleHeaderMinMaxHeightDelegate.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/17.
//

#import <UIKit/UIKit.h>

@class YYUIFlexibleHeaderMinMaxHeight;

/**
 The delegate protocol through which YYUIFlexibleHeaderMinMaxHeight communicates changes in the
 minimum and maximum height.
 */
@protocol YYUIFlexibleHeaderMinMaxHeightDelegate <NSObject>
@required

/**
 Informs the receiver that the maximum height has changed.
 */
- (void)flexibleHeaderMaximumHeightDidChange:(nonnull YYUIFlexibleHeaderMinMaxHeight *)safeAreas;

/**
 Informs the receiver that either the minimum or maximum height have changed.
 */
- (void)flexibleHeaderMinMaxHeightDidChange:(nonnull YYUIFlexibleHeaderMinMaxHeight *)safeAreas;

@end
