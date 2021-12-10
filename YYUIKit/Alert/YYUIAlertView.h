//
//  YYUIAlertView.h
//  YYUIKit
//
//  Created by liuxc on 2021/12/7.
//

#import <UIKit/UIKit.h>
#import "YYUIPopupController.h"
#import "YYUIAlertAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYUIAlertView : UIView

+ (instancetype)alertViewWithTitle:(nullable NSString *)title message:(nullable NSString *)message;
+ (instancetype)alertViewWithImage:(UIImage *)image title:(nullable NSString *)title message:(nullable NSString *)message;

- (void)addAction:(YYUIAlertAction *)action;
- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;
- (void)addCustomView:(UIView *)customView;

- (void)showWithAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)dismissWithAnimated:(BOOL)animated completion:(void (^)(void))completion;

@property (nullable, nonatomic, copy) UIImage *image;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *message;
@property (nonatomic, readonly) NSArray<UIView *> *customViews;
@property (nonatomic, readonly) NSArray<YYUIAlertAction *> *actions;
@property (nonatomic, readonly) NSArray<UITextField *> *textFields;
@property (nonatomic, readonly) YYUIPopupController *popupController;

@end

/**
 *  Global Configuration of YYUIAlertView.
 */
@interface YYUIAlertViewConfig : NSObject

+ (YYUIAlertViewConfig *)globalConfig;

@property (nonatomic, assign) CGFloat width;                // Default is 275.
@property (nonatomic, assign) CGFloat textFieldHeight;      // Default is 44.
@property (nonatomic, assign) CGFloat buttonHeight;         // Default is 55.
@property (nonatomic, assign) CGFloat innerMargin;          // Default is 25.
@property (nonatomic, assign) CGFloat itemSpacing;          // Default is 20.
@property (nonatomic, assign) CGFloat cornerRadius;         // Default is 5.

@property (nonatomic, strong) UIFont *titleFont;            // Default is 18.
@property (nonatomic, strong) UIFont *messageFont;          // Default is 14.
@property (nonatomic, strong) UIFont *buttonFont;           // Default is 17.

@property (nonatomic, strong) UIColor *backgroundColor;     // Default is #FFFFFF.
@property (nonatomic, strong) UIColor *titleColor;          // Default is #333333.
@property (nonatomic, strong) UIColor *messageColor;        // Default is #333333.
@property (nonatomic, strong) UIColor *separatorsColor;     // Default is #CCCCCC.

@property (nonatomic, strong) UIColor *buttonDefaultColor;    // Default is #333333.
@property (nonatomic, strong) UIColor *buttonCancelColor;     // Default is #E76153.
@property (nonatomic, strong) UIColor *buttonDestructiveColor;// Default is #EFEDE7.
@property (nonatomic, strong) UIColor *buttonHighlightColor;  // Default is #EFEDE7.
@property (nonatomic, strong) UIColor *buttonBackgroundColor; // Default is #EFEDE7.
@property (nonatomic, strong) UIColor *buttonBackgroundHighlightColor;  // Default is #EFEDE7.

@end

NS_ASSUME_NONNULL_END
