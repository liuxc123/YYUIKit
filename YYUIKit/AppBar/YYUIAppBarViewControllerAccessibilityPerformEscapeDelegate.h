//
//  YYUIAppBarViewControllerAccessibilityPerformEscapeDelegate.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/17.
//

#import <UIKit/UIKit.h>

@class YYUIAppBarViewController;

/**
 A delegate that can be implemented in order to respond to events specific to
 YYUIAppBarViewController.
 */
API_UNAVAILABLE(tvos, watchos)
@protocol YYUIAppBarViewControllerAccessibilityPerformEscapeDelegate <NSObject>
@required

/**
 Informs the receiver that the app bar view controller received an accessibilityPerformEscape event.

 The receiver should return @c YES if the modal view is successfully dismissed; otherwise,
 return @c NO. The value returned by this method is in turn returned to the
 @c accessibilityPerformEscape event.
 */
- (BOOL)appBarViewControllerAccessibilityPerformEscape:
    (nonnull YYUIAppBarViewController *)appBarViewController;

@end
