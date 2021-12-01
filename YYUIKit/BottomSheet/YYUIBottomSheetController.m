//
//  YYUIBottomSheetController.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/22.
//

#import "YYUIBottomSheetController.h"

#import "YYUIBottomSheetControllerDelegate.h"
#import "YYUIBottomSheetPresentationController.h"
#import "YYUIBottomSheetPresentationControllerDelegate.h"
#import "YYUIBottomSheetTransitionController.h"
#import "YYUIBottomSheetState.h"
#import "UIViewController+YYUIBottomSheet.h"
#import "YYUIElevation.h"
#import "YYUIShape.h"
#import "YYUICGUtilities.h"

static const CGFloat kElevationSpreadMaskAffordance = 50.0f;

@interface YYUIBottomSheetController () <YYUIBottomSheetPresentationControllerDelegate>
@property(nonatomic, readonly, strong) YYUIShapedView *view;
@end

@implementation YYUIBottomSheetController {
  YYUIBottomSheetTransitionController *_transitionController;
  NSMutableDictionary<NSNumber *, id<YYUIShapeGenerating>> *_shapeGenerators;
}

@synthesize yyui_overrideBaseElevation = _yyui_overrideBaseElevation;
@synthesize yyui_elevationDidChangeBlock = _yyui_elevationDidChangeBlock;
@dynamic view;

- (void)loadView {
  self.view = [[YYUIShapedView alloc] initWithFrame:CGRectZero];
  self.view.elevation = self.elevation;
}

- (nonnull instancetype)initWithContentViewController:
    (nonnull UIViewController *)contentViewController {
  if (self = [super initWithNibName:nil bundle:nil]) {
    _contentViewController = contentViewController;
    _transitionController = [[YYUIBottomSheetTransitionController alloc] init];
    _transitionController.dismissOnBackgroundTap = YES;
    _transitionController.dismissOnDraggingDownSheet = YES;
    _transitionController.adjustHeightForSafeAreaInsets = YES;
    super.transitioningDelegate = _transitionController;
    super.modalPresentationStyle = UIModalPresentationCustom;
    _shapeGenerators = [NSMutableDictionary dictionary];
    if (UIAccessibilityIsVoiceOverRunning()) {
      _state = YYUIBottomSheetStateExtended;
    } else {
      _state = YYUIBottomSheetStatePreferred;
    }
    _elevation = 16.0;
    _yyui_overrideBaseElevation = -1;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.preservesSuperviewLayoutMargins = YES;
  if (self.contentViewController) {
    self.contentViewController.view.autoresizingMask =
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.contentViewController.view.frame = self.view.bounds;
    [self addChildViewController:self.contentViewController];
    [self.view addSubview:self.contentViewController.view];
    [self.contentViewController didMoveToParentViewController:self];
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
  self.yyui_bottomSheetPresentationController.delegate = self;
#pragma clang diagnostic pop

  self.yyui_bottomSheetPresentationController.dismissOnBackgroundTap =
      _transitionController.dismissOnBackgroundTap;
  self.yyui_bottomSheetPresentationController.dismissOnDraggingDownSheet =
      _transitionController.dismissOnDraggingDownSheet;

  self.contentViewController.view.frame = self.view.bounds;
  [self.contentViewController.view layoutIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  if (self.shouldFlashScrollIndicatorsOnAppearance) {
    [self.trackingScrollView flashScrollIndicators];
  }
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  self.view.layer.mask = [self createBottomEdgeElevationMask];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
  return self.contentViewController.supportedInterfaceOrientations;
}

- (BOOL)accessibilityPerformEscape {
  if (!self.dismissOnBackgroundTap) {
    return NO;
  }
  __weak YYUIBottomSheetController *weakSelf = self;
  [self dismissViewControllerAnimated:YES
                           completion:^{
                             __strong YYUIBottomSheetController *strongSelf = weakSelf;
                             if ([strongSelf.delegate
                                     respondsToSelector:@selector
                                     (bottomSheetControllerDidDismissBottomSheet:)]) {
                               [strongSelf.delegate
                                   bottomSheetControllerDidDismissBottomSheet:strongSelf];
                             }
                           }];
  return YES;
}

- (CGSize)preferredContentSize {
  return self.contentViewController.preferredContentSize;
}

- (void)setPreferredContentSize:(CGSize)preferredContentSize {
  self.contentViewController.preferredContentSize = preferredContentSize;
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container {
  [super preferredContentSizeDidChangeForChildContentContainer:container];
  // Informing the presentation controller of the change in preferred content size needs to be done
  // directly since the YYUIBottomSheetController's preferredContentSize property is backed by
  // contentViewController's preferredContentSize. Therefore |[super setPreferredContentSize:]| is
  // never called, and UIKit never calls |preferredContentSizeDidChangeForChildContentContainer:|
  // on the presentation controller.
  [self.presentationController preferredContentSizeDidChangeForChildContentContainer:self];
}

- (UIScrollView *)trackingScrollView {
  return _transitionController.trackingScrollView;
}

- (void)setTrackingScrollView:(UIScrollView *)trackingScrollView {
  _transitionController.trackingScrollView = trackingScrollView;
}

- (BOOL)dismissOnBackgroundTap {
  return _transitionController.dismissOnBackgroundTap;
}

- (void)setDismissOnBackgroundTap:(BOOL)dismissOnBackgroundTap {
  _transitionController.dismissOnBackgroundTap = dismissOnBackgroundTap;
  self.yyui_bottomSheetPresentationController.dismissOnBackgroundTap = dismissOnBackgroundTap;
}

- (BOOL)dismissOnDraggingDownSheet {
  return _transitionController.dismissOnDraggingDownSheet;
}

- (void)setDismissOnDraggingDownSheet:(BOOL)dismissOnDraggingDownSheet {
  _transitionController.dismissOnDraggingDownSheet = dismissOnDraggingDownSheet;
  self.yyui_bottomSheetPresentationController.dismissOnDraggingDownSheet =
      dismissOnDraggingDownSheet;
}

- (BOOL)ignoreKeyboardHeight {
  return _transitionController.ignoreKeyboardHeight;
}

- (void)setIgnoreKeyboardHeight:(BOOL)ignoreKeyboardHeight {
  _transitionController.ignoreKeyboardHeight = ignoreKeyboardHeight;
  self.yyui_bottomSheetPresentationController.ignoreKeyboardHeight = ignoreKeyboardHeight;
}

- (void)bottomSheetWillChangeState:(YYUIBottomSheetPresentationController *)bottomSheet
                        sheetState:(YYUIBottomSheetState)sheetState {
  _state = sheetState;
  [self updateShapeGenerator];
  if ([self.delegate respondsToSelector:@selector(bottomSheetControllerStateChanged:state:)]) {
    [self.delegate bottomSheetControllerStateChanged:self state:sheetState];
  }
}

- (void)bottomSheetDidChangeYOffset:(nonnull YYUIBottomSheetPresentationController *)bottomSheet
                            yOffset:(CGFloat)yOffset {
  if ([self.delegate respondsToSelector:@selector(bottomSheetControllerDidChangeYOffset:
                                                                                yOffset:)]) {
    [self.delegate bottomSheetControllerDidChangeYOffset:self yOffset:yOffset];
  }
}

- (id<YYUIShapeGenerating>)shapeGeneratorForState:(YYUIBottomSheetState)state {
  id<YYUIShapeGenerating> shapeGenerator = _shapeGenerators[@(state)];
  if (state != YYUIBottomSheetStateClosed && shapeGenerator == nil) {
    shapeGenerator = _shapeGenerators[@(YYUIBottomSheetStateClosed)];
  }
  if (shapeGenerator != nil) {
    return shapeGenerator;
  }
  return nil;
}

- (void)setShapeGenerator:(id<YYUIShapeGenerating>)shapeGenerator forState:(YYUIBottomSheetState)state {
  _shapeGenerators[@(state)] = shapeGenerator;

  [self updateShapeGenerator];
}

- (void)updateShapeGenerator {
  id<YYUIShapeGenerating> shapeGenerator = [self shapeGeneratorForState:_state];
  if (self.view.shapeGenerator != shapeGenerator) {
    self.view.shapeGenerator = shapeGenerator;
    if (shapeGenerator != nil) {
      self.contentViewController.view.layer.mask =
          ((YYUIShapedShadowLayer *)self.view.layer).shapeLayer;
    } else {
      self.contentViewController.view.layer.mask = nil;
    }
  }
}

- (void)setElevation:(CGFloat)elevation {
  if (CGFloatEqual(elevation, _elevation)) {
    return;
  }

  _elevation = elevation;
  self.view.elevation = elevation;
  [self.view yyui_elevationDidChange];
}

- (CGFloat)yyui_currentElevation {
  return self.elevation;
}

- (CAShapeLayer *)createBottomEdgeElevationMask {
  CGFloat boundsWidth = CGRectGetWidth(self.view.bounds);
  CGFloat boundsHeight = CGRectGetHeight(self.view.bounds);
  CGRect visibleRectOutsideBounds =
      CGRectMake(0 - kElevationSpreadMaskAffordance, 0 - kElevationSpreadMaskAffordance,
                 boundsWidth + (2.0f * kElevationSpreadMaskAffordance),
                 boundsHeight + kElevationSpreadMaskAffordance);
  CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
  UIBezierPath *visibleAreaPath = [UIBezierPath bezierPathWithRect:visibleRectOutsideBounds];
  maskLayer.path = visibleAreaPath.CGPath;
  return maskLayer;
}

/* Disable setter. Always use internal transition controller */
- (void)setTransitioningDelegate:
    (__unused id<UIViewControllerTransitioningDelegate>)transitioningDelegate {
  NSAssert(NO, @"YYUIBottomSheetController.transitioningDelegate cannot be changed.");
  return;
}

/* Disable setter. Always use custom presentation style */
- (void)setModalPresentationStyle:(__unused UIModalPresentationStyle)modalPresentationStyle {
  NSAssert(NO, @"YYUIBottomSheetController.modalPresentationStyle cannot be changed.");
  return;
}

- (void)setScrimColor:(UIColor *)scrimColor {
  _transitionController.scrimColor = scrimColor;
}

- (UIColor *)scrimColor {
  return _transitionController.scrimColor;
}

- (void)setAdjustHeightForSafeAreaInsets:(BOOL)adjustHeightForSafeAreaInsets {
  _transitionController.adjustHeightForSafeAreaInsets = adjustHeightForSafeAreaInsets;
}

- (BOOL)adjustHeightForSafeAreaInsets {
  return _transitionController.adjustHeightForSafeAreaInsets;
}

- (void)setIsScrimAccessibilityElement:(BOOL)isScrimAccessibilityElement {
  _transitionController.isScrimAccessibilityElement = isScrimAccessibilityElement;
}

- (BOOL)isScrimAccessibilityElement {
  return _transitionController.isScrimAccessibilityElement;
}

- (void)setScrimAccessibilityLabel:(NSString *)scrimAccessibilityLabel {
  _transitionController.scrimAccessibilityLabel = scrimAccessibilityLabel;
}

- (NSString *)scrimAccessibilityLabel {
  return _transitionController.scrimAccessibilityLabel;
}

- (void)setScrimAccessibilityHint:(NSString *)scrimAccessibilityHint {
  _transitionController.scrimAccessibilityHint = scrimAccessibilityHint;
}

- (NSString *)scrimAccessibilityHint {
  return _transitionController.scrimAccessibilityHint;
}

- (void)setScrimAccessibilityTraits:(UIAccessibilityTraits)scrimAccessibilityTraits {
  _transitionController.scrimAccessibilityTraits = scrimAccessibilityTraits;
}

- (UIAccessibilityTraits)scrimAccessibilityTraits {
  return _transitionController.scrimAccessibilityTraits;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
  [super traitCollectionDidChange:previousTraitCollection];

  if (self.traitCollectionDidChangeBlock) {
    self.traitCollectionDidChangeBlock(self, previousTraitCollection);
  }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)bottomSheetPresentationControllerDidDismissBottomSheet:
    (nonnull __unused YYUIBottomSheetPresentationController *)bottomSheet {
#pragma clang diagnostic pop
  if ([self.delegate respondsToSelector:@selector(bottomSheetControllerDidDismissBottomSheet:)]) {
    [self.delegate bottomSheetControllerDidDismissBottomSheet:self];
  }
}

@end

