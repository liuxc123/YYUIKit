//
//  YYUIButton.m
//  CatalogByConvention
//
//  Created by liuxc on 2021/11/22.
//

#import "YYUIButton.h"

#import "YYMath.h"

inline static CGRect YYUIButtonCGRectSetX(CGRect rect, CGFloat x) {
    rect.origin.x = x;
    return rect;
}

inline static CGRect YYUIButtonCGRectSetY(CGRect rect, CGFloat y) {
    rect.origin.y = y;
    return rect;
}

inline static CGRect YYUIButtonCGRectSetWidth(CGRect rect, CGFloat width) {
    if (width < 0) {
        return rect;
    }
    rect.size.width = width;
    return rect;
}

inline static CGRect YYUIButtonCGRectSetHeight(CGRect rect, CGFloat height) {
    if (height < 0) {
        return rect;
    }
    rect.size.height = height;
    return rect;
}

inline static CGFloat YYUIButtonCGFloatGetCenter(CGFloat parent, CGFloat child) {
    return ((parent - child) / 2.0);
}

@implementation YYUIButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self didInitialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self didInitialize];
    }
    return self;
}

- (void)didInitialize {
    // 图片默认在按钮左边，与系统UIButton保持一致
    self.imagePosition = YYUIButtonImagePositionLeft;
}

// 系统访问 self.imageView 会触发 layout，而私有方法 _imageView 则是简单地访问 imageView，所以在 YYUIButton layoutSubviews 里应该用这个方法
- (UIImageView *)_yyui_imageView {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [self performSelector:NSSelectorFromString(@"_imageView")];
#pragma clang diagnostic pop
}

- (CGSize)sizeThatFits:(CGSize)size {
    // 如果调用 sizeToFit，那么传进来的 size 就是当前按钮的 size，此时的计算不要去限制宽高
    // 系统 UIButton 不管任何时候，对 sizeThatFits:CGSizeZero 都会返回真实的内容大小，这里对齐
    if (CGSizeEqualToSize(self.bounds.size, size) || size.width <= 0 || size.height <= 0) {
        size = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    }
    
    BOOL isImageViewShowing = !!self.currentImage;
    BOOL isTitleLabelShowing = !!self.currentTitle || self.currentAttributedTitle;
    CGSize imageTotalSize = CGSizeZero;// 包含 imageEdgeInsets 那些空间
    CGSize titleTotalSize = CGSizeZero;// 包含 titleEdgeInsets 那些空间
    CGFloat spacingBetweenImageAndTitle = (isImageViewShowing && isTitleLabelShowing ? self.spacingBetweenImageAndTitle : 0);// 如果图片或文字某一者没显示，则这个 spacing 不考虑进布局
    UIEdgeInsets contentEdgeInsets = self.contentEdgeInsets;
    CGSize resultSize = CGSizeZero;
    CGSize contentLimitSize = CGSizeMake(size.width - (contentEdgeInsets.left + contentEdgeInsets.right), size.height - (contentEdgeInsets.top + contentEdgeInsets.bottom));
    
    switch (self.imagePosition) {
        case YYUIButtonImagePositionTop:
        case YYUIButtonImagePositionBottom: {
            // 图片和文字上下排版时，宽度以文字或图片的最大宽度为最终宽度
            if (isImageViewShowing) {
                CGFloat imageLimitWidth = contentLimitSize.width - (self.imageEdgeInsets.left + self.imageEdgeInsets.right);
                CGSize imageSize = self.imageView.image ? [self.imageView sizeThatFits:CGSizeMake(imageLimitWidth, CGFLOAT_MAX)] : self.currentImage.size;
                imageSize.width = MIN(imageSize.width, imageLimitWidth);// YYUIButton sizeThatFits 时 self._imageView 为 nil 但 self.imageView 有值，而开启了 Bold Text 时，系统的 self.imageView sizeThatFits 返回值会比没开启 BoldText 时多 1pt（不知道为什么文字加粗与否会影响 imageView...），从而保证开启 Bold Text 后文字依然能完整展示出来，所以这里应该用 self.imageView 而不是 self._imageView
                imageTotalSize = CGSizeMake(imageSize.width + (self.imageEdgeInsets.left + self.imageEdgeInsets.right), imageSize.height + (self.imageEdgeInsets.top + self.imageEdgeInsets.bottom));
            }
            
            if (isTitleLabelShowing) {
                CGSize titleLimitSize = CGSizeMake(contentLimitSize.width - (self.titleEdgeInsets.left + self.titleEdgeInsets.right), contentLimitSize.height - imageTotalSize.height - spacingBetweenImageAndTitle - (self.titleEdgeInsets.top + self.titleEdgeInsets.bottom));
                CGSize titleSize = [self.titleLabel sizeThatFits:titleLimitSize];
                titleSize.height = MIN(titleSize.height, titleLimitSize.height);
                titleTotalSize = CGSizeMake(titleSize.width + (self.titleEdgeInsets.left + self.titleEdgeInsets.right), titleSize.height + (self.titleEdgeInsets.top + self.titleEdgeInsets.bottom));
            }
            
            resultSize.width = (contentEdgeInsets.left + contentEdgeInsets.right);
            resultSize.width += MAX(imageTotalSize.width, titleTotalSize.width);
            resultSize.height = (contentEdgeInsets.top + contentEdgeInsets.bottom) + imageTotalSize.height + spacingBetweenImageAndTitle + titleTotalSize.height;
        }
            break;
            
        case YYUIButtonImagePositionLeft:
        case YYUIButtonImagePositionRight: {
            // 图片和文字水平排版时，高度以文字或图片的最大高度为最终高度
            // 注意这里有一个和系统不一致的行为：当 titleLabel 为多行时，系统的 sizeThatFits: 计算结果固定是单行的，所以当 YYUIButtonImagePositionLeft 并且titleLabel 多行的情况下，YYUIButton 计算的结果与系统不一致
            
            if (isImageViewShowing) {
                CGFloat imageLimitHeight = contentLimitSize.height - (self.imageEdgeInsets.top + self.imageEdgeInsets.bottom);
                CGSize imageSize = self.imageView.image ? [self.imageView sizeThatFits:CGSizeMake(CGFLOAT_MAX, imageLimitHeight)] : self.currentImage.size;
                imageSize.height = MIN(imageSize.height, imageLimitHeight);// YYUIButton sizeThatFits 时 self._imageView 为 nil 但 self.imageView 有值，而开启了 Bold Text 时，系统的 self.imageView sizeThatFits 返回值会比没开启 BoldText 时多 1pt（不知道为什么文字加粗与否会影响 imageView...），从而保证开启 Bold Text 后文字依然能完整展示出来，所以这里应该用 self.imageView 而不是 self._imageView
                imageTotalSize = CGSizeMake(imageSize.width + (self.imageEdgeInsets.left + self.imageEdgeInsets.right), imageSize.height + (self.imageEdgeInsets.top + self.imageEdgeInsets.bottom));
            }
            
            if (isTitleLabelShowing) {
                CGSize titleLimitSize = CGSizeMake(contentLimitSize.width - (self.titleEdgeInsets.left + self.titleEdgeInsets.right) - imageTotalSize.width - spacingBetweenImageAndTitle, contentLimitSize.height - (self.titleEdgeInsets.top + self.titleEdgeInsets.bottom));
                CGSize titleSize = [self.titleLabel sizeThatFits:titleLimitSize];
                titleSize.height = MIN(titleSize.height, titleLimitSize.height);
                titleTotalSize = CGSizeMake(titleSize.width + (self.titleEdgeInsets.left + self.titleEdgeInsets.right), titleSize.height + (self.titleEdgeInsets.top + self.titleEdgeInsets.bottom));
            }
            
            resultSize.width = (contentEdgeInsets.left + contentEdgeInsets.right) + imageTotalSize.width + spacingBetweenImageAndTitle + titleTotalSize.width;
            resultSize.height = (contentEdgeInsets.top + contentEdgeInsets.bottom);
            resultSize.height += MAX(imageTotalSize.height, titleTotalSize.height);
        }
            break;
    }
    return resultSize;
}

- (CGSize)intrinsicContentSize {
    return [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (CGRectIsEmpty(self.bounds)) {
        return;
    }
    
    BOOL isImageViewShowing = !!self.currentImage;
    BOOL isTitleLabelShowing = !!self.currentTitle || !!self.currentAttributedTitle;
    CGSize imageLimitSize = CGSizeZero;
    CGSize titleLimitSize = CGSizeZero;
    CGSize imageTotalSize = CGSizeZero;// 包含 imageEdgeInsets 那些空间
    CGSize titleTotalSize = CGSizeZero;// 包含 titleEdgeInsets 那些空间
    CGFloat spacingBetweenImageAndTitle = (isImageViewShowing && isTitleLabelShowing ? self.spacingBetweenImageAndTitle : 0);// 如果图片或文字某一者没显示，则这个 spacing 不考虑进布局
    CGRect imageFrame = CGRectZero;
    CGRect titleFrame = CGRectZero;
    UIEdgeInsets contentEdgeInsets = self.contentEdgeInsets;
    CGSize contentSize = CGSizeMake(CGRectGetWidth(self.bounds) - (contentEdgeInsets.left + contentEdgeInsets.right), CGRectGetHeight(self.bounds) - (contentEdgeInsets.top + contentEdgeInsets.bottom));
    
    // 图片的布局原则都是尽量完整展示，所以不管 imagePosition 的值是什么，这个计算过程都是相同的
    if (isImageViewShowing) {
        imageLimitSize = CGSizeMake(contentSize.width - (self.imageEdgeInsets.left + self.imageEdgeInsets.right), contentSize.height - (self.imageEdgeInsets.top + self.imageEdgeInsets.bottom));
        CGSize imageSize = self._yyui_imageView.image ? [self._yyui_imageView sizeThatFits:imageLimitSize] : self.currentImage.size;
        imageSize.width = MIN(imageLimitSize.width, imageSize.width);
        imageSize.height = MIN(imageLimitSize.height, imageSize.height);
        imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        imageTotalSize = CGSizeMake(imageSize.width + (self.imageEdgeInsets.left + self.imageEdgeInsets.right), imageSize.height + (self.imageEdgeInsets.top + self.imageEdgeInsets.bottom));
    }
    
    // UIButton 如果本身大小为 (0,0)，此时设置一个 imageEdgeInsets 会让 imageView 的 bounds 错误，导致后续 imageView 的 subviews 布局时会产生偏移，因此这里做一次保护
    void (^makesureBoundsPositive)(UIView *) = ^void(UIView *view) {
        CGRect bounds = view.bounds;
        if (CGRectGetMinX(bounds) < 0 || CGRectGetMinY(bounds) < 0) {
            bounds = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
            view.bounds = bounds;
        }
    };
    if (isImageViewShowing) {
        makesureBoundsPositive(self._yyui_imageView);
    }
    if (isTitleLabelShowing) {
        makesureBoundsPositive(self.titleLabel);
    }
    
    if (self.imagePosition == YYUIButtonImagePositionTop || self.imagePosition == YYUIButtonImagePositionBottom) {
        
        if (isTitleLabelShowing) {
            titleLimitSize = CGSizeMake(contentSize.width - (self.titleEdgeInsets.left + self.titleEdgeInsets.right), contentSize.height - imageTotalSize.height - spacingBetweenImageAndTitle - (self.titleEdgeInsets.top + self.titleEdgeInsets.bottom));
            CGSize titleSize = [self.titleLabel sizeThatFits:titleLimitSize];
            titleSize.width = MIN(titleLimitSize.width, titleSize.width);
            titleSize.height = MIN(titleLimitSize.height, titleSize.height);
            titleFrame = CGRectMake(0, 0, titleSize.width, titleSize.height);
            titleTotalSize = CGSizeMake(titleSize.width + (self.titleEdgeInsets.left + self.titleEdgeInsets.right), titleSize.height + (self.titleEdgeInsets.top + self.titleEdgeInsets.bottom));
        }
        
        switch (self.contentHorizontalAlignment) {
            case UIControlContentHorizontalAlignmentLeft:
                imageFrame = isImageViewShowing ? YYUIButtonCGRectSetX(imageFrame, contentEdgeInsets.left + self.imageEdgeInsets.left) : imageFrame;
                titleFrame = isTitleLabelShowing ? YYUIButtonCGRectSetX(titleFrame, contentEdgeInsets.left + self.titleEdgeInsets.left) : titleFrame;
                break;
            case UIControlContentHorizontalAlignmentCenter:
                imageFrame = isImageViewShowing ? YYUIButtonCGRectSetX(imageFrame, contentEdgeInsets.left + self.imageEdgeInsets.left + YYUIButtonCGFloatGetCenter(imageLimitSize.width, CGRectGetWidth(imageFrame))) : imageFrame;
                titleFrame = isTitleLabelShowing ? YYUIButtonCGRectSetX(titleFrame, contentEdgeInsets.left + self.titleEdgeInsets.left + YYUIButtonCGFloatGetCenter(titleLimitSize.width, CGRectGetWidth(titleFrame))) : titleFrame;
                break;
            case UIControlContentHorizontalAlignmentRight:
                imageFrame = isImageViewShowing ? YYUIButtonCGRectSetX(imageFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - self.imageEdgeInsets.right - CGRectGetWidth(imageFrame)) : imageFrame;
                titleFrame = isTitleLabelShowing ? YYUIButtonCGRectSetX(titleFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - self.titleEdgeInsets.right - CGRectGetWidth(titleFrame)) : titleFrame;
                break;
            case UIControlContentHorizontalAlignmentFill:
                if (isImageViewShowing) {
                    imageFrame = YYUIButtonCGRectSetX(imageFrame, contentEdgeInsets.left + self.imageEdgeInsets.left);
                    imageFrame = YYUIButtonCGRectSetWidth(imageFrame, imageLimitSize.width);
                }
                if (isTitleLabelShowing) {
                    titleFrame = YYUIButtonCGRectSetX(titleFrame, contentEdgeInsets.left + self.titleEdgeInsets.left);
                    titleFrame = YYUIButtonCGRectSetWidth(titleFrame, titleLimitSize.width);
                }
                break;
            default:
                break;
        }
        
        if (self.imagePosition == YYUIButtonImagePositionTop) {
            switch (self.contentVerticalAlignment) {
                case UIControlContentVerticalAlignmentTop:
                    imageFrame = isImageViewShowing ? YYUIButtonCGRectSetY(imageFrame, contentEdgeInsets.top + self.imageEdgeInsets.top) : imageFrame;
                    titleFrame = isTitleLabelShowing ? YYUIButtonCGRectSetY(titleFrame, contentEdgeInsets.top + imageTotalSize.height + spacingBetweenImageAndTitle + self.titleEdgeInsets.top) : titleFrame;
                    break;
                case UIControlContentVerticalAlignmentCenter: {
                    CGFloat contentHeight = imageTotalSize.height + spacingBetweenImageAndTitle + titleTotalSize.height;
                    CGFloat minY = YYUIButtonCGFloatGetCenter(contentSize.height, contentHeight) + contentEdgeInsets.top;
                    imageFrame = isImageViewShowing ? YYUIButtonCGRectSetY(imageFrame, minY + self.imageEdgeInsets.top) : imageFrame;
                    titleFrame = isTitleLabelShowing ? YYUIButtonCGRectSetY(titleFrame, minY + imageTotalSize.height + spacingBetweenImageAndTitle + self.titleEdgeInsets.top) : titleFrame;
                }
                    break;
                case UIControlContentVerticalAlignmentBottom:
                    titleFrame = isTitleLabelShowing ? YYUIButtonCGRectSetY(titleFrame, CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - self.titleEdgeInsets.bottom - CGRectGetHeight(titleFrame)) : titleFrame;
                    imageFrame = isImageViewShowing ? YYUIButtonCGRectSetY(imageFrame, CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - titleTotalSize.height - spacingBetweenImageAndTitle - self.imageEdgeInsets.bottom - CGRectGetHeight(imageFrame)) : imageFrame;
                    break;
                case UIControlContentVerticalAlignmentFill: {
                    if (isImageViewShowing && isTitleLabelShowing) {
                        
                        // 同时显示图片和 label 的情况下，图片高度按本身大小显示，剩余空间留给 label
                        imageFrame = isImageViewShowing ? YYUIButtonCGRectSetY(imageFrame, contentEdgeInsets.top + self.imageEdgeInsets.top) : imageFrame;
                        titleFrame = isTitleLabelShowing ? YYUIButtonCGRectSetY(titleFrame, contentEdgeInsets.top + imageTotalSize.height + spacingBetweenImageAndTitle + self.titleEdgeInsets.top) : titleFrame;
                        titleFrame = isTitleLabelShowing ? YYUIButtonCGRectSetHeight(titleFrame, CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - self.titleEdgeInsets.bottom - CGRectGetMinY(titleFrame)) : titleFrame;
                        
                    } else if (isImageViewShowing) {
                        imageFrame = YYUIButtonCGRectSetY(imageFrame, contentEdgeInsets.top + self.imageEdgeInsets.top);
                        imageFrame = YYUIButtonCGRectSetHeight(imageFrame, contentSize.height - (self.imageEdgeInsets.top + self.imageEdgeInsets.bottom));
                    } else {
                        titleFrame = YYUIButtonCGRectSetY(titleFrame, contentEdgeInsets.top + self.titleEdgeInsets.top);
                        titleFrame = YYUIButtonCGRectSetHeight(titleFrame, contentSize.height - (self.titleEdgeInsets.top + self.titleEdgeInsets.bottom));
                    }
                }
                    break;
            }
        } else {
            switch (self.contentVerticalAlignment) {
                case UIControlContentVerticalAlignmentTop:
                    titleFrame = isTitleLabelShowing ? YYUIButtonCGRectSetY(titleFrame, contentEdgeInsets.top + self.titleEdgeInsets.top) : titleFrame;
                    imageFrame = isImageViewShowing ? YYUIButtonCGRectSetY(imageFrame, contentEdgeInsets.top + titleTotalSize.height + spacingBetweenImageAndTitle + self.imageEdgeInsets.top) : imageFrame;
                    break;
                case UIControlContentVerticalAlignmentCenter: {
                    CGFloat contentHeight = imageTotalSize.height + titleTotalSize.height + spacingBetweenImageAndTitle;
                    CGFloat minY = YYUIButtonCGFloatGetCenter(contentSize.height, contentHeight) + contentEdgeInsets.top;
                    titleFrame = isTitleLabelShowing ? YYUIButtonCGRectSetY(titleFrame, minY + self.titleEdgeInsets.top) : titleFrame;
                    imageFrame = isImageViewShowing ? YYUIButtonCGRectSetY(imageFrame, minY + titleTotalSize.height + spacingBetweenImageAndTitle + self.imageEdgeInsets.top) : imageFrame;
                }
                    break;
                case UIControlContentVerticalAlignmentBottom:
                    imageFrame = isImageViewShowing ? YYUIButtonCGRectSetY(imageFrame, CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - self.imageEdgeInsets.bottom - CGRectGetHeight(imageFrame)) : imageFrame;
                    titleFrame = isTitleLabelShowing ? YYUIButtonCGRectSetY(titleFrame, CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - imageTotalSize.height - spacingBetweenImageAndTitle - self.titleEdgeInsets.bottom - CGRectGetHeight(titleFrame)) : titleFrame;
                    break;
                case UIControlContentVerticalAlignmentFill: {
                    if (isImageViewShowing && isTitleLabelShowing) {
                        
                        // 同时显示图片和 label 的情况下，图片高度按本身大小显示，剩余空间留给 label
                        imageFrame = YYUIButtonCGRectSetY(imageFrame, CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - self.imageEdgeInsets.bottom - CGRectGetHeight(imageFrame));
                        titleFrame = YYUIButtonCGRectSetY(titleFrame, contentEdgeInsets.top + self.titleEdgeInsets.top);
                        titleFrame = YYUIButtonCGRectSetHeight(titleFrame, CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - imageTotalSize.height - spacingBetweenImageAndTitle - self.titleEdgeInsets.bottom - CGRectGetMinY(titleFrame));
                        
                    } else if (isImageViewShowing) {
                        imageFrame = YYUIButtonCGRectSetY(imageFrame, contentEdgeInsets.top + self.imageEdgeInsets.top);
                        imageFrame = YYUIButtonCGRectSetHeight(imageFrame, contentSize.height - (self.imageEdgeInsets.top + self.imageEdgeInsets.bottom));
                    } else {
                        titleFrame = YYUIButtonCGRectSetY(titleFrame, contentEdgeInsets.top + self.titleEdgeInsets.top);
                        titleFrame = YYUIButtonCGRectSetHeight(titleFrame, contentSize.height - (self.titleEdgeInsets.top + self.titleEdgeInsets.bottom));
                    }
                }
                    break;
            }
        }
        
        if (isImageViewShowing) {
            self._yyui_imageView.frame = imageFrame;
        }
        if (isTitleLabelShowing) {
            self.titleLabel.frame = titleFrame;
        }
        
    } else if (self.imagePosition == YYUIButtonImagePositionLeft || self.imagePosition == YYUIButtonImagePositionRight) {
        
        if (isTitleLabelShowing) {
            titleLimitSize = CGSizeMake(contentSize.width - (self.titleEdgeInsets.left + self.titleEdgeInsets.right) - imageTotalSize.width - spacingBetweenImageAndTitle, contentSize.height - (self.titleEdgeInsets.top + self.titleEdgeInsets.bottom));
            CGSize titleSize = [self.titleLabel sizeThatFits:titleLimitSize];
            titleSize.width = MIN(titleLimitSize.width, titleSize.width);
            titleSize.height = MIN(titleLimitSize.height, titleSize.height);
            titleFrame = CGRectMake(0, 0, titleSize.width, titleSize.height);
            titleTotalSize = CGSizeMake(titleSize.width + (self.titleEdgeInsets.left + self.titleEdgeInsets.right), titleSize.height + (self.titleEdgeInsets.top + self.titleEdgeInsets.bottom));
        }
        
        switch (self.contentVerticalAlignment) {
            case UIControlContentVerticalAlignmentTop:
                imageFrame = isImageViewShowing ? YYUIButtonCGRectSetY(imageFrame, contentEdgeInsets.top + self.imageEdgeInsets.top) : imageFrame;
                titleFrame = isTitleLabelShowing ? YYUIButtonCGRectSetY(titleFrame, contentEdgeInsets.top + self.titleEdgeInsets.top) : titleFrame;
                
                break;
            case UIControlContentVerticalAlignmentCenter:
                imageFrame = isImageViewShowing ? YYUIButtonCGRectSetY(imageFrame, contentEdgeInsets.top + YYUIButtonCGFloatGetCenter(contentSize.height, CGRectGetHeight(imageFrame)) + self.imageEdgeInsets.top) : imageFrame;
                titleFrame = isTitleLabelShowing ? YYUIButtonCGRectSetY(titleFrame, contentEdgeInsets.top + YYUIButtonCGFloatGetCenter(contentSize.height, CGRectGetHeight(titleFrame)) + self.titleEdgeInsets.top) : titleFrame;
                break;
            case UIControlContentVerticalAlignmentBottom:
                imageFrame = isImageViewShowing ? YYUIButtonCGRectSetY(imageFrame, CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - self.imageEdgeInsets.bottom - CGRectGetHeight(imageFrame)) : imageFrame;
                titleFrame = isTitleLabelShowing ? YYUIButtonCGRectSetY(titleFrame, CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - self.titleEdgeInsets.bottom - CGRectGetHeight(titleFrame)) : titleFrame;
                break;
            case UIControlContentVerticalAlignmentFill:
                if (isImageViewShowing) {
                    imageFrame = YYUIButtonCGRectSetY(imageFrame, contentEdgeInsets.top + self.imageEdgeInsets.top);
                    imageFrame = YYUIButtonCGRectSetHeight(imageFrame, contentSize.height - (self.imageEdgeInsets.top + self.imageEdgeInsets.bottom));
                }
                if (isTitleLabelShowing) {
                    titleFrame = YYUIButtonCGRectSetY(titleFrame, contentEdgeInsets.top + self.titleEdgeInsets.top);
                    titleFrame = YYUIButtonCGRectSetHeight(titleFrame, contentSize.height - (self.titleEdgeInsets.top + self.titleEdgeInsets.bottom));
                }
                break;
        }
        
        if (self.imagePosition == YYUIButtonImagePositionLeft) {
            switch (self.contentHorizontalAlignment) {
                case UIControlContentHorizontalAlignmentLeft:
                    imageFrame = isImageViewShowing ? YYUIButtonCGRectSetX(imageFrame, contentEdgeInsets.left + self.imageEdgeInsets.left) : imageFrame;
                    titleFrame = isTitleLabelShowing ? YYUIButtonCGRectSetX(titleFrame, contentEdgeInsets.left + imageTotalSize.width + spacingBetweenImageAndTitle + self.titleEdgeInsets.left) : titleFrame;
                    break;
                case UIControlContentHorizontalAlignmentCenter: {
                    CGFloat contentWidth = imageTotalSize.width + spacingBetweenImageAndTitle + titleTotalSize.width;
                    CGFloat minX = contentEdgeInsets.left + YYUIButtonCGFloatGetCenter(contentSize.width, contentWidth);
                    imageFrame = isImageViewShowing ? YYUIButtonCGRectSetX(imageFrame, minX + self.imageEdgeInsets.left) : imageFrame;
                    titleFrame = isTitleLabelShowing ? YYUIButtonCGRectSetX(titleFrame, minX + imageTotalSize.width + spacingBetweenImageAndTitle + self.titleEdgeInsets.left) : titleFrame;
                }
                    break;
                case UIControlContentHorizontalAlignmentRight: {
                    if (imageTotalSize.width + spacingBetweenImageAndTitle + titleTotalSize.width > contentSize.width) {
                        // 图片和文字总宽超过按钮宽度，则优先完整显示图片
                        imageFrame = isImageViewShowing ? YYUIButtonCGRectSetX(imageFrame, contentEdgeInsets.left + self.imageEdgeInsets.left) : imageFrame;
                        titleFrame = isTitleLabelShowing ? YYUIButtonCGRectSetX(titleFrame, contentEdgeInsets.left + imageTotalSize.width + spacingBetweenImageAndTitle + self.titleEdgeInsets.left) : titleFrame;
                    } else {
                        // 内容不超过按钮宽度，则靠右布局即可
                        titleFrame = isTitleLabelShowing ? YYUIButtonCGRectSetX(titleFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - self.titleEdgeInsets.right - CGRectGetWidth(titleFrame)) : titleFrame;
                        imageFrame = isImageViewShowing ? YYUIButtonCGRectSetX(imageFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - titleTotalSize.width - spacingBetweenImageAndTitle - imageTotalSize.width + self.imageEdgeInsets.left) : imageFrame;
                    }
                }
                    break;
                case UIControlContentHorizontalAlignmentFill: {
                    if (isImageViewShowing && isTitleLabelShowing) {
                        // 同时显示图片和 label 的情况下，图片按本身宽度显示，剩余空间留给 label
                        imageFrame = YYUIButtonCGRectSetX(imageFrame, contentEdgeInsets.left + self.imageEdgeInsets.left);
                        titleFrame = YYUIButtonCGRectSetX(titleFrame, contentEdgeInsets.left + imageTotalSize.width + spacingBetweenImageAndTitle + self.titleEdgeInsets.left);
                        titleFrame = YYUIButtonCGRectSetWidth(titleFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - self.titleEdgeInsets.right - CGRectGetMinX(titleFrame));
                    } else if (isImageViewShowing) {
                        imageFrame = YYUIButtonCGRectSetX(imageFrame, contentEdgeInsets.left + self.imageEdgeInsets.left);
                        imageFrame = YYUIButtonCGRectSetWidth(imageFrame, contentSize.width - (self.imageEdgeInsets.left + self.imageEdgeInsets.right));
                    } else {
                        titleFrame = YYUIButtonCGRectSetX(titleFrame, contentEdgeInsets.left + self.titleEdgeInsets.left);
                        titleFrame = YYUIButtonCGRectSetWidth(titleFrame, contentSize.width - (self.titleEdgeInsets.left + self.titleEdgeInsets.right));
                    }
                }
                    break;
                default:
                    break;
            }
        } else {
            switch (self.contentHorizontalAlignment) {
                case UIControlContentHorizontalAlignmentLeft: {
                    if (imageTotalSize.width + spacingBetweenImageAndTitle + titleTotalSize.width > contentSize.width) {
                        // 图片和文字总宽超过按钮宽度，则优先完整显示图片
                        imageFrame = isImageViewShowing ? YYUIButtonCGRectSetX(imageFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - self.imageEdgeInsets.right - CGRectGetWidth(imageFrame)) : imageFrame;
                        titleFrame = isTitleLabelShowing ? YYUIButtonCGRectSetX(titleFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - imageTotalSize.width - spacingBetweenImageAndTitle - titleTotalSize.width + self.titleEdgeInsets.left) : titleFrame;
                    } else {
                        // 内容不超过按钮宽度，则靠左布局即可
                        titleFrame = isTitleLabelShowing ? YYUIButtonCGRectSetX(titleFrame, contentEdgeInsets.left + self.titleEdgeInsets.left) : titleFrame;
                        imageFrame = isImageViewShowing ? YYUIButtonCGRectSetX(imageFrame, contentEdgeInsets.left + titleTotalSize.width + spacingBetweenImageAndTitle + self.imageEdgeInsets.left) : imageFrame;
                    }
                }
                    break;
                case UIControlContentHorizontalAlignmentCenter: {
                    CGFloat contentWidth = imageTotalSize.width + spacingBetweenImageAndTitle + titleTotalSize.width;
                    CGFloat minX = contentEdgeInsets.left + YYUIButtonCGFloatGetCenter(contentSize.width, contentWidth);
                    titleFrame = isTitleLabelShowing ? YYUIButtonCGRectSetX(titleFrame, minX + self.titleEdgeInsets.left) : titleFrame;
                    imageFrame = isImageViewShowing ? YYUIButtonCGRectSetX(imageFrame, minX + titleTotalSize.width + spacingBetweenImageAndTitle + self.imageEdgeInsets.left) : imageFrame;
                }
                    break;
                case UIControlContentHorizontalAlignmentRight:
                    imageFrame = isImageViewShowing ? YYUIButtonCGRectSetX(imageFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - self.imageEdgeInsets.right - CGRectGetWidth(imageFrame)) : imageFrame;
                    titleFrame = isTitleLabelShowing ? YYUIButtonCGRectSetX(titleFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - imageTotalSize.width - spacingBetweenImageAndTitle - self.titleEdgeInsets.right - CGRectGetWidth(titleFrame)) : titleFrame;
                    break;
                case UIControlContentHorizontalAlignmentFill: {
                    if (isImageViewShowing && isTitleLabelShowing) {
                        // 图片按自身大小显示，剩余空间由标题占满
                        imageFrame = YYUIButtonCGRectSetX(imageFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - self.imageEdgeInsets.right - CGRectGetWidth(imageFrame));
                        titleFrame = YYUIButtonCGRectSetX(titleFrame, contentEdgeInsets.left + self.titleEdgeInsets.left);
                        titleFrame = YYUIButtonCGRectSetWidth(titleFrame, CGRectGetMinX(imageFrame) - self.imageEdgeInsets.left - spacingBetweenImageAndTitle - self.titleEdgeInsets.right - CGRectGetMinX(titleFrame));
                        
                    } else if (isImageViewShowing) {
                        imageFrame = YYUIButtonCGRectSetX(imageFrame, contentEdgeInsets.left + self.imageEdgeInsets.left);
                        imageFrame = YYUIButtonCGRectSetWidth(imageFrame, contentSize.width - (self.imageEdgeInsets.left + self.imageEdgeInsets.right));
                    } else {
                        titleFrame = YYUIButtonCGRectSetX(titleFrame, contentEdgeInsets.left + self.titleEdgeInsets.left);
                        titleFrame = YYUIButtonCGRectSetWidth(titleFrame, contentSize.width - (self.titleEdgeInsets.left + self.titleEdgeInsets.right));
                    }
                }
                    break;
                default:
                    break;
            }
        }
        
        if (isImageViewShowing) {
            self._yyui_imageView.frame = imageFrame;
        }
        if (isTitleLabelShowing) {
            self.titleLabel.frame = titleFrame;
        }
    }
}

- (void)setSpacingBetweenImageAndTitle:(CGFloat)spacingBetweenImageAndTitle {
    _spacingBetweenImageAndTitle = spacingBetweenImageAndTitle;
    
    [self setNeedsLayout];
}

- (void)setImagePosition:(YYUIButtonImagePosition)imagePosition {
    _imagePosition = imagePosition;
    
    [self setNeedsLayout];
}



@end
