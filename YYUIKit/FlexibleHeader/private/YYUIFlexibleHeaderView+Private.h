//
//  YYUIFlexibleHeaderView+Private.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/17.
//

#import "YYUIFlexibleHeaderView.h"

@interface YYUIFlexibleHeaderView ()

/*
 The view controller from which the top safe area insets should be extracted.

 This is typically the root parent of the view controller that owns the flexible header view
 controller.
 */
@property(nonatomic, weak, nullable) UIViewController *topSafeAreaSourceViewController;

/*
 Whether to subtract additionalSafeAreaInsets from the extracted safeAreaInsets.

 Ignored if topSafeAreaSourceViewController is nil.
 */
@property(nonatomic) BOOL subtractsAdditionalSafeAreaInsets;

/*
 A behavioral flag affecting whether the flexible header view should extract top safe area insets
 from topSafeAreaSourceViewController or not.
 */
@property(nonatomic) BOOL inferTopSafeAreaInsetFromViewController;

/*
 Forces an extraction of the top safe area inset. Intended to be called any time the top safe area
 inset is known to have changed.
 */
- (void)topSafeAreaInsetDidChange;

/**
 The height of the top safe area guide.
 */
@property(nonatomic, readonly) CGFloat topSafeAreaGuideHeight;

#pragma mark - WebKit compatibility

/**
 Returns YES if the trackingScrollView is a scroll view of a WKWebView instance.
 */
- (BOOL)trackingScrollViewIsWebKit;

/**
 See YYUIFlexibleHeaderViewController.h for documentation on this flag.
 */
@property(nonatomic) BOOL useAdditionalSafeAreaInsetsForWebKitScrollViews;

@end

