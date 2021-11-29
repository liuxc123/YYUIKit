//
//  UIApplication+YYUIAdd.m
//  CatalogByConvention
//
//  Created by liuxc on 2021/11/29.
//

#import "UIApplication+YYUIAdd.h"
#import "UIApplication+YYAdd.h"

const CGFloat YYUIFixedStatusBarHeightOnPreiPhoneXDevices = 20;

static BOOL HasHardwareSafeAreas(void) {
  static BOOL hasHardwareSafeAreas = NO;
  if (@available(iOS 11.0, *)) {
    static BOOL hasCheckedForHardwareSafeAreas = NO;
    static dispatch_once_t onceToken;
    if (!hasCheckedForHardwareSafeAreas && [UIApplication sharedExtensionApplication].keyWindow) {
      dispatch_once(&onceToken, ^{
        UIEdgeInsets insets = [UIApplication sharedExtensionApplication].keyWindow.safeAreaInsets;
        hasHardwareSafeAreas = (insets.top > YYUIFixedStatusBarHeightOnPreiPhoneXDevices ||
                                insets.left > 0 || insets.bottom > 0 || insets.right > 0);

        hasCheckedForHardwareSafeAreas = YES;
      });
    }
  }
  return hasHardwareSafeAreas;
}

@implementation UIApplication (YYUIAdd)

+ (CGFloat)yyui_topSafeAreaInset {
    CGFloat topInset = YYUIFixedStatusBarHeightOnPreiPhoneXDevices;
    if (@available(iOS 11.0, *)) {
      // Devices with hardware safe area insets have fixed insets that depend on the device
      // orientation. On such devices, we aren't interested in the status bar's height because the
      // hardware safe area insets are what ultimately define the margins for the app. If we are
      // running on such a device, we read from the safe area insets instead of the fixed status bar
      // height so that we react to changes in safe area insets (usually due to orientation changes)
      // and update the fixed margin accordingly.
      if (HasHardwareSafeAreas()) {
        UIEdgeInsets insets = [UIApplication sharedExtensionApplication].keyWindow.safeAreaInsets;
        topInset = insets.top;
      }
    }
    return topInset;
}

@end
