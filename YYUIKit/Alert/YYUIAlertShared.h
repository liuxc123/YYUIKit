//
//  YYUIAlertShared.h
//  Pods
//
//  Created by liuxc on 2021/12/3.
//

typedef NS_ENUM(NSInteger, LEEScreenOrientationType) {
    /** 屏幕方向类型 横屏 */
    LEEScreenOrientationTypeHorizontal,
    /** 屏幕方向类型 竖屏 */
    LEEScreenOrientationTypeVertical
};

typedef NS_ENUM(NSInteger, LEEAlertType) {
    
    LEEAlertTypeAlert,
    
    LEEAlertTypeActionSheet
};

typedef NS_ENUM(NSInteger, YYUIAlertActionType) {
    /** 默认 */
    YYUIAlertActionTypeDefault,
    /** 取消 */
    YYUIAlertActionTypeCancel,
    /** 销毁 */
    YYUIAlertActionTypeDestructive
};

typedef NS_OPTIONS(NSInteger, YYUIAlertActionBorderPosition) {
    /** Action边框位置 上 */
    YYUIAlertActionBorderPositionTop      = 1 << 0,
    /** Action边框位置 下 */
    YYUIAlertActionBorderPositionBottom   = 1 << 1,
    /** Action边框位置 左 */
    YYUIAlertActionBorderPositionLeft     = 1 << 2,
    /** Action边框位置 右 */
    YYUIAlertActionBorderPositionRight    = 1 << 3
};

typedef NS_ENUM(NSInteger, YYUIAlertItemType) {
    /** 标题 */
    YYUIAlertItemTypeTitle,
    /** 内容 */
    YYUIAlertItemTypeContent,
    /** 输入框 */
    YYUIAlertItemTypeTextField,
    /** 自定义视图 */
    YYUIAlertItemTypeCustomView,
};


typedef NS_ENUM(NSInteger, YYUICustomViewPositionType) {
    /** 居中 */
    YYUICustomViewPositionTypeCenter,
    /** 靠左 */
    YYUICustomViewPositionTypeLeft,
    /** 靠右 */
    YYUICustomViewPositionTypeRight
};

typedef struct {
    CGFloat topLeft;
    CGFloat topRight;
    CGFloat bottomLeft;
    CGFloat bottomRight;
} CornerRadii;
