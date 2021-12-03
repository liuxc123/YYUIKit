//
//  YYUIAlertViewButton.h
//  YYUIKit
//
//  Created by liuxc on 2021/12/2.
//

#import <UIKit/UIKit.h>
#import "YYUIAlertViewShared.h"

@interface YYUIAlertViewButton : UIButton

@property (assign, nonatomic) YYUIAlertViewButtonIconPosition iconPosition;

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;

@end


