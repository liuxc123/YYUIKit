//
//  UIView+YYUIAdd.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/29.
//

#import "UIView+YYUIAdd.h"
#import "UIApplication+YYAdd.h"

@implementation UIView (YYUIAdd)

- (UIEdgeInsets)yyui_safeAreaInsets {
    if (@available(iOS 11.0, *)) {
        return self.safeAreaInsets;
    } else {
        return self.layoutMargins;
    }
}

- (UIView *)findSubview:(NSString *)name resursion:(BOOL)resursion {
    Class class = NSClassFromString(name);
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:class]) {
            return subview;
        }
    }
    
    if (resursion) {
        for (UIView *subview in self.subviews) {
            UIView *tempView = [subview findSubview:name resursion:resursion];
            if (tempView) {
                return tempView;
            }
        }
    }
    return nil;
}

- (void)roundCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.path = [maskPath CGPath];
    self.layer.mask = shape;
}

@end
