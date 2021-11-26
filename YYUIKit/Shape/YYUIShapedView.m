//
//  YYUIShapedView.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import "YYUIShapedView.h"

#import "YYUIShapedShadowLayer.h"

@interface YYUIShapedView ()
@property(nonatomic, readonly, strong) YYUIShapedShadowLayer *layer;
@property(nonatomic, readonly) CGSize pathSize;
@end

@implementation YYUIShapedView

@dynamic layer;

+ (Class)layerClass {
  return [YYUIShapedShadowLayer class];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
// https://stackoverflow.com/questions/24458608/convenience-initializer-missing-a-self-call-to-another-initializer
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  return [super initWithCoder:aDecoder];
}
#pragma clang diagnostic pop

- (nonnull instancetype)initWithFrame:(CGRect)frame {
  return [self initWithFrame:frame shapeGenerator:nil];
}

- (nonnull instancetype)initWithFrame:(CGRect)frame
                       shapeGenerator:(nullable id<YYUIShapeGenerating>)shapeGenerator {
  if (self = [super initWithFrame:frame]) {
    self.layer.shapeGenerator = shapeGenerator;
  }
  return self;
}

- (void)setElevation:(CGFloat)elevation {
  self.layer.elevation = elevation;
}

- (CGFloat)elevation {
  return self.layer.elevation;
}

- (void)setShapeGenerator:(id<YYUIShapeGenerating>)shapeGenerator {
  self.layer.shapeGenerator = shapeGenerator;
}

- (id<YYUIShapeGenerating>)shapeGenerator {
  return self.layer.shapeGenerator;
}

- (UIColor *)shapedBorderColor {
  return self.layer.shapedBorderColor;
}

- (void)setShapedBorderColor:(UIColor *)shapedBorderColor {
  self.layer.shapedBorderColor = shapedBorderColor;
}

- (CGFloat)shapedBorderWidth {
  return self.layer.shapedBorderWidth;
}

- (void)setShapedBorderWidth:(CGFloat)shapedBorderWidth {
  self.layer.shapedBorderWidth = shapedBorderWidth;
}

// YYUIShapedView captures backgroundColor assigments so that they can be set to the
// YYUIShapedShadowLayer fillColor. If we don't do this the background of the layer will obscure any
// shapes drawn by the shape layer.
- (void)setBackgroundColor:(UIColor *)backgroundColor {
  // We intentionally capture this and don't send it to super so that the UIView backgroundColor is
  // fixed to [UIColor clearColor].
  self.layer.shapedBackgroundColor = backgroundColor;
}

- (UIColor *)backgroundColor {
  return self.layer.shapedBackgroundColor;
}

@end

