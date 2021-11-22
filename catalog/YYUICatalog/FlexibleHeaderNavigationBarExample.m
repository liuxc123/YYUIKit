#import "YYFlexibleHeader.h"

static const CGFloat kFlexibleHeaderMinHeight = 96;

@interface FlexibleHeaderNavigationBarExample : UIViewController <UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) YYUIFlexibleHeaderViewController *fhvc;

@end

@implementation FlexibleHeaderNavigationBarExample

- (instancetype)init {
  self = [super init];
  if (self) {
    [self commonFlexibleHeaderViewControllerInit];
  }
  return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    [self commonFlexibleHeaderViewControllerInit];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self commonFlexibleHeaderViewControllerInit];
  }
  return self;
}

- (void)commonFlexibleHeaderViewControllerInit {
    _fhvc = [[YYUIFlexibleHeaderViewController alloc] initWithNibName:nil bundle:nil];

    // Behavioral flags.
    _fhvc.topLayoutGuideAdjustmentEnabled = YES;
    _fhvc.inferTopSafeAreaInsetFromViewController = YES;
    _fhvc.headerView.minMaxHeightIncludesSafeArea = NO;
    _fhvc.view.backgroundColor = [UIColor whiteColor];
    
    _fhvc.headerView.maximumHeight = kFlexibleHeaderMinHeight;
    [self addChildViewController:_fhvc];
    
    // Use a standard UINavigationBar in the flexible header.
    CGRect navBarFrame = CGRectMake(0, 0, _fhvc.headerView.frame.size.width, 44);
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:navBarFrame];
    [navBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    navBar.shadowImage = [[UIImage alloc] init];
    navBar.translucent = YES;
    navBar.tintColor = [UIColor whiteColor];
    
    [self.fhvc.headerView addSubview:navBar];

    navBar.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
      [NSLayoutConstraint constraintWithItem:navBar
                                   attribute:NSLayoutAttributeTop
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self.fhvc.headerView.topSafeAreaGuide
                                   attribute:NSLayoutAttributeBottom
                                  multiplier:1.0
                                    constant:0],
      [NSLayoutConstraint constraintWithItem:navBar
                                   attribute:NSLayoutAttributeBottom
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self.fhvc.headerView
                                   attribute:NSLayoutAttributeBottom
                                  multiplier:1.0
                                    constant:0],
      [NSLayoutConstraint constraintWithItem:navBar
                                   attribute:NSLayoutAttributeLeft
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self.fhvc.headerView
                                   attribute:NSLayoutAttributeLeft
                                  multiplier:1.0
                                    constant:0],
      [NSLayoutConstraint constraintWithItem:navBar
                                   attribute:NSLayoutAttributeRight
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self.fhvc.headerView
                                   attribute:NSLayoutAttributeRight
                                  multiplier:1.0
                                    constant:0]
    ]];

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(doneAction:)];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(doneAction:)];

    [self.navigationItem setLeftBarButtonItem:backItem animated:YES];
    [self.navigationItem setRightBarButtonItem:doneItem animated:YES];
    [navBar setItems:@[self.navigationItem]];
    
    
    if (@available(iOS 13.0, *)) {
        navBar.prefersLargeTitles = YES;
        navBar.largeTitleTextAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor};
        navBar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor};
        navBar.tintColor = UIColor.whiteColor;
        self.navigationItem.title = @"Large Title";
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    }
}

- (void)didTapButton:(id)sender {
  NSLog(@"Button Tapped: %@", sender);
}

- (void)doneAction:(id)sender {
  [super.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
  self.scrollView.backgroundColor = [UIColor whiteColor];
  self.scrollView.autoresizingMask =
      UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [self.view addSubview:self.scrollView];

  self.scrollView.delegate = self;
  self.fhvc.headerView.trackingScrollView = self.scrollView;

  self.fhvc.view.frame = self.view.bounds;
  [self.view addSubview:self.fhvc.view];
  [self.fhvc didMoveToParentViewController:self];

  self.fhvc.headerView.backgroundColor = [UIColor colorWithWhite:(CGFloat)0.1 alpha:1];
}

// This method must be implemented for YYUIFlexibleHeaderViewController's
// YYUIFlexibleHeaderView to properly support YYUIFlexibleHeaderShiftBehavior should you choose
// to customize it.
- (UIViewController *)childViewControllerForStatusBarHidden {
  return self.fhvc;
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  [self.fhvc scrollViewDidScroll:scrollView];
}

#pragma mark - Supplemental

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  self.scrollView.contentSize = self.view.bounds.size;
}

@end

@implementation FlexibleHeaderNavigationBarExample (CatalogByConvention)

+ (NSDictionary *)catalogMetadata {
  return @{
    @"breadcrumbs" : @[ @"Flexible Header", @"Standard UINavigationBar" ],
    @"primaryDemo" : @NO,
    @"presentable" : @NO,
  };
}

- (BOOL)catalogShouldHideNavigation {
  return YES;
}

@end
