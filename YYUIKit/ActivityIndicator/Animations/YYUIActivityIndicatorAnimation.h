//
//  YYUIActivityIndicatorAnimation.h
//  YYUIActivityIndicatorExample
//
//  Created by iDress on 8/10/16.
//  Copyright © 2016 iDress. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YYUIActivityIndicatorAnimationProtocol.h"

@interface YYUIActivityIndicatorAnimation : NSObject <YYUIActivityIndicatorAnimationProtocol>

- (CABasicAnimation *)createBasicAnimationWithKeyPath:(NSString *)keyPath;
- (CAKeyframeAnimation *)createKeyframeAnimationWithKeyPath:(NSString *)keyPath;
- (CAAnimationGroup *)createAnimationGroup;

@end
