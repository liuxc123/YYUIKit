//
//  YYUICurvedRectShapeGenerator.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#import "YYUICurvedRectShapeGenerator.h"

#import "YYUICurvedCornerTreatment.h"
#import "YYShapes.h"

@implementation YYUICurvedRectShapeGenerator {
  YYUIRectangleShapeGenerator *_rectGenerator;
  YYUICurvedCornerTreatment *_widthHeightCorner;
  YYUICurvedCornerTreatment *_heightWidthCorner;
}

- (instancetype)init {
  return [self initWithCornerSize:CGSizeMake(0, 0)];
}

- (instancetype)initWithCornerSize:(CGSize)cornerSize {
  if (self = [super init]) {
    [self commonInit];

    self.cornerSize = cornerSize;
  }
  return self;
}

- (void)commonInit {
  _rectGenerator = [[YYUIRectangleShapeGenerator alloc] init];

  _widthHeightCorner = [[YYUICurvedCornerTreatment alloc] init];
  _heightWidthCorner = [[YYUICurvedCornerTreatment alloc] init];

  _rectGenerator.topLeftCorner = _widthHeightCorner;
  _rectGenerator.topRightCorner = _heightWidthCorner;
  _rectGenerator.bottomRightCorner = _widthHeightCorner;
  _rectGenerator.bottomLeftCorner = _heightWidthCorner;
}

- (void)setCornerSize:(CGSize)cornerSize {
  _cornerSize = cornerSize;

  _widthHeightCorner.size = _cornerSize;
  _heightWidthCorner.size = CGSizeMake(cornerSize.height, cornerSize.width);
}

- (id)copyWithZone:(nullable NSZone *)__unused zone {
  YYUICurvedRectShapeGenerator *copy = [[[self class] alloc] init];
  copy.cornerSize = self.cornerSize;
  return copy;
}

- (CGPathRef)pathForSize:(CGSize)size {
  return [_rectGenerator pathForSize:size];
}

@end
