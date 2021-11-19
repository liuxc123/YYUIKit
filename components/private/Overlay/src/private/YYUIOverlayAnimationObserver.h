//
//  YYUIOverlayAnimationObserver.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import <Foundation/Foundation.h>

@protocol YYUIOverlayAnimationObserverDelegate;

/**
 Utility class which will call its delegate at the end of the current runloop cycle.

 Called before CoreAnimation has had a chance to commit any pending implicit @c CATransactions.
 */
@interface YYUIOverlayAnimationObserver : NSObject

/**
 Called to tell the observer that it should call the @c delegate at the end of the next runloop.

 Without calling this method, the observer will not call the delegate.
 */
- (void)messageDelegateOnNextRunloop;

/**
 The delegate to notify when the end of the runloop has occurred.
 */
@property(nonatomic, weak) id<YYUIOverlayAnimationObserverDelegate> delegate;

@end

/**
 Delegate protocol for @c YYUIOverlayAnimationObserver.
 */
@protocol YYUIOverlayAnimationObserverDelegate <NSObject>

/**
 Called at the end of the current runloop, before CoreAnimation commits any implicit transactions.
 */
- (void)animationObserverDidEndRunloop:(YYUIOverlayAnimationObserver *)observer;

@end

