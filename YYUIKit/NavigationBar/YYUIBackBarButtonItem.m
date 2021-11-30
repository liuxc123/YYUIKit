//
//  YYUIBackBarButtonItem.m
//  YYUIKit
//
//  Created by mac on 2021/8/19.
//  Copyright © 2021 liuxc123. All rights reserved.
//

#import "YYUIBackBarButtonItem.h"

@implementation YYUIBackBarButtonItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                        style:(UIBarButtonItemStyle)style
                    tintColor:(UIColor *)tintColor
{
    
    self = [super initWithTitle:title style:style target:nil action:@selector(backBarButtonItemAction)];
    if (self) {
        self.target = self;
        self.tintColor = tintColor;
        [self setup];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
                        style:(UIBarButtonItemStyle)style
                    tintColor:(UIColor *)tintColor
{
    
    self = [super initWithImage:image style:style target:nil action:@selector(backBarButtonItemAction)];
    if (self) {
        self.target = self;
        self.tintColor = tintColor;
        [self setup];
    }
    return self;
}

- (instancetype)initWithButton:(UIButton *)button
                    tintColor:(UIColor *)tintColor
{
    
    self = [super initWithCustomView:button];
    if (self) {
        [button addTarget:self action:@selector(backBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
        button.tintColor = tintColor;
        [self setup];
    }
    return self;
}

- (void)setup {

    self.shouldBack = ^BOOL(YYUIBackBarButtonItem * item) {
        return YES;
    };
    
    self.willBack = ^{
        
    };
    
    __weak typeof(self) weakSelf = self;
    self.goBack = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.navigationController popViewControllerAnimated:YES];
    };
    
    self.didBack = ^{
        
    };
}

- (void)backBarButtonItemAction {
    YYUIBackBarButtonItem *item = self;
    if (!self.shouldBack(item)) {
        return;
    }
    
    self.willBack();
    self.goBack();
    self.didBack();
}

@end
