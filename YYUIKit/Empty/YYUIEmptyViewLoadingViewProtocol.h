//
//  YYUIEmptyViewLoadingViewProtocol.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/23.
//

#import <UIKit/UIKit.h>

@protocol YYUIEmptyViewLoadingViewProtocol <NSObject>

@optional
- (void)startAnimating; // 当调用 setLoadingViewHidden:NO 时，系统将自动调用此处的 startAnimating

@end

