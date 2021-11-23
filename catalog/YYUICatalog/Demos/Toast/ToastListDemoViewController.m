//
//  ToastListDemoViewController.m
//  YYUICatalog
//
//  Created by liuxc on 2021/11/23.
//

#import "ToastListDemoViewController.h"
#import "ThemeConstant.h"
#import "YYTheme.h"
#import "YYToast.h"

@interface ToastListDemoViewController ()

@end

@implementation ToastListDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.title = @"Toast Demo1";
    self.view.backgroundColor = [UIColor themeColor:theme_backgroundColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    [YYUITips showWithText:@"text"];
//
//    [YYUITips showSucceed:@"success"];
//
//    [YYUITips showInfo:@"info"];
//
//    [YYUITips showError:@"error"];
    
    [YYUITips showLoading:@"加载中..." inView:self.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [YYUITips hideAllTipsInView:self.view];
    });
}

@end

@implementation ToastListDemoViewController (CatalogByConvention)

+ (NSDictionary *)catalogMetadata {
    return @{
        @"breadcrumbs" : @[ @"Toast", @"Toast Demo1" ],
        @"primaryDemo" : @NO,
        @"presentable" : @NO,
    };
}

- (BOOL)catalogShouldHideNavigation {
    return YES;
}

@end
