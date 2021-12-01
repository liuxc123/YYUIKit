//
//  YYUIDraggableView.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/22.
//

#import "YYUIDraggableView.h"

#import "YYUIDraggableViewDelegate.h"
#import "YYTextKeyboardManager.h"

static void CancelGestureRecognizer(UIGestureRecognizer *gesture) {
  if (gesture.enabled) {
    // Setting enabled to NO while a gesture recognizer is currently recognizing a gesture will
    // transition it to a cancelled state.
    gesture.enabled = NO;
    gesture.enabled = YES;
  }
}

@interface YYUIDraggableView () <UIGestureRecognizerDelegate>
@property(nonatomic) UIPanGestureRecognizer *dragRecognizer;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, assign) CGFloat mostRecentMinY;
@end

@implementation YYUIDraggableView

- (instancetype)initWithFrame:(CGRect)frame scrollView:(UIScrollView *)scrollView {
  self = [super initWithFrame:frame];
  if (self) {
    _scrollView = scrollView;
    _dragRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(didPan:)];
    _dragRecognizer.maximumNumberOfTouches = 1;
    _dragRecognizer.delegate = self;
    [self addGestureRecognizer:_dragRecognizer];

    self.clipsToBounds = YES;
  }
  return self;
}

#pragma mark - Gesture handling

- (void)didPan:(UIPanGestureRecognizer *)recognizer {
  if (recognizer.state == UIGestureRecognizerStateBegan) {
    self.mostRecentMinY = CGRectGetMinY(self.frame);
    [self.delegate draggableViewBeganDragging:self];
    return;
  }

  CGPoint velocity = [recognizer velocityInView:self.superview];
  velocity.x = 0;
  CGPoint translation = [recognizer translationInView:self.superview];
  CGFloat maxHeight = [self.delegate maximumHeightForDraggableView:self];
  CGFloat minimumStableMinY = CGRectGetHeight(self.superview.bounds) - maxHeight -
                              [YYTextKeyboardManager defaultManager].keyboardFrame.size.height;
  CGFloat newMinY = self.mostRecentMinY + translation.y;

  if (newMinY < minimumStableMinY) {
    if ((self.scrollView == nil) && !self.simulateScrollViewBounce) {
      velocity = CGPointZero;
      newMinY = minimumStableMinY;
    } else {
      // Ensure that dragging the sheet past the maximum height results in an exponential decay on
      // the translation. This gives the same effect as when you overscroll a scrollview.
      newMinY = minimumStableMinY + (translation.y - (translation.y / 1.2f));
    }
  }
  CGRect newFrame = CGRectMake(CGRectGetMinX(self.frame), newMinY, CGRectGetWidth(self.frame),
                               CGRectGetHeight(self.frame));

  if (recognizer.state == UIGestureRecognizerStateChanged) {
    self.frame = newFrame;
    [self.delegate draggableView:self didPanToOffset:CGRectGetMinY(self.frame)];
  } else if (recognizer.state == UIGestureRecognizerStateEnded) {
    [self.delegate draggableView:self draggingEndedWithVelocity:velocity];
  }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)recognizer {
  // When opening the control center while a YYUIBottomSheet is displayed recognizer happens to be
  // an object of _UISystemGestureGateGestureRecognizer which doesn't have velocityInView: and it
  // crashes the app.
  if (recognizer != self.dragRecognizer) {
    return NO;
  }

  CGPoint velocity = [recognizer velocityInView:self.superview];
  velocity.x = 0;

  if ([self.delegate draggableView:self shouldBeginDraggingWithVelocity:velocity]) {
    // If dragging the pane, don't allow the content to scroll at the same time.
    CancelGestureRecognizer(self.scrollView.panGestureRecognizer);
    return YES;
  } else {
    return NO;
  }
}

// Allow the drag recogniser to recognize alongside the embedded scrollview's pan gesture.
- (BOOL)gestureRecognizer:(__unused UIGestureRecognizer *)recognizer
    shouldRecognizeSimultaneouslyWithGestureRecognizer:
        (UIGestureRecognizer *)otherGestureRecognizer {
  if (otherGestureRecognizer == self.scrollView.panGestureRecognizer) {
    return YES;
  }
  return NO;
}

// Disable pan gesture on UIControl
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
  if ([touch.view isKindOfClass:[UIControl class]]) {
    return NO;
  }
  return YES;
}

@end

