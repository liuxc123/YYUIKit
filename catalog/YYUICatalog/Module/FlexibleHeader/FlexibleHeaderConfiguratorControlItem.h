//
//  FlexibleHeaderConfiguratorControlItem.h
//  YYUICatalog
//
//  Created by liuxc on 2021/11/17.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    FlexibleHeaderConfiguratorControlTypeButton,
    FlexibleHeaderConfiguratorControlTypeSwitch,
    FlexibleHeaderConfiguratorControlTypeSlider
} FlexibleHeaderConfiguratorControlType;

@interface FlexibleHeaderConfiguratorControlItem : NSObject

+ (instancetype)itemWithTitle:(NSString *)title
                  controlType:(FlexibleHeaderConfiguratorControlType)controlType
                        field:(NSUInteger)field;

@property(nonatomic, strong, readonly) NSString *title;
@property(nonatomic, readonly) FlexibleHeaderConfiguratorControlType controlType;
@property(nonatomic, readonly) NSUInteger field;

@end
