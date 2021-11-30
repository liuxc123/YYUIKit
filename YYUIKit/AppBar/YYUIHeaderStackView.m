//
//  YYUIHeaderStackView.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/17.
//

#import <CoreGraphics/CoreGraphics.h>

#import "YYUIHeaderStackView.h"

@implementation YYUIHeaderStackView

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat height = [_topBar sizeThatFits:size].height;
    if (_bottomBar) {
        height += [_bottomBar sizeThatFits:size].height;
    }
    size.height = height;
    return size;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize boundsSize = self.bounds.size;
    
    CGSize bottomBarSize = [_bottomBar sizeThatFits:boundsSize];
    CGFloat remainingHeight = boundsSize.height - bottomBarSize.height;
    CGSize topBarSize = [_topBar sizeThatFits:CGSizeMake(boundsSize.width, remainingHeight)];
    remainingHeight -= topBarSize.height;
    
    CGRect topBarFrame = CGRectMake(0, 0, topBarSize.width, topBarSize.height);
    CGRect bottomBarFrame = CGRectMake(0, 0, bottomBarSize.width, bottomBarSize.height);
    
    if (remainingHeight > 0) {
        // Expand the top bar to fill the remaining height.
        topBarFrame.size.height += remainingHeight;
        
    } else if (remainingHeight < 0) {
        // Negative value causes the top bar to slide up and away.
        topBarFrame.origin.y += remainingHeight;
    }
    bottomBarFrame.origin.y = CGRectGetMaxY(topBarFrame);
    
    _topBar.frame = topBarFrame;
    _bottomBar.frame = bottomBarFrame;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    if (self.traitCollectionDidChangeBlock) {
        self.traitCollectionDidChangeBlock(self, previousTraitCollection);
    }
}

#pragma mark - Public

- (void)setTopBar:(UIView *)topBar {
    if (_topBar == topBar) {
        return;
    }
    
    [_topBar removeFromSuperview];
    
    _topBar = topBar;
    
    [self addSubview:_topBar];
    [self setNeedsLayout];
}

- (void)setBottomBar:(UIView *)bottomBar {
    if (_bottomBar == bottomBar) {
        return;
    }
    
    [_bottomBar removeFromSuperview];
    
    _bottomBar = bottomBar;
    
    [self addSubview:_bottomBar];
    [self setNeedsLayout];
}

@end

