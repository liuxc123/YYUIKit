//
//  YYUIOverlayUtilities.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import "YYUIOverlayUtilities.h"

CGRect YYUIOverlayConvertRectToView(CGRect screenRect, UIView *target) {
  if (target != nil && !CGRectIsNull(screenRect)) {
    UIScreen *screen = [UIScreen mainScreen];
    return [target convertRect:screenRect fromCoordinateSpace:screen.coordinateSpace];
  }
  return CGRectNull;
}
