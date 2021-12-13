//
//  ActivityIndicatorDemoViewController.m
//  YYUICatalog
//
//  Created by liuxc on 2021/12/13.
//

#import "ActivityIndicatorDemoViewController.h"

@interface ActivityIndicatorDemoViewController ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation ActivityIndicatorDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.title = @"ActivityIndicator";
    self.view.backgroundColor = [UIColor colorWithRed:237/255.0f green:85/255.0f blue:101/255.0f alpha:1.0f];
        
    NSArray *activityTypes = @[@(YYUIActivityIndicatorAnimationTypeNineDots),
                               @(YYUIActivityIndicatorAnimationTypeTriplePulse),
                               @(YYUIActivityIndicatorAnimationTypeFiveDots),
                               @(YYUIActivityIndicatorAnimationTypeRotatingSquares),
                               @(YYUIActivityIndicatorAnimationTypeDoubleBounce),
                               @(YYUIActivityIndicatorAnimationTypeRippleAnimation),
                               @(YYUIActivityIndicatorAnimationTypeTwoDots),
                               @(YYUIActivityIndicatorAnimationTypeThreeDots),
                               @(YYUIActivityIndicatorAnimationTypeBallPulse),
                               @(YYUIActivityIndicatorAnimationTypeBallClipRotate),
                               @(YYUIActivityIndicatorAnimationTypeBallClipRotatePulse),
                               @(YYUIActivityIndicatorAnimationTypeBallClipRotateMultiple),
                               @(YYUIActivityIndicatorAnimationTypeBallRotate),
                               @(YYUIActivityIndicatorAnimationTypeBallZigZag),
                               @(YYUIActivityIndicatorAnimationTypeBallZigZagDeflect),
                               @(YYUIActivityIndicatorAnimationTypeBallTrianglePath),
                               @(YYUIActivityIndicatorAnimationTypeBallScale),
                               @(YYUIActivityIndicatorAnimationTypeLineScale),
                               @(YYUIActivityIndicatorAnimationTypeLineScaleParty),
                               @(YYUIActivityIndicatorAnimationTypeBallScaleMultiple),
                               @(YYUIActivityIndicatorAnimationTypeBallPulseSync),
                               @(YYUIActivityIndicatorAnimationTypeBallBeat),
                               @(YYUIActivityIndicatorAnimationType3DotsFadeAnimation),
                               @(YYUIActivityIndicatorAnimationTypeLineScalePulseOut),
                               @(YYUIActivityIndicatorAnimationTypeLineScalePulseOutRapid),
                               @(YYUIActivityIndicatorAnimationTypeLineJumpUpAndDownAnimation),
                               @(YYUIActivityIndicatorAnimationTypeBallScaleRipple),
                               @(YYUIActivityIndicatorAnimationTypeBallScaleRippleMultiple),
                               @(YYUIActivityIndicatorAnimationTypeTriangleSkewSpin),
                               @(YYUIActivityIndicatorAnimationTypeBallGridBeat),
                               @(YYUIActivityIndicatorAnimationTypeBallGridPulse),
                               @(YYUIActivityIndicatorAnimationTypeRotatingSandglass),
                               @(YYUIActivityIndicatorAnimationTypeRotatingTrigons),
                               @(YYUIActivityIndicatorAnimationTypeTripleRings),
                               @(YYUIActivityIndicatorAnimationTypeCookieTerminator),
                               @(YYUIActivityIndicatorAnimationTypeBallSpinFadeLoader),
                               @(YYUIActivityIndicatorAnimationTypeBallLoopScale),
                               @(YYUIActivityIndicatorAnimationTypeExchangePosition),
                               @(YYUIActivityIndicatorAnimationTypeRotaingCurveEaseOut),
                               @(YYUIActivityIndicatorAnimationTypeLoadingSuccess),
                               @(YYUIActivityIndicatorAnimationTypeLoadingFail),
                               @(YYUIActivityIndicatorAnimationTypeBallRotaingAroundBall)];
    
    NSInteger col = 5; // 列数
    NSInteger row = (activityTypes.count%col == 0 ? activityTypes.count/col : (activityTypes.count/col+1)); // 共有多少行
    for (int i = 0; i < activityTypes.count; i++) {
        YYUIActivityIndicatorView *activityIndicatorView = [[YYUIActivityIndicatorView alloc] initWithType:(YYUIActivityIndicatorAnimationType)[activityTypes[i] integerValue] tintColor:[UIColor whiteColor]];
        CGFloat width = self.view.bounds.size.width / col; // 每行排5个(5列)
        CGFloat height = width;
        CGFloat padding = (self.scrollView.bounds.size.height-row*height)/(activityTypes.count-1);
        activityIndicatorView.frame = CGRectMake(width * (i % col), (height+padding) * (int)(i / col), width, height);
        [self.scrollView addSubview:activityIndicatorView];
        self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(activityIndicatorView.frame));
        [activityIndicatorView startAnimating];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [activityIndicatorView addGestureRecognizer:tap];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    YYUIActivityIndicatorView *activityIndicatorView = (YYUIActivityIndicatorView *)tap.view;
    id<YYUIActivityIndicatorAnimationProtocol> animation = [YYUIActivityIndicatorView activityIndicatorAnimationForAnimationType:activityIndicatorView.type];
//    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:NSStringFromClass([animation class]) message:nil preferredStyle:UIAlertControllerStyleAlert];
//    [self presentViewController:alertVc animated:YES completion:nil];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [alertVc dismissViewControllerAnimated:YES completion:nil];
//    });
    
    YYUIAlertView *alertView = [YYUIAlertView alertViewWithTitle:NSStringFromClass([animation class]) message:nil];
    [alertView showWithAnimated:YES completion:^{}];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertView dismissWithAnimated:YES completion:^{}];
    });
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), self.view.bounds.size.width, self.view.bounds.size.height-CGRectGetMaxY(self.titleLabel.frame));
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(0, self.view.yyui_safeAreaInsets.top, self.view.bounds.size.width, 40);
        _titleLabel.text = @"单击每个动画显示对应的类名";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.view addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end

@implementation ActivityIndicatorDemoViewController (CatalogByConvention)

+ (NSDictionary *)catalogMetadata {
    return @{
        @"breadcrumbs" : @[ @"ActivityIndicator" ],
        @"primaryDemo" : @NO,
        @"presentable" : @NO,
    };
}

- (BOOL)catalogShouldHideNavigation {
    return YES;
}

@end
