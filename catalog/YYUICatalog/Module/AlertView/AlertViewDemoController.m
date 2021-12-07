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
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    contentView.backgroundColor = UIColor.yellowColor;
    contentView.layer.cornerRadius = 10;
    contentView.clipsToBounds = YES;
    
    YYUIPopupController *popup = [[YYUIPopupController alloc] initWithView:contentView size:CGSizeMake(self.view.width, 300)];
    popup.presentationStyle = YYUIPopupAnimationStyleFromBottom;
    popup.dismissonStyle = YYUIPopupAnimationStyleFromBottom;
    popup.layoutType = YYUIPopupLayoutTypeBottom;
    popup.dismissOnMaskTouched = YES;
    popup.panGestureEnabled = YES;
    popup.panDismissRatio = 0.8;
    [popup show];
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
