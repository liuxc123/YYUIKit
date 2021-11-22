#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "YYAppBar.h"
#import "YYUIAppBarContainerViewController.h"
#import "YYUIAppBarNavigationController.h"
#import "YYUIAppBarViewController.h"
#import "YYUIAppBarViewControllerAccessibilityPerformEscapeDelegate.h"
#import "YYAvailability.h"
#import "YYUIAvailability.h"
#import "UIViewController+YYBottomSheet.h"
#import "YYBottomSheet.h"
#import "YYUIBottomSheetController.h"
#import "YYUIBottomSheetControllerDelegate.h"
#import "YYUIBottomSheetPresentationController.h"
#import "YYUIBottomSheetPresentationControllerDelegate.h"
#import "YYUIBottomSheetTransitionController.h"
#import "YYUISheetState.h"
#import "UIColor+YYElevation.h"
#import "UIView+YYElevationResponding.h"
#import "YYElevation.h"
#import "YYUIElevatable.h"
#import "YYUIElevationOverriding.h"
#import "YYFlexibleHeader.h"
#import "YYUIFlexibleHeaderContainerViewController.h"
#import "YYUIFlexibleHeaderSafeAreaDelegate.h"
#import "YYUIFlexibleHeaderView+ShiftBehavior.h"
#import "YYUIFlexibleHeaderView.h"
#import "YYUIFlexibleHeaderViewAnimationDelegate.h"
#import "YYUIFlexibleHeaderViewController.h"
#import "YYUIFlexibleHeaderViewDelegate.h"
#import "YYUIFlexibleHeaderViewLayoutDelegate.h"
#import "YYFlexibleHeader+CanAlwaysExpandToMaximumHeight.h"
#import "YYUIFlexibleHeaderView+canAlwaysExpandToMaximumHeight.h"
#import "YYFlexibleHeader+ShiftBehavior.h"
#import "YYUIFlexibleHeaderShiftBehavior.h"
#import "YYFlexibleHeader+ShiftBehaviorEnabledWithStatusBar.h"
#import "YYUIFlexibleHeaderShiftBehaviorEnabledWithStatusBar.h"
#import "YYHeaderStackView.h"
#import "YYUIHeaderStackView.h"
#import "YYNavigationBar.h"
#import "YYUIBackBarButtonItem.h"
#import "YYUINavigationBar.h"
#import "YYOverlayWindow.h"
#import "YYUIOverlayWindow.h"
#import "YYShadowLayer.h"
#import "YYUIShadowLayer.h"
#import "YYShapeLibrary.h"
#import "YYUICornerTreatment+CornerTypeInitalizer.h"
#import "YYUICurvedCornerTreatment.h"
#import "YYUICurvedRectShapeGenerator.h"
#import "YYUICutCornerTreatment.h"
#import "YYUIPillShapeGenerator.h"
#import "YYUIRoundedCornerTreatment.h"
#import "YYUISlantedRectShapeGenerator.h"
#import "YYUITriangleEdgeTreatment.h"
#import "YYShapes.h"
#import "YYUICornerTreatment.h"
#import "YYUIEdgeTreatment.h"
#import "YYUIPathGenerator.h"
#import "YYUIRectangleShapeGenerator.h"
#import "YYUIShapedShadowLayer.h"
#import "YYUIShapedView.h"
#import "YYUIShapeGenerating.h"
#import "YYUIShapeMediator.h"
#import "NSObject+YYUITheme.h"
#import "UIColor+YYUITheme.h"
#import "UIFont+YYUITheme.h"
#import "UIImage+YYUITheme.h"
#import "YYTheme.h"
#import "YYUIThemeManager.h"
#import "YYUIThemeProtocol.h"
#import "UIApplication+YYUIAppExtensions.h"
#import "YYApplication.h"
#import "UIColor+YYBlending.h"
#import "UIColor+YYDynamic.h"
#import "YYColor.h"
#import "YYKeyboardWatcher.h"
#import "YYUIKeyboardWatcher.h"
#import "YYMath.h"
#import "YYUIMath.h"
#import "YYOverlay.h"
#import "YYUIOverlayImplementor.h"
#import "YYUIOverlayObserver.h"
#import "YYUIOverlayTransitioning.h"
#import "YYResource.h"
#import "YYUIResource.h"
#import "YYMetrics.h"
#import "YYUILayoutMetrics.h"

FOUNDATION_EXPORT double YYUIKitVersionNumber;
FOUNDATION_EXPORT const unsigned char YYUIKitVersionString[];

