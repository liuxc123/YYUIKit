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
    YYUIAlertView *alertView = [[YYUIAlertView alloc] initWithTitle:@"Title"
                                                            message:@"Message"
                                                              style:YYUIAlertViewStyleActionSheet
                                                       buttonTitles:@[@"Button", @"Button", @"Button", @"Button", @"Button", @"Button"]
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:@"Destructive"
                                                      actionHandler:nil
                                                      cancelHandler:nil
                                                 destructiveHandler:nil];


    alertView.coverColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    alertView.coverBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    alertView.coverAlpha = 0.85;
    alertView.layerShadowColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    alertView.layerShadowRadius = 4.0;
    alertView.layerCornerRadius = 10;
    alertView.layerBorderWidth = 2.0;
    alertView.layerBorderColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
    alertView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    alertView.buttonsHeight = 44.0;
    alertView.titleFont = [UIFont boldSystemFontOfSize:18.0];
    alertView.titleTextColor = [UIColor blackColor];
    alertView.messageTextColor = [UIColor blackColor];
    alertView.width = MIN(self.view.bounds.size.width, self.view.bounds.size.height);
    alertView.offsetVertical = 20;
    alertView.cancelButtonOffsetY = 20;
    [alertView showAnimated:YES completionHandler:nil];
    
    [alertView show];
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
