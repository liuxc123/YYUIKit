//
//  YYUIAlertViewCell.h
//  YYUIKit
//
//  Created by liuxc on 2021/12/2.
//

#import <UIKit/UIKit.h>
#import "YYUIAlertViewShared.h"

@interface YYUIAlertViewCell : UITableViewCell

@property (strong, nonatomic, readonly, nonnull) UIView *separatorView;

@property (strong, nonatomic, nullable) UIColor *titleColor;
@property (strong, nonatomic, nullable) UIColor *titleColorHighlighted;
@property (strong, nonatomic, nullable) UIColor *titleColorDisabled;

@property (strong, nonatomic, nullable) UIColor *backgroundColorNormal;
@property (strong, nonatomic, nullable) UIColor *backgroundColorHighlighted;
@property (strong, nonatomic, nullable) UIColor *backgroundColorDisabled;

@property (strong, nonatomic, nullable) UIImage *image;
@property (strong, nonatomic, nullable) UIImage *imageHighlighted;
@property (strong, nonatomic, nullable) UIImage *imageDisabled;

@property (assign, nonatomic) YYUIAlertViewButtonIconPosition iconPosition;

@property (assign, nonatomic) BOOL enabled;

@end
