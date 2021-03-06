//
//  YYUIHeaderStackView.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/17.
//

#import <UIKit/UIKit.h>

/**
 The YYUIHeaderStackView class lays out a vertical stack of two views.

 Both bars provided to this view must implement sizeThatFits and return their best-fit
 dimensions.

 # Layout Behavior

 The layout behavior of the two bars is as follows:

 topBar: top aligned, expands to fill all available vertical space not taken up by the bottomBar.
 bottomBar: bottom aligned.

 If no bottomBar is provided, top bar consumes the entire bounds of the stack view.

 When resized, the top bar will shrink until it reaches its sizeThatFits dimensions.
 If there is a bottom bar, then at this point the top bar will begin sliding off the top.
 If there is no bottom bar, then at this point the top bar will stay put.

 At no point in time will either the top or bottom bar shrink below their sizeThatFits height.

 # sizeThatFits Behavior

 sizeThatFits returns the fitted height for bottom bar if available, otherwise it returns the
 fitted height for topBar. The width will be whatever width was provided.
 */
IB_DESIGNABLE
@interface YYUIHeaderStackView : UIView

/** The top bar. Top aligned and vertically expands. */
@property(nonatomic, strong, nullable) UIView *topBar;

/** The bottom bar. Bottom aligned. */
@property(nonatomic, strong, nullable) UIView *bottomBar;

/**
 A block that is invoked when the @c YYUIHeaderStackView receives a call to @c
 traitCollectionDidChange:. The block is called after the call to the superclass.
 */
@property(nonatomic, copy, nullable) void (^traitCollectionDidChangeBlock)
    (YYUIHeaderStackView *_Nonnull headerStackView,
     UITraitCollection *_Nullable previousTraitCollection);

@end
