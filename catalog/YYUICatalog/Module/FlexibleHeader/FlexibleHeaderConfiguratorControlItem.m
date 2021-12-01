//
//  FlexibleHeaderConfiguratorControlItem.m
//  YYUICatalog
//
//  Created by liuxc on 2021/11/17.
//

#import "FlexibleHeaderConfiguratorControlItem.h"

@implementation FlexibleHeaderConfiguratorControlItem

+ (instancetype)itemWithTitle:(NSString *)title
                  controlType:(FlexibleHeaderConfiguratorControlType)controlType
                        field:(NSUInteger)field {
    FlexibleHeaderConfiguratorControlItem *item = [[self alloc] init];
    item->_title = [title copy];
    item->_controlType = controlType;
    item->_field = field;
    return item;
}

@end
