//
//  YYUIBottomSheetPresentationController.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/22.
//

#import "YYUIBottomSheetPresentationController.h"

#import <WebKit/WebKit.h>

#import "private/YYUISheetContainerView.h"
#import "YYUIBottomSheetController.h"
#import "YYUIBottomSheetPresentationControllerDelegate.h"
#import "YYUISheetContainerViewDelegate.h"
#import "YYUICGUtilities.h"

static UIScrollView *YYUIBottomSheetGetPrimaryScrollView(UIViewController *viewController) {
  UIScrollView *scrollView = nil;

  // Ensure the view is loaded - occasionally during non-animated transitions the view may not be
  // loaded yet (but the scrollview is still needed for scroll-tracking to work properly).
  if (![viewController isViewLoaded]) {
    (void)viewController.view;
  }

  if ([viewController isKindOfClass:[YYUIBottomSheetController class]]) {
    viewController = ((YYUIBottomSheetController *)viewController).contentViewController;
  }

  if ([viewController.view isKindOfClass:[UIScrollView class]]) {
    scrollView = (UIScrollView *)viewController.view;
  } else if ([viewController.view isKindOfClass:[WKWebView class]]) {
    scrollView = ((WKWebView *)viewController.view).scrollView;
  } else if ([viewController isKindOfClass:[UICollectionViewController class]]) {
    scrollView = ((UICollectionViewController *)viewController).collectionView;
  }
  return scrollView;
}

@interface YYUIBottomSheetPresentationController () <YYUISheetContainerViewDelegate>
@end

@interface YYUIBottomSheetPresentationController ()
@property(nonatomic, strong) YYUISheetContainerView *sheetView;
@end

@implementation YYUIBottomSheetPresentationController {
  UIView *_dimmingView;
 @private
  UIColor *_scrimColor;
 @private
  BOOL _scrimIsAccessibilityElement;
 @private
  NSString *_scrimAccessibilityLabel;
 @private
  NSString *_scrimAccessibilityHint;
 @private
  UIAccessibilityTraits _scrimAccessibilityTraits;
}

@synthesize delegate;

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                       presentingViewController:(UIViewController *)presentingViewController {
  self = [super initWithPresentedViewController:presentedViewController
                       presentingViewController:presentingViewController];
  if (self) {
    _adjustHeightForSafeAreaInsets = YES;
    _simulateScrollViewBounce = YES;
    _ignoreKeyboardHeight = NO;
  }
  return self;
}

- (UIView *)presentedView {
  return self.sheetView;
}

- (CGRect)frameOfPresentedViewInContainerView {
  CGSize containerSize = self.containerView.frame.size;
  CGSize preferredSize = self.presentedViewController.preferredContentSize;

  if (preferredSize.width > 0 && preferredSize.width < containerSize.width) {
    // We only customize the width and not the height here. YYUISheetContainerView lays out the
    // presentedView taking the preferred height in to account.
    CGFloat width = preferredSize.width;
    CGFloat leftPad = (containerSize.width - width) / 2;
    return CGRectMake(leftPad, 0, width, containerSize.height);
  } else {
    return [super frameOfPresentedViewInContainerView];
  }
}

- (void)presentationTransitionWillBegin {
  id<YYUIBottomSheetPresentationControllerDelegate> strongDelegate = self.delegate;
  if ([strongDelegate respondsToSelector:@selector(prepareForBottomSheetPresentation:)]) {
    [strongDelegate prepareForBottomSheetPresentation:self];
  }

  UIView *containerView = [self containerView];

  _dimmingView = [[UIView alloc] initWithFrame:self.containerView.bounds];
  _dimmingView.backgroundColor =
      _scrimColor ? _scrimColor : [UIColor colorWithWhite:0 alpha:(CGFloat)0.4];
  _dimmingView.translatesAutoresizingMaskIntoConstraints = NO;
  _dimmingView.autoresizingMask =
      UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  _dimmingView.accessibilityTraits |= UIAccessibilityTraitButton;
  _dimmingView.isAccessibilityElement = _scrimIsAccessibilityElement;
  _dimmingView.accessibilityTraits = _scrimAccessibilityTraits;
  _dimmingView.accessibilityLabel = _scrimAccessibilityLabel;
  _dimmingView.accessibilityHint = _scrimAccessibilityHint;

  _dismissOnDraggingDownSheet = YES;

  UIScrollView *scrollView = self.trackingScrollView;
  if (scrollView == nil) {
    scrollView = YYUIBottomSheetGetPrimaryScrollView(self.presentedViewController);
  }
  CGRect sheetFrame = [self frameOfPresentedViewInContainerView];
  if (self.shouldPropagateSafeAreaInsetsToPresentedViewController) {
    if (@available(iOS 11.0, *)) {
      self.presentedViewController.additionalSafeAreaInsets =
          self.presentingViewController.view.safeAreaInsets;
    }
  }
  self.sheetView = [[YYUISheetContainerView alloc] initWithFrame:sheetFrame
                                                    contentView:self.presentedViewController.view
                                                     scrollView:scrollView
                                       simulateScrollViewBounce:self.simulateScrollViewBounce];
  self.sheetView.delegate = self;
  self.sheetView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
  self.sheetView.dismissOnDraggingDownSheet = self.dismissOnDraggingDownSheet;
  self.sheetView.adjustHeightForSafeAreaInsets = self.adjustHeightForSafeAreaInsets;
  self.sheetView.ignoreKeyboardHeight = self.ignoreKeyboardHeight;

  [containerView addSubview:_dimmingView];
  [containerView addSubview:self.sheetView];

  [self updatePreferredSheetHeight];

  // Add tap handler to dismiss the sheet.
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(dismissPresentedControllerIfNecessary:)];
  tapGesture.cancelsTouchesInView = NO;
  containerView.userInteractionEnabled = YES;
  [containerView addGestureRecognizer:tapGesture];

  id<UIViewControllerTransitionCoordinator> transitionCoordinator =
      [[self presentingViewController] transitionCoordinator];

  // Fade in the dimming view during the transition.
  _dimmingView.alpha = 0.0;
  [transitionCoordinator
      animateAlongsideTransition:^(
          __unused id<UIViewControllerTransitionCoordinatorContext> context) {
        self->_dimmingView.alpha = 1.0;
      }
                      completion:nil];
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
  if (!completed) {
    [_dimmingView removeFromSuperview];
  }
}

- (void)dismissalTransitionWillBegin {
  id<UIViewControllerTransitionCoordinator> transitionCoordinator =
      [[self presentingViewController] transitionCoordinator];

  [transitionCoordinator
      animateAlongsideTransition:^(
          __unused id<UIViewControllerTransitionCoordinatorContext> context) {
        self->_dimmingView.alpha = 0.0;
      }
                      completion:nil];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
  if (completed) {
    [_dimmingView removeFromSuperview];
  }
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container {
  [super preferredContentSizeDidChangeForChildContentContainer:container];
  self.sheetView.frame = [self frameOfPresentedViewInContainerView];
  [self.sheetView layoutIfNeeded];
  [self updatePreferredSheetHeight];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

  [coordinator
      animateAlongsideTransition:^(
          __unused id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
        self.sheetView.frame = [self frameOfPresentedViewInContainerView];
        [self.sheetView layoutIfNeeded];
        [self updatePreferredSheetHeight];
      }
                      completion:nil];
}

/**
 Sets the new value of @c sheetView.preferredSheetHeight.
 If @c preferredContentHeight is non-positive, it will set it to half of sheetView's
 frame's height.
 */
- (void)updatePreferredSheetHeight {
  // If |preferredSheetHeight| has not been specified, use half of the current height.
  CGFloat preferredSheetHeight;
  if (self.preferredSheetHeight > 0) {
    preferredSheetHeight = self.preferredSheetHeight;
  } else {
    preferredSheetHeight = self.presentedViewController.preferredContentSize.height;
  }

  if (CGFloatEqual(preferredSheetHeight, 0)) {
    preferredSheetHeight = round(CGRectGetHeight(self.sheetView.frame) / 2);
  }
  self.sheetView.preferredSheetHeight = preferredSheetHeight;
}

- (void)dismissPresentedControllerIfNecessary:(UITapGestureRecognizer *)tapRecognizer {
  if (!_dismissOnBackgroundTap) {
    return;
  }
  // Only dismiss if the tap is outside of the presented view.
  UIView *contentView = self.presentedViewController.view;
  CGPoint pointInContentView = [tapRecognizer locationInView:contentView];
  if ([contentView pointInside:pointInContentView withEvent:nil]) {
    return;
  }

  self.sheetView.willBeDismissed = YES;
  id<YYUIBottomSheetPresentationControllerDelegate> strongDelegate = self.delegate;
  [self.presentingViewController
      dismissViewControllerAnimated:YES
                         completion:^{
                           if ([strongDelegate
                                   respondsToSelector:@selector
                                   (bottomSheetPresentationControllerDismissalAnimationCompleted:
                                           )]) {
                             [strongDelegate
                                 bottomSheetPresentationControllerDismissalAnimationCompleted:self];
                           }
                         }];

  if ([strongDelegate
          respondsToSelector:@selector(bottomSheetPresentationControllerDidDismissBottomSheet:)]) {
    [strongDelegate bottomSheetPresentationControllerDidDismissBottomSheet:self];
  }
}

#pragma mark - Properties

- (void)setScrimColor:(UIColor *)scrimColor {
  _scrimColor = scrimColor;
  _dimmingView.backgroundColor = scrimColor;
}

- (UIColor *)scrimColor {
  return _scrimColor;
}

- (void)setIsScrimAccessibilityElement:(BOOL)isScrimAccessibilityElement {
  _scrimIsAccessibilityElement = isScrimAccessibilityElement;
  _dimmingView.isAccessibilityElement = isScrimAccessibilityElement;
}

- (BOOL)isScrimAccessibilityElement {
  return _scrimIsAccessibilityElement;
}

- (void)setScrimAccessibilityLabel:(NSString *)scrimAccessibilityLabel {
  _scrimAccessibilityLabel = scrimAccessibilityLabel;
  _dimmingView.accessibilityLabel = scrimAccessibilityLabel;
}

- (NSString *)scrimAccessibilityLabel {
  return _scrimAccessibilityLabel;
}

- (void)setScrimAccessibilityHint:(NSString *)scrimAccessibilityHint {
  _scrimAccessibilityHint = scrimAccessibilityHint;
  _dimmingView.accessibilityHint = scrimAccessibilityHint;
}

- (NSString *)scrimAccessibilityHint {
  return _scrimAccessibilityHint;
}

- (void)setScrimAccessibilityTraits:(UIAccessibilityTraits)scrimAccessibilityTraits {
  _scrimAccessibilityTraits = scrimAccessibilityTraits;
  _dimmingView.accessibilityTraits = scrimAccessibilityTraits;
}

- (UIAccessibilityTraits)scrimAccessibilityTraits {
  return _scrimAccessibilityTraits;
}

- (void)setPreferredSheetHeight:(CGFloat)preferredSheetHeight {
  _preferredSheetHeight = preferredSheetHeight;
  [self updatePreferredSheetHeight];
}

- (void)setAdjustHeightForSafeAreaInsets:(BOOL)adjustHeightForSafeAreaInsets {
  _adjustHeightForSafeAreaInsets = adjustHeightForSafeAreaInsets;
  if (_sheetView) {
    _sheetView.adjustHeightForSafeAreaInsets = adjustHeightForSafeAreaInsets;
  }
}

- (void)setIgnoreKeyboardHeight:(BOOL)ignoreKeyboardHeight {
  _ignoreKeyboardHeight = ignoreKeyboardHeight;
  if (_sheetView) {
    _sheetView.ignoreKeyboardHeight = ignoreKeyboardHeight;
  }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
  [super traitCollectionDidChange:previousTraitCollection];

  if (self.traitCollectionDidChangeBlock) {
    self.traitCollectionDidChangeBlock(self, previousTraitCollection);
  }
}

- (void)setDismissOnDraggingDownSheet:(BOOL)dismissOnDraggingDownSheet {
  _dismissOnDraggingDownSheet = dismissOnDraggingDownSheet;
  if (self.sheetView) {
    self.sheetView.dismissOnDraggingDownSheet = dismissOnDraggingDownSheet;
  }
}

#pragma mark - YYUISheetContainerViewDelegate

- (void)sheetContainerViewDidHide:(nonnull __unused YYUISheetContainerView *)containerView {
  id<YYUIBottomSheetPresentationControllerDelegate> strongDelegate = self.delegate;
  [self.presentingViewController
      dismissViewControllerAnimated:YES
                         completion:^{
                           if ([strongDelegate
                                   respondsToSelector:@selector
                                   (bottomSheetPresentationControllerDismissalAnimationCompleted:
                                           )]) {
                             [strongDelegate
                                 bottomSheetPresentationControllerDismissalAnimationCompleted:self];
                           }
                         }];

  if ([strongDelegate
          respondsToSelector:@selector(bottomSheetPresentationControllerDidDismissBottomSheet:)]) {
    [strongDelegate bottomSheetPresentationControllerDidDismissBottomSheet:self];
  }
}

- (void)sheetContainerViewWillChangeState:(nonnull YYUISheetContainerView *)containerView
                               sheetState:(YYUIBottomSheetState)sheetState {
  id<YYUIBottomSheetPresentationControllerDelegate> strongDelegate = self.delegate;
  if ([strongDelegate respondsToSelector:@selector(bottomSheetWillChangeState:sheetState:)]) {
    [strongDelegate bottomSheetWillChangeState:self sheetState:sheetState];
  }
}

- (void)sheetContainerViewDidChangeYOffset:(nonnull YYUISheetContainerView *)containerView
                                   yOffset:(CGFloat)yOffset {
  id<YYUIBottomSheetPresentationControllerDelegate> strongDelegate = self.delegate;
  if ([strongDelegate respondsToSelector:@selector(bottomSheetDidChangeYOffset:yOffset:)]) {
    [strongDelegate bottomSheetDidChangeYOffset:self yOffset:yOffset];
  }
}

@end

