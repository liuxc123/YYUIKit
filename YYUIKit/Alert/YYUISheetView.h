//
//  YYUISheetView.h
//  YYUIKit
//
//  Created by liuxc on 2021/12/8.
//

#import <UIKit/UIKit.h>
#import "YYUIPopupController.h"
#import "YYUIAlertAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYUISheetView : UIView

+ (instancetype)sheetViewWithTitle:(nullable NSString *)title message:(nullable NSString *)message;
+ (instancetype)sheetViewWithImage:(UIImage *)image title:(nullable NSString *)title message:(nullable NSString *)message;

- (void)addAction:(YYUIAlertAction *)action;
- (void)addCustomView:(UIView *)customView;

- (void)showWithAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)dismissWithAnimated:(BOOL)animated completion:(void (^)(void))completion;

@property (nullable, nonatomic, copy) UIImage *image;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *message;
@property (nonatomic, readonly) NSArray<UIView *> *customViews;
@property (nonatomic, readonly) NSArray<YYUIAlertAction *> *actions;
@property (nonatomic, readonly) YYUIPopupController *popupController;

@end

/**
 *  Global Configuration of YYUISheetView.
 */
@interface YYUISheetViewConfig : NSObject

+ (YYUISheetViewConfig *)globalConfig;

@property (nonatomic, assign) CGFloat buttonsHeight;        // Default is 55.
@property (nonatomic, assign) CGFloat textFieldsHeight;     // Default is 44.
@property (nonatomic, assign) CGFloat innerMargin;          // Default is 25.
@property (nonatomic, assign) CGFloat itemSpacing;          // Default is 20.
@property (nonatomic, assign) CGFloat cancelSpacing;        // Default is 10.

@property (nonatomic, strong) UIColor *backgroundColor;     // Default is #FFFFFF.
@property (nonatomic, strong) UIColor *separatorsColor;     // Default is #CCCCCC.
@property (nonatomic, assign) CGFloat cornerRadius;         // Default is 5.

@property (nonatomic, strong) UIFont  *titleFont;                   // Default is 18.
@property (nonatomic, strong) UIColor *titleTextColor;              // Default is #333333.
@property (nonatomic, assign) NSTextAlignment titleTextAlignment;   // Default is NSTextAlignmentCenter

@property (nonatomic, strong) UIFont  *messageFont;                 // Default is 14.
@property (nonatomic, strong) UIColor *messageTextColor;            // Default is #333333.
@property (nonatomic, assign) NSTextAlignment messageTextAlignment; // Default is NSTextAlignmentCenter

@property (nonatomic, strong) UIColor *textFieldBackgroundColor;    // Default is 14.
@property (nonatomic, strong) UIColor *textFieldsTextColor;         // Default is 14.
@property (nonatomic, strong) UIFont  *textFieldFont;               // Default is 14.

@property (nonatomic, strong) UIFont  *buttonsFont;                     // Default is #333333.
@property (nonatomic, strong) UIColor *buttonsTitleColor;               // Default is #333333.
@property (nonatomic, strong) UIColor *buttonsTitleColorHighlighted;    // Default is #333333.
@property (nonatomic, strong) UIColor *buttonsTitleColorDisabled;       // Default is #333333.
@property (nonatomic, strong) UIColor *buttonsBackgroundColor;          // Default is #EFEDE7.
@property (nonatomic, strong) UIColor *buttonsBackgroundColorHighlighted;// Default is #EFEDE7.
@property (nonatomic, strong) UIColor *buttonsBackgroundColorDisabled;  // Default is #EFEDE7.

@property (nonatomic, strong) UIFont  *cancelButtonFont;                        // Default is #333333.
@property (nonatomic, strong) UIColor *cancelButtonTitleColor;                  // Default is #333333.
@property (nonatomic, strong) UIColor *cancelButtonTitleColorHighlighted;       // Default is #333333.
@property (nonatomic, strong) UIColor *cancelButtonsTitleColorDisabled;         // Default is #333333.
@property (nonatomic, strong) UIColor *cancelButtonBackgroundColor;             // Default is #EFEDE7.
@property (nonatomic, strong) UIColor *cancelButtonBackgroundColorHighlighted;  // Default is #EFEDE7.
@property (nonatomic, strong) UIColor *cancelButtonsBackgroundColorDisabled;    // Default is #EFEDE7.
@property (nonatomic, strong) UIColor *cancelButtonSpacingColor;                // Default is #333333.

@property (nonatomic, strong) UIFont  *destructiveButtonFont;                       // Default is #333333.
@property (nonatomic, strong) UIColor *destructiveButtonTitleColor;                 // Default is #333333.
@property (nonatomic, strong) UIColor *destructiveButtonTitleColorHighlighted;      // Default is #333333.
@property (nonatomic, strong) UIColor *destructiveButtonsTitleColorDisabled;        // Default is #333333.
@property (nonatomic, strong) UIColor *destructiveButtonBackgroundColor;            // Default is #EFEDE7.
@property (nonatomic, strong) UIColor *destructiveButtonBackgroundColorHighlighted; // Default is #EFEDE7.
@property (nonatomic, strong) UIColor *destructiveButtonsBackgroundColorDisabled;   // Default is #EFEDE7.

@end

NS_ASSUME_NONNULL_END
