//
//  YYUIAlertViewTextField.m
//  CatalogByConvention
//
//  Created by liuxc on 2021/12/2.
//

#import "YYUIAlertViewTextField.h"
#import "YYUIAlertViewHelper.h"

@implementation YYUIAlertViewTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    bounds.origin.x += YYUIAlertViewPaddingWidth;
    bounds.size.width -= YYUIAlertViewPaddingWidth * 2.0;

    if (self.leftView) {
        bounds.origin.x += CGRectGetWidth(self.leftView.bounds) + YYUIAlertViewPaddingWidth;
        bounds.size.width -= CGRectGetWidth(self.leftView.bounds) + YYUIAlertViewPaddingWidth;
    }

    if (self.rightView) {
        bounds.size.width -= CGRectGetWidth(self.rightView.bounds) + YYUIAlertViewPaddingWidth;
    }
    else if (self.clearButtonMode == UITextFieldViewModeAlways) {
        bounds.size.width -= 20.0;
    }

    return bounds;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    bounds.origin.x += YYUIAlertViewPaddingWidth;
    bounds.size.width -= YYUIAlertViewPaddingWidth * 2.0;

    if (self.leftView) {
        bounds.origin.x += CGRectGetWidth(self.leftView.bounds) + YYUIAlertViewPaddingWidth;
        bounds.size.width -= CGRectGetWidth(self.leftView.bounds) + YYUIAlertViewPaddingWidth;
    }

    if (self.rightView) {
        bounds.size.width -= CGRectGetWidth(self.rightView.bounds) + YYUIAlertViewPaddingWidth;
    }
    else if (self.clearButtonMode == UITextFieldViewModeAlways) {
        bounds.size.width -= 20.0;
    }

    return bounds;
}

@end
