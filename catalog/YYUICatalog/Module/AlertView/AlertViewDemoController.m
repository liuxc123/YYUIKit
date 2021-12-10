//
//  AlertViewDemoController.m
//  YYUICatalog
//
//  Created by liuxc on 2021/12/2.
//

#import "AlertViewDemoController.h"
#import "YYUIAlertView.h"


@interface AlertViewDemoController ()

@end

@implementation AlertViewDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.title = @"AlertView";
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    YYUIAlertView *alertView = [YYUIAlertView alertViewWithImage:[UIImage imageNamed:@"zhiwen"] title:@"title" message:@"message"];
    
//    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
//    customView.backgroundColor = UIColor.yellowColor;
//    [alertView addCustomView:customView];
//
//    UIView *customView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
//    customView2.backgroundColor = UIColor.redColor;
//    [alertView addCustomView:customView2];
    
    [alertView addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入内容";
    }];
    
//    [alertView addAction:[YYUIAlertAction actionWithTitle:@"确定" style: YYUIAlertActionStyleDefault handler:^(YYUIAlertAction * _Nonnull action) {
//        
//    }]];
    
//    for (int i = 0; i < 10; i++) {
//        [alertView addAction:[YYUIAlertAction actionWithTitle:@"确定" style: YYUIAlertActionStyleDefault handler:^(YYUIAlertAction * _Nonnull action) {
//
//        }]];
//    }
    
//    [alertView addAction:[YYUIAlertAction actionWithTitle:@"取消" style: YYUIAlertActionStyleCancel handler:^(YYUIAlertAction * _Nonnull action) {
//        
//    }]];

    [alertView showWithAnimated:YES completion:^{
        
    }];
}

@end

@implementation AlertViewDemoController (CatalogByConvention)

+ (NSDictionary *)catalogMetadata {
    return @{
        @"breadcrumbs" : @[ @"YYUIAlert", @"AlertView" ],
        @"primaryDemo" : @NO,
        @"presentable" : @NO,
    };
}

- (BOOL)catalogShouldHideNavigation {
    return YES;
}

@end
