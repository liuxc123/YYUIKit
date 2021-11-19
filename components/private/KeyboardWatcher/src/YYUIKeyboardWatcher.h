//
//  YYUIKeyboardWatcher.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// These notifications mirror their UIKeyboard* counterparts. They are posted after the keyboard
// watcher has updated its own internal state, so listeners are safe to query the keyboard watcher
// for its values.
OBJC_EXTERN NSString *const YYUIKeyboardWatcherKeyboardWillShowNotification;
OBJC_EXTERN NSString *const YYUIKeyboardWatcherKeyboardWillHideNotification;
OBJC_EXTERN NSString *const YYUIKeyboardWatcherKeyboardWillChangeFrameNotification;

/**
 An object which will watch the state of the keyboard.

 The keyboard watcher calculates an offset representing the distance from the top of the keyboard to
 the bottom of the screen.
 */
@interface YYUIKeyboardWatcher : NSObject

/**
 Shared singleton instance of YYUIKeyboardWatcher.
 */
+ (instancetype)sharedKeyboardWatcher;

/** Extract the animation duration from the keyboard notification */
+ (NSTimeInterval)animationDurationFromKeyboardNotification:(NSNotification *)notification;

/** Extract the animation curve option from the keyboard notification */
+ (UIViewAnimationOptions)animationCurveOptionFromKeyboardNotification:
    (NSNotification *)notification;

/**
 The height of the visible keyboard view.

 Zero if the keyboard is not currently showing or is not docked.
 */
@property(nonatomic, readonly) CGFloat visibleKeyboardHeight;

@end



