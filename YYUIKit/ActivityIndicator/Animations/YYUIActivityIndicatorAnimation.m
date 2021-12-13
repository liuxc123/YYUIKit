//
//  YYUIActivityIndicatorAnimation.m
//  YYUIActivityIndicatorExample
//
//  Created by iDress on 8/10/16.
//  Copyright © 2016 iDress. All rights reserved.
//

#import "YYUIActivityIndicatorAnimation.h"

@implementation YYUIActivityIndicatorAnimation

- (CABasicAnimation *)createBasicAnimationWithKeyPath:(NSString *)keyPath {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.removedOnCompletion = NO;
    return animation;
}

- (CAKeyframeAnimation *)createKeyframeAnimationWithKeyPath:(NSString *)keyPath {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    animation.removedOnCompletion = NO;
    return animation;
}

- (CAAnimationGroup *)createAnimationGroup {
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.removedOnCompletion = NO;
    return animationGroup;
}

- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    
}

@end
