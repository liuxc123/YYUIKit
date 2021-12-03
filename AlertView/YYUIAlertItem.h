//
//  YYUIAlertItem.h
//  YYUIKit
//
//  Created by liuxc on 2021/12/3.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LEEItemType) {
    /** 标题 */
    LEEItemTypeTitle,
    /** 内容 */
    LEEItemTypeContent,
    /** 输入框 */
    LEEItemTypeTextField,
    /** 自定义视图 */
    LEEItemTypeCustomView,
};

@interface YYUIAlertItem : NSObject

@end
