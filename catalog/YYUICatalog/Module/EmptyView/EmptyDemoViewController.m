//
//  EmptyDemoViewController.m
//  YYUICatalog
//
//  Created by liuxc on 2021/12/13.
//

#import "EmptyDemoViewController.h"

typedef NS_ENUM(NSUInteger, YYUIEmptyViewState) {
    YYUIEmptyViewStateNormal,
    YYUIEmptyViewStateLoading,
    YYUIEmptyViewStateEmpty,
    YYUIEmptyViewStateError,
};

@interface EmptyDemoViewController ()

@property (nonatomic, strong) YYUIEmptyView *emptyView;

@end

@implementation EmptyDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.emptyView.frame = self.view.bounds;
}

- (void)setupUI {
    self.navigationItem.title = @"EmptyView";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"切换" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonAction)];
    self.emptyView = [[YYUIEmptyView alloc] init];
    self.emptyView.loadingView = [[YYUIActivityIndicatorView alloc] initWithType:YYUIActivityIndicatorAnimationTypeBallPulse tintColor:[UIColor grayColor] size:40];
    [self.view addSubview:self.emptyView];
    [self setupEmpty:YYUIEmptyViewStateNormal];
}

- (void)rightBarButtonAction {
    @weakify(self);

    YYUISheetView *sheetView = [YYUISheetView sheetViewWithTitle:@"切换状态" message:nil];
    
    [sheetView addAction:[YYUIAlertAction actionWithTitle:@"normal" style:YYUIAlertActionStyleDefault handler:^(YYUIAlertAction * _Nonnull action) {
        @strongify(self);
        [UIView animateWithDuration:0.27 animations:^{
            [self setupEmpty:YYUIEmptyViewStateNormal];
        }];
    }]];
    
    [sheetView addAction:[YYUIAlertAction actionWithTitle:@"loading" style:YYUIAlertActionStyleDefault handler:^(YYUIAlertAction * _Nonnull action) {
        @strongify(self);
        [UIView animateWithDuration:0.27 animations:^{
            [self setupEmpty:YYUIEmptyViewStateLoading];
        }];
    }]];
    
    [sheetView addAction:[YYUIAlertAction actionWithTitle:@"empty" style:YYUIAlertActionStyleDefault handler:^(YYUIAlertAction * _Nonnull action) {
        @strongify(self);
        [UIView animateWithDuration:0.27 animations:^{
            [self setupEmpty:YYUIEmptyViewStateEmpty];
        }];
    }]];
    
    [sheetView addAction:[YYUIAlertAction actionWithTitle:@"error" style:YYUIAlertActionStyleDefault handler:^(YYUIAlertAction * _Nonnull action) {
        @strongify(self);
        [UIView animateWithDuration:0.27 animations:^{
            [self setupEmpty:YYUIEmptyViewStateError];
        }];
    }]];
    
    [sheetView showWithAnimated:YES completion:^{}];
}

- (void)setupEmpty:(YYUIEmptyViewState)state {
    
    switch (state) {
        case YYUIEmptyViewStateNormal:
            [self.emptyView setHidden:YES];
            [self.emptyView setLoadingViewHidden:YES];
            [self.emptyView.actionButton setHidden:YES];
            break;
            
        case YYUIEmptyViewStateLoading:
            [self.emptyView setHidden:NO];
            [self.emptyView setLoadingViewHidden:NO];
            [self.emptyView setTextLabelText:@"loading"];
            [self.emptyView setActionButtonTitle:@""];
            break;
            
        case YYUIEmptyViewStateEmpty:
            [self.emptyView setHidden:NO];
            [self.emptyView setLoadingViewHidden:YES];
            [self.emptyView setTextLabelText:@"暂无内容"];
            [self.emptyView setActionButtonTitle:@""];
            break;
            
        case YYUIEmptyViewStateError:
            [self.emptyView setHidden:NO];
            [self.emptyView setLoadingViewHidden:YES];
            [self.emptyView setTextLabelText:@"网络错误"];
            [self.emptyView setActionButtonTitle:@"刷新"];
            break;
            
        default:
            break;
    }
}

@end

@implementation EmptyDemoViewController (CatalogByConvention)

+ (NSDictionary *)catalogMetadata {
    return @{
        @"breadcrumbs" : @[ @"EmptyView" ],
        @"primaryDemo" : @NO,
        @"presentable" : @NO,
    };
}

- (BOOL)catalogShouldHideNavigation {
    return YES;
}

@end
