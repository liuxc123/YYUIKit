//
//  YYUICornerTreatment+CornerTypeInitalizer.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import "YYUICornerTreatment+CornerTypeInitalizer.h"

#import "YYUICurvedCornerTreatment.h"

#import "YYUICutCornerTreatment.h"

#import "YYUIRoundedCornerTreatment.h"

@implementation YYUICornerTreatment (CornerTypeInitalizer)

+ (YYUIRoundedCornerTreatment *)cornerWithRadius:(CGFloat)value {
    return [[YYUIRoundedCornerTreatment alloc] initWithRadius:value];
}

+ (YYUIRoundedCornerTreatment *)cornerWithRadius:(CGFloat)value
                                       valueType:(YYUICornerTreatmentValueType)valueType {
    YYUIRoundedCornerTreatment *roundedCornerTreatment =
    [YYUIRoundedCornerTreatment cornerWithRadius:value];
    roundedCornerTreatment.valueType = valueType;
    return roundedCornerTreatment;
}

+ (YYUICutCornerTreatment *)cornerWithCut:(CGFloat)value {
    return [[YYUICutCornerTreatment alloc] initWithCut:value];
}

+ (YYUICutCornerTreatment *)cornerWithCut:(CGFloat)value
                                valueType:(YYUICornerTreatmentValueType)valueType {
    YYUICutCornerTreatment *cutCornerTreatment = [YYUICutCornerTreatment cornerWithCut:value];
    cutCornerTreatment.valueType = valueType;
    return cutCornerTreatment;
}

+ (YYUICurvedCornerTreatment *)cornerWithCurve:(CGSize)value {
    return [[YYUICurvedCornerTreatment alloc] initWithSize:value];
}

+ (YYUICurvedCornerTreatment *)cornerWithCurve:(CGSize)value
                                     valueType:(YYUICornerTreatmentValueType)valueType {
    YYUICurvedCornerTreatment *curvedCornerTreatment =
    [YYUICurvedCornerTreatment cornerWithCurve:value];
    curvedCornerTreatment.valueType = valueType;
    return curvedCornerTreatment;
}

@end

