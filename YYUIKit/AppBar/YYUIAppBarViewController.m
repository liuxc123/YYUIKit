//
//  YYUIAppBarViewController.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/17.
//

#import "YYUIAppBarViewController.h"

#import "YYUIAppBarContainerViewController.h"

#import "YYUIAppBarViewControllerAccessibilityPerformEscapeDelegate.h"
#import "YYUIFlexibleHeader.h"
#import "YYUIHeaderStackView.h"
#import "YYUINavigationBar.h"
#import "YYUIShadowLayer.h"
#import "YYUIResource.h"
#import "UIApplication+YYUIAdd.h"

static NSString *const kBarStackKey = @"barStack";

@implementation YYUIAppBarViewController {
    NSLayoutConstraint *_verticalConstraint;
    NSLayoutConstraint *_topSafeAreaConstraint;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self YYUIAppBarViewController_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self YYUIAppBarViewController_commonInit];
    }
    return self;
}

- (void)YYUIAppBarViewController_commonInit {
    // Shadow layer
    __weak YYUIAppBarViewController *weakSelf = self;
    YYUIFlexibleHeaderShadowIntensityChangeBlock intensityBlock =
    ^(CALayer *_Nonnull shadowLayer, CGFloat intensity) {
        CGFloat elevation = 4.0 * intensity;
        weakSelf.headerView.elevation = elevation;
        [(YYUIShadowLayer *)shadowLayer setElevation:elevation];
    };
    [self.headerView setShadowLayer:[YYUIShadowLayer layer] intensityDidChangeBlock:intensityBlock];
    
    [self.headerView forwardTouchEventsForView:self.headerStackView];
    [self.headerView forwardTouchEventsForView:self.navigationBar];
    
    self.headerStackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.headerStackView.topBar = self.navigationBar;
}

#pragma mark - Properties

- (YYUIHeaderStackView *)headerStackView {
    // Removed call to loadView here as we should never be calling it manually.
    // It previously replaced loadViewIfNeeded call that is only iOS 9.0+ to
    // make backwards compatible.
    // Underlying issue is you need view loaded before accessing. Below change will accomplish that
    // by calling for view.bounds initializing the stack view
    if (!_headerStackView) {
        _headerStackView = [[YYUIHeaderStackView alloc] initWithFrame:CGRectZero];
    }
    return _headerStackView;
}

- (YYUINavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[YYUINavigationBar alloc] init];
        [_navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        _navigationBar.shadowImage = [[UIImage alloc] init];
        [_navigationBar setTranslucent:NO];
    }
    return _navigationBar;
}

- (YYUIBackBarButtonItem *)backButtonItem {
    UIViewController *parent = self.parentViewController;
    UINavigationController *navigationController = parent.navigationController;
    
    NSArray<UIViewController *> *viewControllerStack = navigationController.viewControllers;
    
    // This will be zero if there is no navigation controller, so a view controller which is not
    // inside a navigation controller will be treated the same as a view controller at the root of a
    // navigation controller
    NSUInteger index = [viewControllerStack indexOfObject:parent];
    
    UIViewController *iterator = parent;
    
    // In complex cases it might actually be a parent of @c fhvParent which is on the nav stack.
    while (index == NSNotFound && iterator && ![iterator isEqual:navigationController]) {
        iterator = iterator.parentViewController;
        index = [viewControllerStack indexOfObject:iterator];
    }
    
    if (index == NSNotFound) {
        NSCAssert(NO, @"View controller not present in its own navigation controller.");
        // This is not something which should ever happen, but just in case.
        return nil;
    }
    if (index == 0) {
        // The view controller is at the root of a navigation stack (or not in one).
        return nil;
    }
    UIViewController *previousViewControler = navigationController.viewControllers[index - 1];
    if ([previousViewControler isKindOfClass:[YYUIAppBarContainerViewController class]]) {
        // Special case: if the previous view controller is a container controller, use its content
        // view controller.
        YYUIAppBarContainerViewController *chvc =
        (YYUIAppBarContainerViewController *)previousViewControler;
        previousViewControler = chvc.contentViewController;
    }
    YYUIBackBarButtonItem *backBarButtonItem = self.navigationBar.backBarButtonItem;
    if (!backBarButtonItem) {
        UIImage *backButtonImage = [[YYUIResource imageWithName:@"ic_arrow_back_ios"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        backBarButtonItem = [[YYUIBackBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStyleDone tintColor:nil];
    }
    backBarButtonItem.accessibilityIdentifier = @"back_bar_button";
    backBarButtonItem.accessibilityLabel = @"Back";
    return backBarButtonItem;
}

- (void)addSubviewsToParent {
    YYUIAppBarViewController *abvc = self;
    NSAssert(abvc.parentViewController,
             @"appBarViewController does not have a parentViewController. "
             @"Use [self addChildViewController:appBarViewController]. "
             @"This warning only appears in DEBUG builds");
    if (abvc.view.superview == abvc.parentViewController.view) {
        return;
    }
    
    // Enforce the header's desire to fully cover the width of its parent view.
    CGRect frame = abvc.view.frame;
    frame.origin.x = 0;
    frame.size.width = abvc.parentViewController.view.bounds.size.width;
    abvc.view.frame = frame;
    
    [abvc.parentViewController.view addSubview:abvc.view];
    [abvc didMoveToParentViewController:abvc.parentViewController];
}

- (void)setShouldAdjustHeightBasedOnHeaderStackView:(BOOL)shouldAdjustHeightBasedOnHeaderStackView {
    _shouldAdjustHeightBasedOnHeaderStackView = shouldAdjustHeightBasedOnHeaderStackView;
    if (shouldAdjustHeightBasedOnHeaderStackView) {
        self.headerView.minMaxHeightIncludesSafeArea = NO;
        [self adjustHeightBasedOnHeaderStackView];
    }
}

- (void)setInferTopSafeAreaInsetFromViewController:(BOOL)inferTopSafeAreaInsetFromViewController {
    [super setInferTopSafeAreaInsetFromViewController:inferTopSafeAreaInsetFromViewController];
    
    if (inferTopSafeAreaInsetFromViewController) {
        self.topLayoutGuideAdjustmentEnabled = YES;
    }
    
    _verticalConstraint.active = !self.inferTopSafeAreaInsetFromViewController;
    _topSafeAreaConstraint.active = self.inferTopSafeAreaInsetFromViewController;
}

- (void)setHeaderStackViewOffset:(CGFloat)headerStackViewOffset {
    _headerStackViewOffset = headerStackViewOffset;
    _verticalConstraint.constant = [self verticalContraintLength];
    _topSafeAreaConstraint.constant = [self topSafeAreaContraintLength];
}

#pragma mark - UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.headerStackView];
    
    // Bar stack expands vertically, but has a margin above it for the status bar.
    NSArray<NSLayoutConstraint *> *horizontalConstraints = [NSLayoutConstraint
                                                            constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|[%@]|", kBarStackKey]
                                                            options:0
                                                            metrics:nil
                                                            views:@{kBarStackKey : self.headerStackView}];
    [self.view addConstraints:horizontalConstraints];
    
    CGFloat topMargin = [self verticalContraintLength];
    _verticalConstraint = [NSLayoutConstraint constraintWithItem:self.headerStackView
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:self.view
                                                       attribute:NSLayoutAttributeTop
                                                      multiplier:1
                                                        constant:topMargin];
    _verticalConstraint.active = !self.inferTopSafeAreaInsetFromViewController;
    
    _topSafeAreaConstraint =
    [NSLayoutConstraint constraintWithItem:self.headerStackView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.headerView.topSafeAreaGuide
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:[self topSafeAreaContraintLength]];
    _topSafeAreaConstraint.active = self.inferTopSafeAreaInsetFromViewController;
    
    [NSLayoutConstraint constraintWithItem:self.headerStackView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:0]
        .active = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    YYUIBackBarButtonItem *backBarButtonItem = [self backButtonItem];
    if (backBarButtonItem && !self.navigationBar.backBarButtonItem) {
        self.navigationBar.backBarButtonItem = backBarButtonItem;
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if (@available(iOS 11.0, *)) {
        // We only update the top inset on iOS 11 because previously we were not adjusting the header
        // height to make it smaller when the status bar is hidden.
        _verticalConstraint.constant = [self verticalContraintLength];
    }
    
    if (self.shouldAdjustHeightBasedOnHeaderStackView) {
        [self adjustHeightBasedOnHeaderStackView];
    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
    
    [self.navigationBar observeNavigationItem:parent.navigationItem];
    [self.navigationBar setViewController:parent];
    
    CGRect frame = self.view.frame;
    frame.size.width = CGRectGetWidth(parent.view.bounds);
    self.view.frame = frame;
}

#pragma mark - UIAccessibility

- (BOOL)accessibilityPerformEscape {
    if (self.accessibilityPerformEscapeDelegate) {
        return [self.accessibilityPerformEscapeDelegate
                appBarViewControllerAccessibilityPerformEscape:self];
    }
    
    // Fall-back behavior.
    [self dismissSelf];
    return YES;
}

#pragma mark User actions

- (void)didTapBackButton:(__unused id)sender {
    [self dismissSelf];
}

- (void)dismissSelf {
    UIViewController *pvc = self.parentViewController;
    if (pvc.navigationController && pvc.navigationController.viewControllers.count > 1) {
        [pvc.navigationController popViewControllerAnimated:YES];
    } else {
        [pvc dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Private

- (CGFloat)verticalContraintLength {
    return [UIApplication safeAreaInsets].top + _headerStackViewOffset;
}

- (CGFloat)topSafeAreaContraintLength {
    return _headerStackViewOffset;
}

- (void)adjustHeightBasedOnHeaderStackView {
    CGFloat heightSum = 0;
    heightSum += [self.headerStackView.topBar sizeThatFits:self.view.bounds.size].height;
    heightSum += [self.headerStackView.bottomBar sizeThatFits:self.view.bounds.size].height;
    heightSum += _headerStackViewOffset;
    self.headerView.minimumHeight = heightSum;
    self.headerView.maximumHeight = heightSum;
}

@end
