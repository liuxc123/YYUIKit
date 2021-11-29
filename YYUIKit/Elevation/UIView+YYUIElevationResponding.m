//
//  UIView+YYElevationResponding.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/17.
//

#import "UIView+YYUIElevationResponding.h"

#import "YYUIElevatable.h"
#import "YYUIElevationOverriding.h"

@implementation UIView (YYUIElevationResponding)

- (void)yyui_elevationDidChange {
  CGFloat baseElevation = self.yyui_baseElevation;
  [self yyui_elevationDidChangeWithBaseElevation:baseElevation];
}

- (void)yyui_elevationDidChangeWithBaseElevation:(CGFloat)baseElevation {
  CGFloat elevation = baseElevation;
  id<YYUIElevatable> elevatableSelf = [self objectConformingToElevationInResponderChain];
  if (elevatableSelf.yyui_elevationDidChangeBlock) {
    elevation += elevatableSelf.yyui_currentElevation;
    elevatableSelf.yyui_elevationDidChangeBlock(elevatableSelf, elevation);
  }

  for (UIView *subview in self.subviews) {
    [subview yyui_elevationDidChangeWithBaseElevation:elevation];
  }
}

- (CGFloat)yyui_baseElevation {
  CGFloat totalElevation = 0;
  UIView *current = self;

  while (current != nil) {
    id<YYUIElevatable> elevatableCurrent = [current objectConformingToElevationInResponderChain];
    if (current != self) {
      totalElevation += elevatableCurrent.yyui_currentElevation;
    }
    id<YYUIElevationOverriding> elevatableCurrentOverride =
        [current objectConformingToOverrideInResponderChain];
    if (elevatableCurrentOverride != nil &&
        elevatableCurrentOverride.yyui_overrideBaseElevation >= 0) {
      totalElevation += elevatableCurrentOverride.yyui_overrideBaseElevation;
      break;
    }
    current = current.superview;
  }
  return totalElevation;
}

- (CGFloat)yyui_absoluteElevation {
  CGFloat elevation = self.yyui_baseElevation;
  id<YYUIElevatable> elevatableSelf = [self objectConformingToElevationInResponderChain];
  elevation += elevatableSelf.yyui_currentElevation;
  return elevation;
}

/**
 Checks whether a @c UIView or it's managing @c UIViewController conform to @c
 YYUIOverrideElevation.

 @returns the conforming @c UIView then @c UIViewController, otherwise @c nil.
 */
- (id<YYUIElevationOverriding>)objectConformingToOverrideInResponderChain {
  if ([self conformsToProtocol:@protocol(YYUIElevationOverriding)]) {
    return (id<YYUIElevationOverriding>)self;
  }

  UIResponder *nextResponder = self.nextResponder;
  if ([nextResponder isKindOfClass:[UIViewController class]] &&
      [nextResponder conformsToProtocol:@protocol(YYUIElevationOverriding)]) {
    return (id<YYUIElevationOverriding>)nextResponder;
  }

  return nil;
}

/**
 Checks whether a @c UIView or it's managing @c UIViewController conform to @c
 YYUIElevation.

 @returns the conforming @c UIView then @c UIViewController, otherwise @c nil.
 */
- (id<YYUIElevatable>)objectConformingToElevationInResponderChain {
  if ([self conformsToProtocol:@protocol(YYUIElevatable)]) {
    return (id<YYUIElevatable>)self;
  }

  UIResponder *nextResponder = self.nextResponder;
  if ([nextResponder isKindOfClass:[UIViewController class]] &&
      [nextResponder conformsToProtocol:@protocol(YYUIElevatable)]) {
    return (id<YYUIElevatable>)nextResponder;
  }

  return nil;
}

@end

