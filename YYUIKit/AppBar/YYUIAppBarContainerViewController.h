//
//  YYUIAppBarContainerViewController.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/17.
//

#import <UIKit/UIKit.h>

@class YYUIAppBar;
@class YYUIAppBarViewController;

/**
 The YYUIAppBarContainerViewController controller provides an interface for placing a
 UIViewController behind an App Bar.

 The YYUIAppBarContainerViewController class is commonly referred to as the "wrapper API" for the
 Material App Bar. This contrasts with the "injection" APIs as represented by the APIs in
 YYUIAppBar.h.

 Use the YYUIAppBarContainerViewController class when you do not own and cannot alter a view
 controller to which you want to add an App Bar. If you do own and can modify a view controller
 it is recommended that you use the YYUIAppBar.h APIs instead.

 ### Why we recommend using the YYUIAppBar.h APIs over this one

 Wrapping a view controller affects your app code in a variety of not-so-nice ways.

 1. Wrapped view controllers often need to be unwrapped in a variety of settings.
 2. The wrapped view controller's parentViewController is now a level of indirection from its
    previous parent.
 3. Wrapping a view controller can affect things like "isMovingToParentViewController" in
    wonderfully subtle ways.
 */
@interface YYUIAppBarContainerViewController : UIViewController

/**
 Initializes an App Bar container view controller instance with the given content view controller.
 */
- (nonnull instancetype)initWithContentViewController:
    (nonnull UIViewController *)contentViewController NS_DESIGNATED_INITIALIZER;

- (nonnull instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
                                 bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (nonnull instancetype)initWithCoder:(nonnull NSCoder *)aDecoder NS_UNAVAILABLE;
- (nonnull instancetype)init NS_UNAVAILABLE;

/**
 The App Bar view controller that will be a sibling to the contentViewController.
 */
@property(nonatomic, strong, nonnull, readonly) YYUIAppBarViewController *appBarViewController;

/** The content view controller to be displayed behind the header. */
@property(nonatomic, strong, nonnull, readonly) UIViewController *contentViewController;

@end

@interface YYUIAppBarContainerViewController (ToBeDeprecated)

/**
 If enabled, the content view controller's top layout guide will be adjusted as the flexible
 header's height changes and the content view controller view's frame will be set to the container
 view controller's bounds.

 This behavior is disabled by default, but it will be enabled by default in the future. Consider
 enabling this behavior and making use of the topLayoutGuide in your view controller accordingly.

 Example positioning a view using constraints:

     [NSLayoutConstraint constraintWithItem:view
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.topLayoutGuide
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1
                                   constant:32]

 Example positioning a view without constraints:

     frame.origin.y = self.topLayoutGuide.length + 32
 */
@property(nonatomic, getter=isTopLayoutGuideAdjustmentEnabled) BOOL topLayoutGuideAdjustmentEnabled;

@end
