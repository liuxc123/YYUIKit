//
//  YYUIAlertViewButton.m
//  YYUIKit
//
//  Created by liuxc on 2021/12/2.
//

#import "YYUIAlertViewButton.h"
#import "YYUIAlertViewHelper.h"

@implementation YYUIAlertViewButton

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.titleLabel.backgroundColor = UIColor.clearColor;
        self.imageView.backgroundColor = UIColor.clearColor;

        self.contentEdgeInsets = UIEdgeInsetsMake(YYUIAlertViewPaddingHeight,
                                                  YYUIAlertViewPaddingWidth,
                                                  YYUIAlertViewPaddingHeight,
                                                  YYUIAlertViewPaddingWidth);

        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

        self.adjustsImageWhenHighlighted = NO;
        self.adjustsImageWhenDisabled = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (!self.imageView.image || !self.titleLabel.text.length) {
        return;
    }

    CGRect imageViewFrame = self.imageView.frame;
    CGRect titleLabelFrame = self.titleLabel.frame;

    if (self.iconPosition == YYUIAlertViewButtonIconPositionLeft) {
        if (self.titleLabel.textAlignment == NSTextAlignmentLeft) {
            imageViewFrame.origin.x = self.contentEdgeInsets.left;
            titleLabelFrame.origin.x = CGRectGetMaxX(imageViewFrame) + YYUIAlertViewButtonImageOffsetFromTitle;
        }
        else if (self.titleLabel.textAlignment == NSTextAlignmentRight) {
            imageViewFrame.origin.x = self.contentEdgeInsets.left;
            titleLabelFrame.origin.x = CGRectGetWidth(self.bounds) - self.contentEdgeInsets.right;
        }
        else {
            imageViewFrame.origin.x -= YYUIAlertViewButtonImageOffsetFromTitle / 2.0;
            titleLabelFrame.origin.x += YYUIAlertViewButtonImageOffsetFromTitle / 2.0;
        }
    }
    else {
        if (self.titleLabel.textAlignment == NSTextAlignmentLeft) {
            titleLabelFrame.origin.x = self.contentEdgeInsets.left;
            imageViewFrame.origin.x = CGRectGetWidth(self.bounds) - self.contentEdgeInsets.right - CGRectGetWidth(imageViewFrame);
        }
        else if (self.titleLabel.textAlignment == NSTextAlignmentRight) {
            imageViewFrame.origin.x = CGRectGetWidth(self.bounds) - self.contentEdgeInsets.right - CGRectGetWidth(imageViewFrame);
            titleLabelFrame.origin.x = CGRectGetMinX(imageViewFrame) - YYUIAlertViewButtonImageOffsetFromTitle - CGRectGetWidth(titleLabelFrame);
        }
        else {
            imageViewFrame.origin.x += CGRectGetWidth(titleLabelFrame) + (YYUIAlertViewButtonImageOffsetFromTitle / 2.0);
            titleLabelFrame.origin.x -= CGRectGetWidth(imageViewFrame) + (YYUIAlertViewButtonImageOffsetFromTitle / 2.0);
        }
    }

    if (YYUIAlertViewHelper.isNotRetina) {
        imageViewFrame = CGRectIntegral(imageViewFrame);
    }

    self.imageView.frame = imageViewFrame;

    if (YYUIAlertViewHelper.isNotRetina) {
        titleLabelFrame = CGRectIntegral(imageViewFrame);
    }

    self.titleLabel.frame = titleLabelFrame;
}

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state {
    [self setBackgroundImage:[YYUIAlertViewHelper image1x1WithColor:color] forState:state];
}


@end
