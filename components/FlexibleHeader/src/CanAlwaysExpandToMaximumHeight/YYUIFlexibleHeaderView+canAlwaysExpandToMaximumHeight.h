//
//  YYUIFlexibleHeader+CanAlwaysExpandToMaximumHeight.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/17.
//

#import "YYFlexibleHeader.h"

@interface YYUIFlexibleHeaderView ()

/**
 Whether the flexible header is able to expand to its maximum height even when the target scroll
 view content offset is not at the top of the content.

 When enabled, the flexible header will be able to expand to its maximum height even when scrolled
 within the content of the tracking scroll view.

 When disabled, the flexible header will only expand to its maximum height once the scroll view
 reaches the top of its content.

 @note This is an experimental feature. Please do not enable it without first consulting the YYUI
 team about your intended use case.

 Default is NO.
 */
@property(nonatomic) BOOL canAlwaysExpandToMaximumHeight;

@end
