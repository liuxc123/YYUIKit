//
//  YYUIEmptyView.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/23.
//

#import "YYUIEmptyView.h"

@interface YYUIEmptyView ()

@property(nonatomic, strong) UIScrollView *scrollView;  // 保证内容超出屏幕时也不至于直接被clip（比如横屏时）

@end

@implementation YYUIEmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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
    self.scrollView = [[UIScrollView alloc] init];
    if (@available(iOS 11, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 16, 0, 16);
    [self addSubview:self.scrollView];
    
    _contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    _loadingView = (UIView<YYUIEmptyViewLoadingViewProtocol> *)[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    ((UIActivityIndicatorView *)self.loadingView).hidesWhenStopped = NO;    // 此控件是通过loadingView.hidden属性来控制显隐的，如果UIActivityIndicatorView的hidesWhenStopped属性设置为YES的话，则手动设置它的hidden属性就会失效，因此这里要置为NO
    [self.contentView addSubview:self.loadingView];
    
    _imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:self.imageView];
    
    _textLabel = [[UILabel alloc] init];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.numberOfLines = 0;
    [self.contentView addSubview:self.textLabel];
    
    _detailTextLabel = [[UILabel alloc] init];
    self.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    self.detailTextLabel.numberOfLines = 0;
    [self.contentView addSubview:self.detailTextLabel];
    
    _actionButton = [[UIButton alloc] init];
    [self.contentView addSubview:self.actionButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.scrollView.frame = self.bounds;

    CGSize contentViewSize = [self sizeThatContentViewFits];
    // contentView 默认垂直居中于 scrollView
    self.contentView.frame = CGRectMake(0, CGRectGetMidY(self.scrollView.bounds) - contentViewSize.height / 2 + self.verticalOffset, contentViewSize.width, contentViewSize.height);

    // 如果 contentView 要比 scrollView 高，则置顶展示
    if (CGRectGetHeight(self.contentView.bounds) > CGRectGetHeight(self.scrollView.bounds)) {
        CGRect frame = self.contentView.frame;
        frame.origin.y = 0;
        self.contentView.frame = frame;
    }

    self.scrollView.contentSize = CGSizeMake(MAX(CGRectGetWidth(self.scrollView.bounds) - (self.scrollView.contentInset.left + self.scrollView.contentInset.right), contentViewSize.width), MAX(CGRectGetHeight(self.scrollView.bounds) - (self.scrollView.contentInset.top + self.scrollView.contentInset.bottom), CGRectGetMaxY(self.contentView.frame)));

    CGFloat originY = 0;

    if (!self.imageView.hidden) {
        [self.imageView sizeToFit];
        CGRect frame = self.imageView.frame;
        frame.origin.x = (CGRectGetWidth(self.contentView.bounds) - CGRectGetWidth(self.imageView.frame)) / 2.0 + self.imageViewInsets.left - self.imageViewInsets.right;
        frame.origin.y = originY + self.imageViewInsets.top;
        self.imageView.frame = frame;
        originY = CGRectGetMaxY(self.imageView.frame) + self.imageViewInsets.bottom;
    }

    if (!self.loadingView.hidden) {
        CGRect frame = self.loadingView.frame;
        frame.origin.x = (CGRectGetWidth(self.contentView.bounds) - CGRectGetWidth(self.loadingView.frame)) / 2.0 + self.loadingViewInsets.left - self.loadingViewInsets.right;
        frame.origin.y = originY + self.loadingViewInsets.top;
        self.loadingView.frame = frame;
        originY = CGRectGetMaxY(self.loadingView.frame) + self.loadingViewInsets.bottom;
    }

    if (!self.textLabel.hidden) {
        CGRect frame = self.textLabel.frame;
        frame.origin.x = self.textLabelInsets.left;
        frame.origin.y = originY + self.textLabelInsets.top;
        frame.size.width = CGRectGetWidth(self.contentView.bounds) - (self.textLabelInsets.left + self.textLabelInsets.right);
        frame.size.height = [self.textLabel sizeThatFits:CGSizeMake(CGRectGetWidth(frame), CGFLOAT_MAX)].height;
        self.textLabel.frame = frame;
        originY = CGRectGetMaxY(self.textLabel.frame) + self.textLabelInsets.bottom;
    }

    if (!self.detailTextLabel.hidden) {
        CGRect frame = self.detailTextLabel.frame;
        frame.origin.x = self.detailTextLabelInsets.left;
        frame.origin.y = originY + self.detailTextLabelInsets.top;
        frame.size.width = CGRectGetWidth(self.contentView.bounds) - (self.detailTextLabelInsets.left + self.detailTextLabelInsets.right);
        frame.size.height = [self.detailTextLabel sizeThatFits:CGSizeMake(CGRectGetWidth(frame), CGFLOAT_MAX)].height;
        self.detailTextLabel.frame = frame;
        originY = CGRectGetMaxY(self.detailTextLabel.frame) + self.detailTextLabelInsets.bottom;
    }

    if (!self.actionButton.hidden) {
        [self.actionButton sizeToFit];
        CGRect frame = self.actionButton.frame;
        frame.origin.x = (self.contentView.bounds.size.width - self.actionButton.frame.size.width) / 2.0 + self.actionButtonInsets.left - self.actionButtonInsets.right;
        frame.origin.y = originY + self.actionButtonInsets.top;
        self.actionButton.frame = frame;
        originY = CGRectGetMaxY(self.actionButton.frame) + self.actionButtonInsets.bottom;
    }
}

- (CGSize)sizeThatContentViewFits {
    CGFloat resultWidth = CGRectGetWidth(self.scrollView.bounds) - (self.scrollView.contentInset.left + self.scrollView.contentInset.right);
    CGFloat resultHeight = 0;
    if (!self.imageView.hidden) {
        CGFloat imageViewHeight = [self.imageView sizeThatFits:CGSizeMake(resultWidth - (self.imageViewInsets.left + self.imageViewInsets.right), CGFLOAT_MAX)].height + (self.imageViewInsets.top + self.imageViewInsets.bottom);
        resultHeight += imageViewHeight;
    }
    if (!self.loadingView.hidden) {
        CGFloat loadingViewHeight = CGRectGetHeight(self.loadingView.bounds) + (self.loadingViewInsets.top + self.loadingViewInsets.bottom);
        resultHeight += loadingViewHeight;
    }
    if (!self.textLabel.hidden) {
        CGFloat textLabelHeight = [self.textLabel sizeThatFits:CGSizeMake(resultWidth - (self.textLabelInsets.left + self.textLabelInsets.right), CGFLOAT_MAX)].height + (self.textLabelInsets.top + self.textLabelInsets.bottom);
        resultHeight += textLabelHeight;
    }
    if (!self.detailTextLabel.hidden) {
        CGFloat detailTextLabelHeight = [self.detailTextLabel sizeThatFits:CGSizeMake(resultWidth - (self.detailTextLabelInsets.left + self.detailTextLabelInsets.right), CGFLOAT_MAX)].height + (self.detailTextLabelInsets.top + self.detailTextLabelInsets.bottom);
        resultHeight += detailTextLabelHeight;
    }
    if (!self.actionButton.hidden) {
        CGFloat actionButtonHeight = [self.actionButton sizeThatFits:CGSizeMake(resultWidth - (self.actionButtonInsets.left + self.actionButtonInsets.right), CGFLOAT_MAX)].height + (self.actionButtonInsets.top + self.actionButtonInsets.bottom);
        resultHeight += actionButtonHeight;
    }
    
    return CGSizeMake(resultWidth, resultHeight);
}

- (void)updateDetailTextLabelWithText:(NSString *)text {
    if (self.detailTextLabelFont && self.detailTextLabelTextColor && text) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.minimumLineHeight = self.detailTextLabelFont.pointSize + 10;
        paragraphStyle.maximumLineHeight = self.detailTextLabelFont.pointSize + 10;
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: self.detailTextLabelFont,
                                                                                                  NSForegroundColorAttributeName: self.detailTextLabelTextColor,
                                                                                                  NSParagraphStyleAttributeName: paragraphStyle}];
        self.detailTextLabel.attributedText = string;
    }
    self.detailTextLabel.hidden = !text;
    [self setNeedsLayout];
}

- (void)setLoadingView:(UIView<YYUIEmptyViewLoadingViewProtocol> *)loadingView {
    if (self.loadingView != loadingView) {
        [self.loadingView removeFromSuperview];
        _loadingView = loadingView;
        [self.contentView addSubview:loadingView];
    }
    [self setNeedsLayout];
}

- (void)setLoadingViewHidden:(BOOL)hidden {
    self.loadingView.hidden = hidden;
    if (!hidden && [self.loadingView respondsToSelector:@selector(startAnimating)]) {
        [self.loadingView startAnimating];
    }
    [self setNeedsLayout];
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
    self.imageView.hidden = !image;
    [self setNeedsLayout];
}

- (void)setTextLabelText:(NSString *)text {
    self.textLabel.text = text;
    self.textLabel.hidden = !text;
    [self setNeedsLayout];
}

- (void)setDetailTextLabelText:(NSString *)text {
    [self updateDetailTextLabelWithText:text];
}

- (void)setActionButtonTitle:(NSString *)title {
    [self.actionButton setTitle:title forState:UIControlStateNormal];
    self.actionButton.hidden = !title;
    [self setNeedsLayout];
}

- (void)setImageViewInsets:(UIEdgeInsets)imageViewInsets {
    _imageViewInsets = imageViewInsets;
    [self setNeedsLayout];
}

- (void)setTextLabelInsets:(UIEdgeInsets)textLabelInsets {
    _textLabelInsets = textLabelInsets;
    [self setNeedsLayout];
}

- (void)setDetailTextLabelInsets:(UIEdgeInsets)detailTextLabelInsets {
    _detailTextLabelInsets = detailTextLabelInsets;
    [self setNeedsLayout];
}

- (void)setActionButtonInsets:(UIEdgeInsets)actionButtonInsets {
    _actionButtonInsets = actionButtonInsets;
    [self setNeedsLayout];
}

- (void)setVerticalOffset:(CGFloat)verticalOffset {
    _verticalOffset = verticalOffset;
    [self setNeedsLayout];
}

- (void)setTextLabelFont:(UIFont *)textLabelFont {
    _textLabelFont = textLabelFont;
    self.textLabel.font = textLabelFont;
    [self setNeedsLayout];
}

- (void)setDetailTextLabelFont:(UIFont *)detailTextLabelFont {
    _detailTextLabelFont = detailTextLabelFont;
    [self updateDetailTextLabelWithText:self.detailTextLabel.text];
}

- (void)setActionButtonFont:(UIFont *)actionButtonFont {
    _actionButtonFont = actionButtonFont;
    self.actionButton.titleLabel.font = actionButtonFont;
    [self setNeedsLayout];
}

- (void)setTextLabelTextColor:(UIColor *)textLabelTextColor {
    _textLabelTextColor = textLabelTextColor;
    self.textLabel.textColor = textLabelTextColor;
}

- (void)setDetailTextLabelTextColor:(UIColor *)detailTextLabelTextColor {
    _detailTextLabelTextColor = detailTextLabelTextColor;
    [self updateDetailTextLabelWithText:self.detailTextLabel.text];
}

- (void)setActionButtonTitleColor:(UIColor *)actionButtonTitleColor {
    _actionButtonTitleColor = actionButtonTitleColor;
    [self.actionButton setTitleColor:actionButtonTitleColor forState:UIControlStateNormal];
}


@end

@interface YYUIEmptyView (UIAppearance)

@end

@implementation YYUIEmptyView (UIAppearance)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setDefaultAppearance];
    });
}

+ (void)setDefaultAppearance {
    YYUIEmptyView *appearance = [YYUIEmptyView appearance];
    appearance.imageViewInsets = UIEdgeInsetsMake(0, 0, 36, 0);
    appearance.loadingViewInsets = UIEdgeInsetsMake(0, 0, 36, 0);
    appearance.textLabelInsets = UIEdgeInsetsMake(0, 0, 10, 0);
    appearance.detailTextLabelInsets = UIEdgeInsetsMake(0, 0, 14, 0);
    appearance.actionButtonInsets = UIEdgeInsetsZero;
    appearance.verticalOffset = -30;
    
    appearance.textLabelFont = [UIFont systemFontOfSize:16];
    appearance.detailTextLabelFont = [UIFont systemFontOfSize:14];
    appearance.actionButtonFont = [UIFont systemFontOfSize:15];
    
    appearance.textLabelTextColor = [UIColor colorWithRed:93.0/255.0 green:100.0/255.0 blue:110.0/255.0 alpha:1.0];
    appearance.detailTextLabelTextColor = [UIColor colorWithRed:133.0/255.0 green:140.0/255.0 blue:150.0/255.0 alpha:1.0];
    appearance.actionButtonTitleColor = [UIColor blueColor];
}

@end
