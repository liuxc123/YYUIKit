//
//  YYUISheetBehavior.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/22.
//

#import "YYUISheetBehavior.h"

/**
 These values were arrived at empirically (through trial and error) to either emphasize or diminish
 the bounce effect that UIKit dynamics provides.
 */
static const CGFloat kSimulateScrollViewBounceFrequency = 3.5f;
static const CGFloat kSimulateScrollViewBounceDamping = 0.4f;
static const CGFloat kDisableScrollViewBounceFrequency = 5.5f;
static const CGFloat kDisableScrollViewBounceDamping = 1.0f;

@interface YYUISheetBehavior ()
@property(nonatomic) UIAttachmentBehavior *attachmentBehavior;
@property(nonatomic) UIDynamicItemBehavior *itemBehavior;
@property(nonatomic) id<UIDynamicItem> item;
@end

@implementation YYUISheetBehavior

- (instancetype)initWithItem:(id<UIDynamicItem>)item
    simulateScrollViewBounce:(BOOL)simulateScrollViewBounce {
  self = [super init];
  if (self) {
    _item = item;
    _attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.item
                                                    attachedToAnchor:CGPointZero];
    if (simulateScrollViewBounce) {
      _attachmentBehavior.frequency = kSimulateScrollViewBounceFrequency;
      _attachmentBehavior.damping = kSimulateScrollViewBounceDamping;
    } else {
      _attachmentBehavior.frequency = kDisableScrollViewBounceFrequency;
      _attachmentBehavior.damping = kDisableScrollViewBounceDamping;
    }
    _attachmentBehavior.length = 0;

    // Anchor movement along the y-axis.
    __weak YYUISheetBehavior *weakSelf = self;
    _attachmentBehavior.action = ^{
      YYUISheetBehavior *strongSelf = weakSelf;
      CGPoint center = item.center;
      center.x = strongSelf->_targetPoint.x;
      item.center = center;
    };
    [self addChildBehavior:_attachmentBehavior];

    _itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[ self.item ]];
    _itemBehavior.density = 100;
    _itemBehavior.resistance = 10;
    [self addChildBehavior:_itemBehavior];
  }
  return self;
}

- (void)setTargetPoint:(CGPoint)targetPoint {
  _targetPoint = targetPoint;
  self.attachmentBehavior.anchorPoint = targetPoint;
}

- (void)setVelocity:(CGPoint)velocity {
  _velocity = velocity;
  CGPoint currentVelocity = [self.itemBehavior linearVelocityForItem:self.item];
  CGPoint velocityDelta =
      CGPointMake(velocity.x - currentVelocity.x, velocity.y - currentVelocity.y);
  [self.itemBehavior addLinearVelocity:velocityDelta forItem:self.item];
}

@end
