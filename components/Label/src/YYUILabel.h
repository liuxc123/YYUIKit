//
//  YYUILabel.h
//  CatalogByConvention
//
//  Created by liuxc on 2021/11/22.
//

#import <UIKit/UIKit.h>

@interface YYUILabel : UILabel

/** The content edge insets */
@property(nonatomic, assign) UIEdgeInsets contentEdgeInsets;

/// 是否需要长按复制的功能，默认为 NO。
/// 长按时的背景色通过`highlightedBackgroundColor`设置。
@property(nonatomic,assign) IBInspectable BOOL canPerformCopyAction;

/// 当 canPerformCopyAction 开启时，长按出来的菜单上的复制按钮的文本，默认为 nil，nil 时 menuItem 上的文字为“复制”
@property(nonatomic, copy) IBInspectable NSString *menuItemTitleForCopyAction;

/// 点击了“复制”后的回调
@property(nonatomic, copy) void (^didCopyBlock)(YYUILabel *label, NSString *stringCopied);

@end


