//
//  UIView+YYUIAdd.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/29.
//

#import <UIKit/UIKit.h>

@interface UIView (YYUIAdd)

- (UIEdgeInsets)yyui_safeAreaInsets;

- (UIView *)findSubview:(NSString *)name resursion:(BOOL)resursion;

- (void)roundCorners:(UIRectCorner)corners radius:(CGFloat)radius;

@end

