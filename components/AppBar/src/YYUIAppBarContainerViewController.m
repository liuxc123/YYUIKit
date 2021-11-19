//
//  YYUIAppBarContainerViewController.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/17.
//

#import "YYUIAppBarContainerViewController.h"

#import "YYUIAppBarViewController.h"
#import "YYFlexibleHeader.h"
#import "YYNavigationBar.h"

@interface YYUIAppBarContainerViewController ()

// To be deprecated APIs; re-declared here in order to be auto-synthesized.
@property(nonatomic, getter=isTopLayoutGuideAdjustmentEnabled) BOOL topLayoutGuideAdjustmentEnabled;
@property(nonatomic, strong, nonnull, readonly) YYUIAppBar *appBar;

@end

@implementation YYUIAppBarContainerViewController

- (instancetype)initWithContentViewController:(UIViewController *)contentViewController {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _appBar = [[YYUIAppBar alloc] init];

    [self addChildViewController:_appBar.appBarViewController];

    _contentViewController = contentViewController;
    [self addChildViewController:contentViewController];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.view addSubview:self.contentViewController.view];
  [self.contentViewController didMoveToParentViewController:self];

  [_appBar addSubviewsToParent];

  [_appBar.navigationBar observeNavigationItem:_contentViewController.navigationItem];
  [_appBar.navigationBar setViewController:_contentViewController];

  [self updateTopLayoutGuideBehavior];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  if (!self.topLayoutGuideAdjustmentEnabled) {
    [_appBar.appBarViewController updateTopLayoutGuide];
  }
}

- (BOOL)prefersStatusBarHidden {
  return self.appBar.appBarViewController.prefersStatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return self.appBar.appBarViewController.preferredStatusBarStyle;
}

- (BOOL)shouldAutorotate {
  return self.contentViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
  return self.contentViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
  return self.contentViewController.preferredInterfaceOrientationForPresentation;
}

- (YYUIAppBarViewController *)appBarViewController {
  return _appBar.appBarViewController;
}

#pragma mark - Enabling top layout guide adjustment behavior

- (void)updateTopLayoutGuideBehavior {
  if (self.topLayoutGuideAdjustmentEnabled) {
    if ([self isViewLoaded]) {
      self.contentViewController.view.translatesAutoresizingMaskIntoConstraints = YES;
      self.contentViewController.view.autoresizingMask =
          (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
      self.contentViewController.view.frame = self.view.bounds;
    }

    // The flexible header view controller, by default, will assume that it is a child view
    // controller of the content view controller and modify its parent view controller's
    // topLayoutGuide. With an App Bar container view controller, however, our flexible header's
    // parent is the app bar container view controller instead. There does not appear to be a way to
    // make two top layout guides constrain to one other
    // (e.g. self.topLayoutGuide == self.contentViewController.topLayoutGuide) so instead we must
    // tell the flexible header controller which view controller it should modify.
    self.appBar.appBarViewController.topLayoutGuideViewController = self.contentViewController;

  } else {
    self.appBar.appBarViewController.topLayoutGuideViewController = nil;
  }
}

- (void)setTopLayoutGuideAdjustmentEnabled:(BOOL)topLayoutGuideAdjustmentEnabled {
  if (_topLayoutGuideAdjustmentEnabled == topLayoutGuideAdjustmentEnabled) {
    return;
  }
  _topLayoutGuideAdjustmentEnabled = topLayoutGuideAdjustmentEnabled;

  [self updateTopLayoutGuideBehavior];
}

@end
