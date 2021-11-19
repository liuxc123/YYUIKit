//
//  YYUIOverlayUtilities.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import <UIKit/UIKit.h>

/**
 Utility function which converts a rectangle in overlay coordinates into the local coordinate
 space of the given @c target
 */
OBJC_EXPORT CGRect YYUIOverlayConvertRectToView(CGRect overlayFrame, UIView *targetView);
