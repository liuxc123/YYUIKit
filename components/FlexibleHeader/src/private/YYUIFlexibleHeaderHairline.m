//
//  YYUIFlexibleHeaderHairline.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/17.
//

#import "YYUIFlexibleHeaderHairline.h"

@protocol YYUIFlexibleHeaderHairlineViewDelegate;

__attribute__((objc_subclassing_restricted)) @interface YYUIFlexibleHeaderHairlineView : UIView
@property(nonatomic, weak) id<YYUIFlexibleHeaderHairlineViewDelegate> delegate;
@end

@protocol YYUIFlexibleHeaderHairlineViewDelegate <NSObject>
@required

// Informs the receiver that the hairline view moved to a new window.
- (void)hairlineViewDidMoveToWindow:(YYUIFlexibleHeaderHairlineView *)hairlineView;

@end

#pragma mark -

@interface YYUIFlexibleHeaderHairline () <YYUIFlexibleHeaderHairlineViewDelegate>

// The view that represents the bottom hairline when showsHairline is enabled.
@property(nonatomic, strong) YYUIFlexibleHeaderHairlineView *hairlineView;

@end

#pragma mark -

@implementation YYUIFlexibleHeaderHairline

- (nonnull instancetype)initWithContainerView:(nonnull UIView *)containerView {
  self = [super init];
  if (self) {
    _containerView = containerView;
    _color = [UIColor blackColor];
    _hidden = YES;
  }
  return self;
}

#pragma mark - Public

- (void)setColor:(UIColor *)color {
  _color = color;

  _hairlineView.backgroundColor = _color;
}

- (void)setHidden:(BOOL)hidden {
  if (_hidden == hidden) {
    return;
  }
  _hidden = hidden;

  if (!_hidden && !_hairlineView) {
    _hairlineView = [[YYUIFlexibleHeaderHairlineView alloc] init];
    _hairlineView.delegate = self;
    _hairlineView.backgroundColor = self.color;
    _hairlineView.autoresizingMask =
        (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);

    [self.containerView addSubview:_hairlineView];
    _hairlineView.frame = [self frame];
  }

  _hairlineView.hidden = _hidden;
}

#pragma mark - YYUIFlexibleHeaderHairlineViewDelegate

- (void)hairlineViewDidMoveToWindow:(YYUIFlexibleHeaderHairlineView *)hairlineView {
  // When we move to a new window it's possible that the window's screen scale has changed, so we
  // re-calculate the frame of the hairline with the new screen scale in mind.
  _hairlineView.frame = [self frame];
}

#pragma mark - Private

- (CGRect)frame {
  CGRect bounds = self.containerView.bounds;
  CGFloat containerScreenScale = self.containerView.window.screen.scale;
  BOOL hasValidScreenScale = containerScreenScale > 0;
  CGFloat hairlineHeight = hasValidScreenScale ? ((CGFloat)1.0 / containerScreenScale) : 1;
  return CGRectMake(0, CGRectGetHeight(bounds) - hairlineHeight, CGRectGetWidth(bounds),
                    hairlineHeight);
}

@end

#pragma mark -

@implementation YYUIFlexibleHeaderHairlineView

- (void)didMoveToWindow {
  [super didMoveToWindow];

  [self.delegate hairlineViewDidMoveToWindow:self];
}

@end
