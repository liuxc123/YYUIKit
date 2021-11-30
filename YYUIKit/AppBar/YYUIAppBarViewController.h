//
//  YYUIAppBarViewController.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/17.
//

#import "YYUIFlexibleHeader.h"
#import "YYUIHeaderStackView.h"
#import "YYUINavigationBar.h"

@class YYUIAppBarViewController;
@protocol YYUIAppBarViewControllerAccessibilityPerformEscapeDelegate;

/**
 YYUIAppBarViewController is a flexible header view controller that manages a navigation bar and
 header stack view in order to provide the Material Top App Bar user interface.
 */
API_UNAVAILABLE(tvos, watchos)
@interface YYUIAppBarViewController : YYUIFlexibleHeaderViewController

/**
 Adds self.view to self.parentViewController.view and registers
 navigationItem observation on self.parentViewController.
 */
- (void)addSubviewsToParent;

/**
 The navigation bar often represents the information stored in a view controller's navigationItem
 property, but it can also be directly configured.
 */
@property(nonatomic, strong, nonnull) YYUINavigationBar *navigationBar;

/**
 The header stack view owns the navigationBar (as the top bar) and an optional bottom bar (typically
 a tab bar).
 */
@property(nonatomic, strong, nonnull) YYUIHeaderStackView *headerStackView;

/**
 When this flag is set to YES, the height of the app bar will be automatically adjusted to the sum
 of the top bar height and the bottom bar height.

 Enabling this property will disable `minMaxHeightIncludesSafeArea` on the flexible header view.

 Defaults to NO.
*/
@property(nonatomic) BOOL shouldAdjustHeightBasedOnHeaderStackView;

/**
 Defines a downward shift distance for `headerStackView`.
 */
@property(nonatomic) CGFloat headerStackViewOffset;

/**
 A delegate that, if provided, allows for customization of the default behavior of
 @c accessibilityPerformEscape.

 If nil, then the default behavior will attempt to dismiss the YYUIAppBarViewController's parent
 view controller and @c accessibilityPerformEscape will return @c YES.
 */
@property(nonatomic, weak, nullable) id<YYUIAppBarViewControllerAccessibilityPerformEscapeDelegate>
    accessibilityPerformEscapeDelegate;

@end
