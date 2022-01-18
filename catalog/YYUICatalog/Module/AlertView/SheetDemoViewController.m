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
    
    [sheetView addAction:[YYUIAlertAction actionWithTitle:@"确定" style: YYUIAlertActionStyleDefault handler:^(YYUIAlertAction * _Nonnull action) {
        YYUITips.appearance.tintColor = UIColor.whiteColor;
        [YYUITips showSucceed:@"操作成功"];
    }]];
    
    [sheetView addAction:[YYUIAlertAction actionWithTitle:@"取消" style: YYUIAlertActionStyleCancel handler:^(YYUIAlertAction * _Nonnull action) {
        [YYUITips showError:@"操作失败"];
    }]];
    
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
