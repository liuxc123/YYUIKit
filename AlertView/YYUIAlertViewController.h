//
//  YYUIAlertViewController.h
//  YYUIKit
//
//  Created by liuxc on 2021/12/2.
//

#import <UIKit/UIKit.h>

@class YYUIAlertView;
@class YYUIAlertController;

@interface YYUIAlertViewController : UIViewController

- (nonnull instancetype)initWithAlertView:(nonnull YYUIAlertView *)alertView view:(nonnull UIView *)view;

- (nonnull instancetype)initWithAlertController:(nonnull YYUIAlertController *)alertController view:(nonnull UIView *)view;

@end
