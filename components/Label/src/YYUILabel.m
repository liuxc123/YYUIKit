//
//  YYUILabel.m
//  CatalogByConvention
//
//  Created by liuxc on 2021/11/22.
//

#import "YYUILabel.h"

@interface YYUILabel ()

@property(nonatomic, strong) UILongPressGestureRecognizer *longGestureRecognizer;
@end

@implementation YYUILabel

- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets {
    _contentEdgeInsets = contentEdgeInsets;
    [self setNeedsDisplay];
}

- (CGSize)sizeThatFits:(CGSize)size {
    size = [super sizeThatFits:CGSizeMake(size.width - self.contentEdgeInsets.left - self.contentEdgeInsets.right, size.height - self.contentEdgeInsets.top - self.contentEdgeInsets.bottom)];
    size.width += (self.contentEdgeInsets.left + self.contentEdgeInsets.right);
    size.height += self.contentEdgeInsets.top - self.contentEdgeInsets.bottom;
    return size;
}

- (CGSize)intrinsicContentSize {
    CGFloat preferredMaxLayoutWidth = self.preferredMaxLayoutWidth;
    if (preferredMaxLayoutWidth <= 0) {
        preferredMaxLayoutWidth = CGFLOAT_MAX;
    }
    return [self sizeThatFits:CGSizeMake(preferredMaxLayoutWidth, CGFLOAT_MAX)];
}

- (void)drawTextInRect:(CGRect)rect {
    rect = UIEdgeInsetsInsetRect(rect, self.contentEdgeInsets);
    
    // 在某些情况下文字位置错误，因此做了如下保护
    if (self.numberOfLines == 1 && (self.lineBreakMode == NSLineBreakByWordWrapping || self.lineBreakMode == NSLineBreakByCharWrapping)) {
        CGRect tempRect = rect;
        tempRect.size.height = CGRectGetHeight(rect) + self.contentEdgeInsets.top * 2;
        rect = tempRect;
    }
    
    [super drawTextInRect:rect];
}

#pragma mark - 长按复制功能

- (void)setCanPerformCopyAction:(BOOL)canPerformCopyAction {
    _canPerformCopyAction = canPerformCopyAction;
    if (_canPerformCopyAction && !self.longGestureRecognizer) {
        self.userInteractionEnabled = YES;
        self.longGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestureRecognizer:)];
        [self addGestureRecognizer:self.longGestureRecognizer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMenuWillHideNotification:) name:UIMenuControllerWillHideMenuNotification object:nil];
    } else if (!_canPerformCopyAction && self.longGestureRecognizer) {
        [self removeGestureRecognizer:self.longGestureRecognizer];
        self.longGestureRecognizer = nil;
        self.userInteractionEnabled = NO;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (BOOL)canBecomeFirstResponder {
    return self.canPerformCopyAction;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if ([self canBecomeFirstResponder]) {
        return action == @selector(copyString:);
    }
    return NO;
}

- (void)copyString:(id)sender {
    if (self.canPerformCopyAction) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        NSString *stringToCopy = self.text;
        if (stringToCopy) {
            pasteboard.string = stringToCopy;
            if (self.didCopyBlock) {
                self.didCopyBlock(self, stringToCopy);
            }
        }
    }
}

- (void)handleLongPressGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (!self.canPerformCopyAction) {
        return;
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        UIMenuItem *copyMenuItem = [[UIMenuItem alloc] initWithTitle:self.menuItemTitleForCopyAction ?: @"复制" action:@selector(copyString:)];
        [[UIMenuController sharedMenuController] setMenuItems:@[copyMenuItem]];
        [menuController setTargetRect:self.frame inView:self.superview];
        [menuController setMenuVisible:YES animated:YES];
        
        self.highlighted = YES;
    } else if (gestureRecognizer.state == UIGestureRecognizerStatePossible) {
        self.highlighted = NO;
    }
}

- (void)handleMenuWillHideNotification:(NSNotification *)notification {
    if (!self.canPerformCopyAction) {
        return;
    }
    
    [self setHighlighted:NO];
}

@end
