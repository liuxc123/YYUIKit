//
//  YYUIAlertViewShadowView.h
//  YYUIKit
//
//  Created by liuxc on 2021/12/2.
//

#import <UIKit/UIKit.h>

@interface YYUIAlertViewShadowView : UIView

@property (assign, nonatomic) CGFloat cornerRadius;
@property (strong, nonatomic, nullable) UIColor *strokeColor;
@property (assign, nonatomic) CGFloat strokeWidth;
@property (strong, nonatomic, nullable) UIColor *shadowColor;
@property (assign, nonatomic) CGFloat shadowBlur;
@property (assign, nonatomic) CGPoint shadowOffset;

@end

