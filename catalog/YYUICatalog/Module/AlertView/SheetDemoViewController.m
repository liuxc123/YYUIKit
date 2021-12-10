//
//  SheetDemoViewController.m
//  YYUICatalog
//
//  Created by liuxc on 2021/12/10.
//

#import "SheetDemoViewController.h"

@interface SheetDemoViewController ()

@end

@implementation SheetDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.title = @"SheetView";
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    YYUISheetView *sheetView = [YYUISheetView sheetViewWithImage:[UIImage imageNamed:@"zhiwen"] title:@"title" message:@"message"];
    
//    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
//    customView.backgroundColor = UIColor.yellowColor;
//    [sheetView addCustomView:customView];
//    
//    UIView *customView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
//    customView2.backgroundColor = UIColor.redColor;
//    [sheetView addCustomView:customView2];
    
//    [sheetView addAction:[YYUIAlertAction actionWithTitle:@"确定" style: YYUIAlertActionStyleDefault handler:^(YYUIAlertAction * _Nonnull action) {
//        
//    }]];
    
//    for (int i = 0; i < 10; i++) {
//        [sheetView addAction:[YYUIAlertAction actionWithTitle:@"确定" style: YYUIAlertActionStyleDefault handler:^(YYUIAlertAction * _Nonnull action) {
//            
//        }]];
//    }
    
//    [sheetView addAction:[YYUIAlertAction actionWithTitle:@"取消" style: YYUIAlertActionStyleCancel handler:^(YYUIAlertAction * _Nonnull action) {
//        
//    }]];
    
    [sheetView showWithAnimated:YES completion:^{}];
}

@end

@implementation SheetDemoViewController (CatalogByConvention)

+ (NSDictionary *)catalogMetadata {
    return @{
        @"breadcrumbs" : @[ @"YYUIAlert", @"SheetView" ],
        @"primaryDemo" : @NO,
        @"presentable" : @NO,
    };
}

- (BOOL)catalogShouldHideNavigation {
    return YES;
}

@end
