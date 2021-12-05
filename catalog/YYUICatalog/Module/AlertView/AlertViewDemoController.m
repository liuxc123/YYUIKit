//
//  AlertViewDemoController.m
//  YYUICatalog
//
//  Created by liuxc on 2021/12/2.
//

#import "AlertViewDemoController.h"

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
