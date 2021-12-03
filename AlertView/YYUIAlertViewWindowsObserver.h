//
//  YYUIAlertViewWindowsObserver.h
//  YYUIKit
//
//  Created by liuxc on 2021/12/2.
//

#import <UIKit/UIKit.h>

@interface YYUIAlertViewWindowsObserver : NSObject

+ (instancetype)sharedInstance;

- (void)startObserving;

@end
