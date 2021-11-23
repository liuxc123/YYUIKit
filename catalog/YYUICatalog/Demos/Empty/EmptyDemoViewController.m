//
//  EmptyDemoViewController.m
//  YYUICatalog
//
//  Created by liuxc on 2021/11/23.
//

#import "EmptyDemoViewController.h"
#import "ThemeConstant.h"
#import "YYTheme.h"
#import "YYToast.h"
#import "YYEmtpyView.h"
#import "YYUIButton.h"

@interface EmptyDemoViewController ()

@property (nonatomic, strong) YYUIEmptyView *emptyView;

@end

@implementation EmptyDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAppearance];
    [self setupUI];
}

- (void)setupAppearance {
    YYUIEmptyView *appearance = [YYUIEmptyView appearance];
    appearance.textLabelTextColor = [UIColor themeColor:theme_textlabel1];
    appearance.detailTextLabelTextColor = [UIColor themeColor:theme_textlabel2];
    appearance.actionButtonTitleColor = [UIColor themeColor:theme_textlabel3];
}

- (void)setupUI {
    self.navigationItem.title = @"Empty Demo1";
    self.view.backgroundColor = [UIColor themeColor:theme_backgroundColor];
    
    self.emptyView = [[YYUIEmptyView alloc] initWithFrame:self.view.bounds];
    [self.emptyView setTextLabelText:@"暂无内容"];
    [self.emptyView setDetailTextLabelText:@"请查看内容是否正确"];
    [self.emptyView setImage:[UIImage imageNamed:@""]];
    [self.emptyView setLoadingViewHidden:YES];
    [self.emptyView setActionButtonTitle:@"点击刷新"];
    [self.emptyView setActionButtonInsets:UIEdgeInsetsMake(16, 16, 16, 16)];
    [self.emptyView.actionButton addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.emptyView];

}

- (void)clickAction {
    [self.emptyView setLoadingViewHidden:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.emptyView setLoadingViewHidden:YES];
    });
}

@end

@implementation EmptyDemoViewController (CatalogByConvention)

+ (NSDictionary *)catalogMetadata {
    return @{
        @"breadcrumbs" : @[ @"Empty", @"Empty Demo1" ],
        @"primaryDemo" : @NO,
        @"presentable" : @NO,
    };
}

- (BOOL)catalogShouldHideNavigation {
    return YES;
}

@end
