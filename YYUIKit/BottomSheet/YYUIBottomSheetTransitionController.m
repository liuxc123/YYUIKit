//
//  YYUIBottomSheetTransitionController.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/22.
//

#import "YYUIBottomSheetTransitionController.h"

#import "YYUIBottomSheetPresentationController.h"

static const NSTimeInterval YYUIBottomSheetTransitionDuration = 0.25;

@interface YYUIBottomSheetTransitionController ()
@property(nonatomic, weak, nullable)
    YYUIBottomSheetPresentationController *currentPresentationController;
@end

@implementation YYUIBottomSheetTransitionController {
 @protected
  UIColor *_scrimColor;
 @protected
  BOOL _isScrimAccessibilityElement;
 @protected
  NSString *_scrimAccessibilityLabel;
 @protected
  NSString *_scrimAccessibilityHint;
 @protected
  UIAccessibilityTraits _scrimAccessibilityTraits;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (instancetype)init {
  self = [super init];
  if (self) {
    _scrimAccessibilityTraits = UIAccessibilityTraitButton;
    _adjustHeightForSafeAreaInsets = YES;
  }
  return self;
}

- (UIPresentationController *)
    presentationControllerForPresentedViewController:(UIViewController *)presented
                            presentingViewController:(UIViewController *)presenting
                                sourceViewController:(__unused UIViewController *)source {
  YYUIBottomSheetPresentationController *presentationController =
      [[YYUIBottomSheetPresentationController alloc] initWithPresentedViewController:presented
                                                           presentingViewController:presenting];
  presentationController.trackingScrollView = self.trackingScrollView;
  presentationController.dismissOnBackgroundTap = self.dismissOnBackgroundTap;
  presentationController.dismissOnDraggingDownSheet = self.dismissOnDraggingDownSheet;
  presentationController.scrimColor = _scrimColor;
  presentationController.scrimAccessibilityTraits = _scrimAccessibilityTraits;
  presentationController.isScrimAccessibilityElement = _isScrimAccessibilityElement;
  presentationController.scrimAccessibilityHint = _scrimAccessibilityHint;
  presentationController.scrimAccessibilityLabel = _scrimAccessibilityLabel;
  presentationController.preferredSheetHeight = _preferredSheetHeight;
  presentationController.adjustHeightForSafeAreaInsets = _adjustHeightForSafeAreaInsets;
  presentationController.ignoreKeyboardHeight = _ignoreKeyboardHeight;
  _currentPresentationController = presentationController;
  return presentationController;
}

- (nullable id<UIViewControllerAnimatedTransitioning>)
    animationControllerForPresentedController:(__unused UIViewController *)presented
                         presentingController:(__unused UIViewController *)presenting
                             sourceController:(__unused UIViewController *)source {
  return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:
    (__unused UIViewController *)dismissed {
  return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:
    (nullable __unused id<UIViewControllerContextTransitioning>)transitionContext {
  return YYUIBottomSheetTransitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  // If a view in the transitionContext is nil, it likely hasn't been loaded by its ViewController
  // yet.  Ask for it directly to initiate a loadView on the ViewController.
  UIViewController *fromViewController =
      [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
  if (fromView == nil) {
    fromView = fromViewController.view;
  }

  UIViewController *toViewController =
      [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
  if (toView == nil) {
    toView = toViewController.view;
  }

  UIViewController *toPresentingViewController = toViewController.presentingViewController;
  BOOL presenting = (toPresentingViewController == fromViewController) ? YES : NO;

  UIViewController *animatingViewController = presenting ? toViewController : fromViewController;
  UIView *animatingView = presenting ? toView : fromView;

  UIView *containerView = transitionContext.containerView;

  if (presenting) {
    [containerView addSubview:toView];
  }

  CGRect onscreenFrame = [self frameOfPresentedViewController:animatingViewController
                                              inContainerView:containerView];
  CGRect offscreenFrame = CGRectOffset(onscreenFrame, 0, containerView.frame.size.height);

  CGRect initialFrame = presenting ? offscreenFrame : onscreenFrame;
  CGRect finalFrame = presenting ? onscreenFrame : offscreenFrame;

  animatingView.frame = initialFrame;

  NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
  UIViewAnimationOptions options =
      UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState;

  [UIView animateWithDuration:transitionDuration
      delay:0.0
      options:options
      animations:^{
        animatingView.frame = finalFrame;
      }
      completion:^(__unused BOOL finished) {
        // If we're dismissing, remove the presented view from the hierarchy
        if (!presenting) {
          [fromView removeFromSuperview];
        }

        // From ADC : UIViewControllerContextTransitioning
        // When you do create transition animations, always call the
        // completeTransition: from an appropriate completion block to let UIKit know
        // when all of your animations have finished.
        [transitionContext completeTransition:YES];
      }];
}

- (CGRect)frameOfPresentedViewController:(UIViewController *)presentedViewController
                         inContainerView:(UIView *)containerView {
  CGSize containerSize = containerView.frame.size;
  CGSize preferredSize = presentedViewController.preferredContentSize;

  if (preferredSize.width > 0 && preferredSize.width < containerSize.width) {
    CGFloat width = preferredSize.width;
    CGFloat leftPad = (containerSize.width - width) / 2;
    return CGRectMake(leftPad, 0, width, containerSize.height);
  } else {
    return CGRectStandardize(containerView.bounds);
  }
}

- (void)setScrimColor:(UIColor *)scrimColor {
  _scrimColor = scrimColor;
  _currentPresentationController.scrimColor = scrimColor;
}

- (UIColor *)scrimColor {
  return _scrimColor;
}

- (void)setAdjustHeightForSafeAreaInsets:(BOOL)adjustHeightForSafeAreaInsets {
  _adjustHeightForSafeAreaInsets = adjustHeightForSafeAreaInsets;
  _currentPresentationController.adjustHeightForSafeAreaInsets = adjustHeightForSafeAreaInsets;
}

- (void)setIgnoreKeyboardHeight:(BOOL)ignoreKeyboardHeight {
  _ignoreKeyboardHeight = ignoreKeyboardHeight;
  _currentPresentationController.ignoreKeyboardHeight = ignoreKeyboardHeight;
}

- (void)setIsScrimAccessibilityElement:(BOOL)isScrimAccessibilityElement {
  _isScrimAccessibilityElement = isScrimAccessibilityElement;
  _currentPresentationController.isScrimAccessibilityElement = isScrimAccessibilityElement;
}

- (BOOL)isScrimAccessibilityElement {
  return _isScrimAccessibilityElement;
}

- (void)setScrimAccessibilityLabel:(NSString *)scrimAccessibilityLabel {
  _scrimAccessibilityLabel = scrimAccessibilityLabel;
  _currentPresentationController.scrimAccessibilityLabel = scrimAccessibilityLabel;
}

- (NSString *)scrimAccessibilityLabel {
  return _scrimAccessibilityLabel;
}

- (void)setScrimAccessibilityHint:(NSString *)scrimAccessibilityHint {
  _scrimAccessibilityHint = scrimAccessibilityHint;
  _currentPresentationController.scrimAccessibilityHint = scrimAccessibilityHint;
}

- (NSString *)scrimAccessibilityHint {
  return _scrimAccessibilityHint;
}

- (void)setScrimAccessibilityTraits:(UIAccessibilityTraits)scrimAccessibilityTraits {
  _scrimAccessibilityTraits = scrimAccessibilityTraits;
  _currentPresentationController.scrimAccessibilityTraits = scrimAccessibilityTraits;
}

- (UIAccessibilityTraits)scrimAccessibilityTraits {
  return _scrimAccessibilityTraits;
}

@end

