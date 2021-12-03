//
//  YYUIAlertController.m
//  YYUIKit
//
//  Created by liuxc on 2021/12/2.
//

#import "YYUIAlertController.h"
#import "YYUIAlertViewWindow.h"
#import "YYUIAlertViewController.h"
#import "YYUIAlertViewCell.h"
#import "YYUIAlertViewTextField.h"
#import "YYUIAlertViewButton.h"
#import "YYUIAlertViewHelper.h"
#import "YYUIAlertViewWindowsObserver.h"
#import "YYUIAlertViewShadowView.h"

#pragma mark - Constants

NSString * _Nonnull const YYUIAlertControllerWillShowNotification = @"YYUIAlertControllerWillShowNotification";
NSString * _Nonnull const YYUIAlertControllerDidShowNotification  = @"YYUIAlertControllerDidShowNotification";

NSString * _Nonnull const YYUIAlertControllerWillDismissNotification = @"YYUIAlertControllerWillDismissNotification";
NSString * _Nonnull const YYUIAlertControllerDidDismissNotification  = @"YYUIAlertControllerDidDismissNotification";

NSString * _Nonnull const YYUIAlertControllerShowAnimationsNotification    = @"YYUIAlertControllerShowAnimationsNotification";
NSString * _Nonnull const YYUIAlertControllerDismissAnimationsNotification = @"YYUIAlertControllerDismissAnimationsNotification";

NSString * _Nonnull const kYYUIAlertControllerAnimationDuration = @"duration";

#pragma mark - Types

typedef enum {
    YYUIAlertControllerTypeDefault           = 0,
    YYUIAlertControllerTypeActivityIndicator = 1,
    YYUIAlertControllerTypeProgressView      = 2,
    YYUIAlertControllerTypeTextFields        = 3
}
YYUIAlertControllerType;

#pragma mark - Interface

@interface YYUIAlertController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (readwrite) BOOL                      showing;
@property (readwrite) YYUIAlertControllerStyle  preferredStyle;
@property (readwrite) NSString                  *title;
@property (readwrite) NSString                  *message;
@property (readwrite) UIView                    *innerView;
@property (readwrite) NSArray                   *actions;
@property (readwrite) NSArray                   *textFields;

@property (assign, nonatomic, getter=isExists) BOOL exists;

@property (strong, nonatomic) YYUIAlertViewWindow *window;

@property (strong, nonatomic) UIView *view;

@property (strong, nonatomic) YYUIAlertViewController *viewController;

@property (strong, nonatomic) UIVisualEffectView *backgroundView;

@property (strong, nonatomic) YYUIAlertViewShadowView *shadowView;
@property (strong, nonatomic) YYUIAlertViewShadowView *shadowCancelView;

@property (strong, nonatomic) UIVisualEffectView *blurView;
@property (strong, nonatomic) UIVisualEffectView *blurCancelView;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITableView  *tableView;

@property (strong, nonatomic) UILabel           *titleLabel;
@property (strong, nonatomic) UILabel           *messageLabel;
@property (strong, nonatomic) UIView            *innerContainerView;

@property (strong, nonatomic) YYUIAlertViewButton *cancelButton;
@property (strong, nonatomic) YYUIAlertViewButton *firstButton;
@property (strong, nonatomic) YYUIAlertViewButton *secondButton;
@property (strong, nonatomic) YYUIAlertViewButton *thirdButton;

@property (strong, nonatomic) UIView *separatorHorizontalView;
@property (strong, nonatomic) UIView *separatorVerticalView1;
@property (strong, nonatomic) UIView *separatorVerticalView2;

@property (assign, nonatomic) CGPoint scrollViewCenterShowed;
@property (assign, nonatomic) CGPoint scrollViewCenterHidden;

@property (assign, nonatomic) CGPoint cancelButtonCenterShowed;
@property (assign, nonatomic) CGPoint cancelButtonCenterHidden;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) UILabel        *progressLabel;

@property (assign, nonatomic) YYUIAlertControllerType type;

@property (assign, nonatomic) CGFloat keyboardHeight;

@property (strong, nonatomic) YYUIAlertViewCell *heightCell;

@property (assign, nonatomic) NSUInteger numberOfTextFields;

@property (assign, nonatomic, getter=isUserCancelOnTouch)                          BOOL userCancelOnTouch;
@property (assign, nonatomic, getter=isUserButtonsHeight)                          BOOL userButtonsHeight;
@property (assign, nonatomic, getter=isUserTitleTextColor)                         BOOL userTitleTextColor;
@property (assign, nonatomic, getter=isUserTitleFont)                              BOOL userTitleFont;
@property (assign, nonatomic, getter=isUserMessageTextColor)                       BOOL userMessageTextColor;
@property (assign, nonatomic, getter=isUserButtonsTitleColor)                      BOOL userButtonsTitleColor;
@property (assign, nonatomic, getter=isUserButtonsBackgroundColorHighlighted)      BOOL userButtonsBackgroundColorHighlighted;
@property (assign, nonatomic, getter=isUserCancelButtonTitleColor)                 BOOL userCancelButtonTitleColor;
@property (assign, nonatomic, getter=isUserCancelButtonBackgroundColorHighlighted) BOOL userCancelButtonBackgroundColorHighlighted;
@property (assign, nonatomic, getter=isUserActivityIndicatorViewColor)             BOOL userActivityIndicatorViewColor;
@property (assign, nonatomic, getter=isUserProgressViewProgressTintColor)          BOOL userProgressViewProgressTintColor;

@property (assign, nonatomic, getter=isInitialized) BOOL initialized;

@end

#pragma mark - Implementation

@implementation YYUIAlertController

#pragma mark -

- (nonnull instancetype)initAsAppearance {
    self = [super init];
    if (self) {
        _heightCell = [[YYUIAlertViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

        // -----

        _windowLevel = YYUIAlertControllerWindowLevelAboveStatusBar;
        _dismissOnAction = YES;

        _tintColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
        _coverColor = [UIColor colorWithWhite:0.0 alpha:0.35];
        _coverBlurEffect = nil;
        _coverAlpha = 1.0;
        _backgroundColor = UIColor.whiteColor;
        _backgroundBlurEffect = nil;
        _textFieldsHeight = 44.0;
        _offsetVertical = 8.0;
        _cancelButtonOffsetY = 8.0;
        _heightMax = NSNotFound;
        _width = NSNotFound;
        _separatorsColor = [UIColor colorWithWhite:0.85 alpha:1.0];
        _indicatorStyle = UIScrollViewIndicatorStyleBlack;
        _showsVerticalScrollIndicator = NO;
        _padShowsActionSheetFromBottom = NO;
        _oneRowOneButton = NO;
        _shouldDismissAnimated = YES;

        _layerCornerRadius = YYUIAlertViewHelper.systemVersion < 9.0 ? 6.0 : 12.0;
        _layerBorderColor = nil;
        _layerBorderWidth = 0.0;
        _layerShadowColor = nil;
        _layerShadowRadius = 0.0;
        _layerShadowOffset = CGPointZero;

        _animationDuration = 0.5;
        _initialScale = 1.2;
        _finalScale = 0.95;

        _titleTextColor = nil;
        _titleTextAlignment = NSTextAlignmentCenter;
        _titleFont = nil;

        _messageTextColor = nil;
        _messageTextAlignment = NSTextAlignmentCenter;
        _messageFont = [UIFont systemFontOfSize:14.0];

//        _buttonsTitleColor = self.tintColor;
//        _buttonsTitleColorHighlighted = UIColor.whiteColor;
//        _buttonsTitleColorDisabled = UIColor.grayColor;
//        _buttonsTextAlignment = NSTextAlignmentCenter;
//        _buttonsFont = [UIFont systemFontOfSize:18.0];
//        _buttonsBackgroundColor = UIColor.clearColor;
//        _buttonsBackgroundColorHighlighted = self.tintColor;
//        _buttonsBackgroundColorDisabled = nil;
//        _buttonsNumberOfLines = 1;
//        _buttonsLineBreakMode = NSLineBreakByTruncatingMiddle;
//        _buttonsMinimumScaleFactor = 14.0 / 18.0;
//        _buttonsAdjustsFontSizeToFitWidth = YES;
//        _buttonsIconPosition = YYUIAlertViewButtonIconPositionLeft;

//        _cancelButtonTitleColor = self.tintColor;
//        _cancelButtonTitleColorHighlighted = UIColor.whiteColor;
//        _cancelButtonTitleColorDisabled = UIColor.grayColor;
//        _cancelButtonTextAlignment = NSTextAlignmentCenter;
//        _cancelButtonFont = [UIFont boldSystemFontOfSize:18.0];
//        _cancelButtonBackgroundColor = UIColor.clearColor;
//        _cancelButtonBackgroundColorHighlighted = self.tintColor;
//        _cancelButtonBackgroundColorDisabled = nil;
//        _cancelButtonNumberOfLines = 1;
//        _cancelButtonLineBreakMode = NSLineBreakByTruncatingMiddle;
//        _cancelButtonMinimumScaleFactor = 14.0 / 18.0;
//        _cancelButtonAdjustsFontSizeToFitWidth = YES;
//        _cancelButtonIconPosition = YYUIAlertViewButtonIconPositionLeft;

//        _destructiveButtonTitleColor = UIColor.redColor;
//        _destructiveButtonTitleColorHighlighted = UIColor.whiteColor;
//        _destructiveButtonTitleColorDisabled = UIColor.grayColor;
//        _destructiveButtonTextAlignment = NSTextAlignmentCenter;
//        _destructiveButtonFont = [UIFont systemFontOfSize:18.0];
//        _destructiveButtonBackgroundColor = UIColor.clearColor;
//        _destructiveButtonBackgroundColorHighlighted = UIColor.redColor;
//        _destructiveButtonBackgroundColorDisabled = nil;
//        _destructiveButtonNumberOfLines = 1;
//        _destructiveButtonLineBreakMode = NSLineBreakByTruncatingMiddle;
//        _destructiveButtonMinimumScaleFactor = 14.0 / 18.0;
//        _destructiveButtonAdjustsFontSizeToFitWidth = YES;
//        _destructiveButtonIconPosition = YYUIAlertViewButtonIconPositionLeft;

        _activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _activityIndicatorViewColor = self.tintColor;

        _progressViewProgressTintColor = self.tintColor;
        _progressViewTrackTintColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        _progressViewProgressImage = nil;
        _progressViewTrackImage = nil;

        _progressLabelTextColor = UIColor.blackColor;
        _progressLabelTextAlignment = NSTextAlignmentCenter;
        _progressLabelFont = [UIFont systemFontOfSize:14.0];
        _progressLabelNumberOfLines = 1;
        _progressLabelLineBreakMode = NSLineBreakByTruncatingTail;

        _textFieldsBackgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
        _textFieldsTextColor = UIColor.blackColor;
        _textFieldsFont = [UIFont systemFontOfSize:16.0];
        _textFieldsTextAlignment = NSTextAlignmentLeft;
        _textFieldsClearsOnBeginEditing = NO;
        _textFieldsAdjustsFontSizeToFitWidth = NO;
        _textFieldsMinimumFontSize = 12.0;
        _textFieldsClearButtonMode = UITextFieldViewModeAlways;
    }
    return self;
}

#pragma mark - Defaults

- (void)setupDefaults {

    YYUIAlertController *appearance = [YYUIAlertController appearance];

    // -----

    _heightCell = appearance.heightCell;

    // -----

    _windowLevel = appearance.windowLevel;
    if (appearance.isUserCancelOnTouch) {
        _cancelOnTouch = appearance.cancelOnTouch;
    }
    else {
        _cancelOnTouch = self.type != YYUIAlertControllerTypeActivityIndicator && self.type != YYUIAlertControllerTypeProgressView && self.type != YYUIAlertControllerTypeTextFields;
    }
    _dismissOnAction = appearance.dismissOnAction;
    _tag = NSNotFound;

    _tintColor = appearance.tintColor;
    _coverColor = appearance.coverColor;
    _coverBlurEffect = appearance.coverBlurEffect;
    _coverAlpha = appearance.coverAlpha;
    _backgroundColor = appearance.backgroundColor;
    _backgroundBlurEffect = appearance.backgroundBlurEffect;
    if (appearance.isUserButtonsHeight) {
        _buttonsHeight = appearance.buttonsHeight;
    }
    else {
        _buttonsHeight = (self.preferredStyle == YYUIAlertControllerStyleAlert || YYUIAlertViewHelper.systemVersion < 9.0) ? 44.0 : 56.0;
    }
    _textFieldsHeight = appearance.textFieldsHeight;
    _offsetVertical = appearance.offsetVertical;
    _cancelButtonOffsetY = appearance.cancelButtonOffsetY;
    _heightMax = appearance.heightMax;
    _width = appearance.width;
    _separatorsColor = appearance.separatorsColor;
    _indicatorStyle = appearance.indicatorStyle;
    _showsVerticalScrollIndicator = appearance.showsVerticalScrollIndicator;
    _padShowsActionSheetFromBottom = appearance.padShowsActionSheetFromBottom;
    _oneRowOneButton = appearance.oneRowOneButton;
    _shouldDismissAnimated = appearance.shouldDismissAnimated;

    _layerCornerRadius = appearance.layerCornerRadius;
    _layerBorderColor = appearance.layerBorderColor;
    _layerBorderWidth = appearance.layerBorderWidth;
    _layerShadowColor = appearance.layerShadowColor;
    _layerShadowRadius = appearance.layerShadowRadius;
    _layerShadowOffset = appearance.layerShadowOffset;

    _animationDuration = appearance.animationDuration;
    _initialScale = appearance.initialScale;
    _finalScale = appearance.finalScale;

    if (appearance.isUserTitleTextColor) {
        _titleTextColor = appearance.titleTextColor;
    }
    else {
        _titleTextColor = self.preferredStyle == YYUIAlertControllerStyleAlert ? UIColor.blackColor : UIColor.grayColor;
    }
    _titleTextAlignment = appearance.titleTextAlignment;
    if (appearance.isUserTitleFont) {
        _titleFont = appearance.titleFont;
    }
    else {
        _titleFont = [UIFont boldSystemFontOfSize:self.preferredStyle == YYUIAlertControllerStyleAlert ? 18.0 : 14.0];
    }

    if (appearance.isUserMessageTextColor) {
        _messageTextColor = appearance.messageTextColor;
    }
    else {
        _messageTextColor = self.preferredStyle == YYUIAlertControllerStyleAlert ? UIColor.blackColor : UIColor.grayColor;
    }
    _messageTextAlignment = appearance.messageTextAlignment;
    _messageFont = appearance.messageFont;

//    _buttonsTitleColor = appearance.buttonsTitleColor;
//    _buttonsTitleColorHighlighted = appearance.buttonsTitleColorHighlighted;
//    _buttonsTitleColorDisabled = appearance.buttonsTitleColorDisabled;
//    _buttonsTextAlignment = appearance.buttonsTextAlignment;
//    _buttonsFont = appearance.buttonsFont;
//    _buttonsBackgroundColor = appearance.buttonsBackgroundColor;
//    _buttonsBackgroundColorHighlighted = appearance.buttonsBackgroundColorHighlighted;
//    _buttonsBackgroundColorDisabled = appearance.buttonsBackgroundColorDisabled;
//    _buttonsNumberOfLines = appearance.buttonsNumberOfLines;
//    _buttonsLineBreakMode = appearance.buttonsLineBreakMode;
//    _buttonsMinimumScaleFactor = appearance.buttonsMinimumScaleFactor;
//    _buttonsAdjustsFontSizeToFitWidth = appearance.buttonsAdjustsFontSizeToFitWidth;
//    _buttonsIconPosition = appearance.buttonsIconPosition;

//    _cancelButtonTitleColor = appearance.cancelButtonTitleColor;
//    _cancelButtonTitleColorHighlighted = appearance.cancelButtonTitleColorHighlighted;
//    _cancelButtonTitleColorDisabled = appearance.cancelButtonTitleColorDisabled;
//    _cancelButtonTextAlignment = appearance.cancelButtonTextAlignment;
//    _cancelButtonFont = appearance.cancelButtonFont;
//    _cancelButtonBackgroundColor = appearance.cancelButtonBackgroundColor;
//    _cancelButtonBackgroundColorHighlighted = appearance.cancelButtonBackgroundColorHighlighted;
//    _cancelButtonBackgroundColorDisabled = appearance.cancelButtonBackgroundColorDisabled;
//    _cancelButtonNumberOfLines = appearance.cancelButtonNumberOfLines;
//    _cancelButtonLineBreakMode = appearance.cancelButtonLineBreakMode;
//    _cancelButtonMinimumScaleFactor = appearance.cancelButtonMinimumScaleFactor;
//    _cancelButtonAdjustsFontSizeToFitWidth = appearance.cancelButtonAdjustsFontSizeToFitWidth;
//    _cancelButtonIconPosition = appearance.cancelButtonIconPosition;

//    _destructiveButtonTitleColor = appearance.destructiveButtonTitleColor;
//    _destructiveButtonTitleColorHighlighted = appearance.destructiveButtonTitleColorHighlighted;
//    _destructiveButtonTitleColorDisabled = appearance.destructiveButtonTitleColorDisabled;
//    _destructiveButtonTextAlignment = appearance.destructiveButtonTextAlignment;
//    _destructiveButtonFont = appearance.destructiveButtonFont;
//    _destructiveButtonBackgroundColor = appearance.destructiveButtonBackgroundColor;
//    _destructiveButtonBackgroundColorHighlighted = appearance.destructiveButtonBackgroundColorHighlighted;
//    _destructiveButtonBackgroundColorDisabled = appearance.destructiveButtonBackgroundColorDisabled;
//    _destructiveButtonNumberOfLines = appearance.destructiveButtonNumberOfLines;
//    _destructiveButtonLineBreakMode = appearance.destructiveButtonLineBreakMode;
//    _destructiveButtonMinimumScaleFactor = appearance.destructiveButtonMinimumScaleFactor;
//    _destructiveButtonAdjustsFontSizeToFitWidth = appearance.destructiveButtonAdjustsFontSizeToFitWidth;
//    _destructiveButtonIconPosition = appearance.destructiveButtonIconPosition;

    _activityIndicatorViewStyle = appearance.activityIndicatorViewStyle;
    _activityIndicatorViewColor = appearance.activityIndicatorViewColor;

    _progressViewProgressTintColor = appearance.progressViewProgressTintColor;
    _progressViewTrackTintColor = appearance.progressViewTrackTintColor;
    _progressViewProgressImage = appearance.progressViewProgressImage;
    _progressViewTrackImage = appearance.progressViewTrackImage;

    _progressLabelTextColor = appearance.progressLabelTextColor;
    _progressLabelTextAlignment = appearance.progressLabelTextAlignment;
    _progressLabelFont = appearance.progressLabelFont;
    _progressLabelNumberOfLines = appearance.progressLabelNumberOfLines;
    _progressLabelLineBreakMode = appearance.progressLabelLineBreakMode;

    _textFieldsBackgroundColor = appearance.textFieldsBackgroundColor;
    _textFieldsTextColor = appearance.textFieldsTextColor;
    _textFieldsFont = appearance.textFieldsFont;
    _textFieldsTextAlignment = appearance.textFieldsTextAlignment;
    _textFieldsClearsOnBeginEditing = appearance.textFieldsClearsOnBeginEditing;
    _textFieldsAdjustsFontSizeToFitWidth = appearance.textFieldsAdjustsFontSizeToFitWidth;
    _textFieldsMinimumFontSize = appearance.textFieldsMinimumFontSize;
    _textFieldsClearButtonMode = appearance.textFieldsClearButtonMode;

    // -----

    self.view = [UIView new];
    self.view.backgroundColor = UIColor.clearColor;
    self.view.userInteractionEnabled = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    self.backgroundView = [[UIVisualEffectView alloc] initWithEffect:self.coverBlurEffect];
    self.backgroundView.alpha = 0.0;
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.backgroundView];

    // -----

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAnimated)];
    tapGesture.delegate = self;
    [self.backgroundView addGestureRecognizer:tapGesture];

    // -----

    self.viewController = [[YYUIAlertViewController alloc] initWithAlertController:self view:self.view];

    self.window = [[YYUIAlertViewWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.hidden = YES;
    self.window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.window.opaque = NO;
    self.window.backgroundColor = UIColor.clearColor;
    self.window.rootViewController = self.viewController;

    // -----

    self.initialized = YES;
}

#pragma mark - Class load

+ (void)load {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        [[YYUIAlertViewWindowsObserver sharedInstance] startObserving];
    });
}

#pragma mark - Dealloc

- (void)dealloc {
    [self removeObservers];

#if DEBUG
    NSLog(@"YYUIAlertController DEALLOCATED");
#endif
}

#pragma mark - UIAppearance

+ (instancetype)appearance {
    return [self sharedAlertControllerForAppearance];
}

+ (instancetype)appearanceWhenContainedIn:(Class<UIAppearanceContainer>)ContainerClass, ... {
    return [self sharedAlertControllerForAppearance];
}

+ (instancetype)appearanceForTraitCollection:(UITraitCollection *)trait {
    return [self sharedAlertControllerForAppearance];
}

+ (instancetype)appearanceForTraitCollection:(UITraitCollection *)trait whenContainedIn:(Class<UIAppearanceContainer>)ContainerClass, ... {
    return [self sharedAlertControllerForAppearance];
}

+ (instancetype)sharedAlertControllerForAppearance {
    static YYUIAlertController *alertController;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        alertController = [[YYUIAlertController alloc] initAsAppearance];
    });

    return alertController;
}

#pragma mark - Observers

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardVisibleChanged:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardVisibleChanged:) name:UIKeyboardWillHideNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowVisibleChanged:) name:UIWindowDidBecomeVisibleNotification object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
}

#pragma mark - Window notifications

- (void)windowVisibleChanged:(NSNotification *)notification {
    if (notification.object == self.window) {
        [self.viewController.view setNeedsLayout];
    }
}

#pragma mark - Keyboard notifications

- (void)keyboardVisibleChanged:(NSNotification *)notification {
    if (!self.isShowing || self.window.isHidden || !self.window.isKeyWindow) return;

    [YYUIAlertViewHelper
     keyboardAnimateWithNotificationUserInfo:notification.userInfo
     animations:^(CGFloat keyboardHeight) {
         if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
             self.keyboardHeight = keyboardHeight;
         }
         else {
             self.keyboardHeight = 0.0;
         }

         [self layoutValidateWithSize:self.view.bounds.size];
     }];
}

- (void)keyboardFrameChanged:(NSNotification *)notification {
    if (!self.isShowing ||
        self.window.isHidden ||
        !self.window.isKeyWindow ||
        [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] != 0.0) {
        return;
    }

    self.keyboardHeight = CGRectGetHeight([notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue]);
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(YYUIAlertViewTextField *)textField {
    if (textField.returnKeyType == UIReturnKeyNext) {
        if (self.textFields.count > textField.tag + 1) {
            UITextField *nextTextField = self.textFields[textField.tag + 1];
            [nextTextField becomeFirstResponder];
        }
    }
    else if (textField.returnKeyType == UIReturnKeyDone) {
        [textField resignFirstResponder];
    }

    return YES;
}

#pragma mark - UIGestureRecognizer Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return self.isCancelOnTouch;
}

#pragma mark - Setters and Getters

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.actions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYUIAlertViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    [self configCell:cell forRowAtIndexPath:indexPath];

    return cell;
}

- (void)configCell:(YYUIAlertViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    YYUIAlertAction *action = self.actions[indexPath.row];
    cell.textLabel.text             = action.title;
    cell.titleColor                 = action.titleColor;
    cell.titleColorHighlighted      = action.titleColorHighlighted;
    cell.titleColorDisabled         = action.titleColorDisabled;
    cell.backgroundColorNormal      = action.backgroundColor;
    cell.backgroundColorHighlighted = action.backgroundColorHighlighted;
    cell.backgroundColorDisabled    = action.backgroundColorDisabled;
    cell.image                      = action.iconImage;
    cell.imageHighlighted           = action.iconImageHighlighted;
    cell.imageDisabled              = action.iconImageDisabled;
    cell.iconPosition               = action.iconPosition;
    cell.enabled                    = action.enabled;

    cell.separatorView.hidden                = (indexPath.row == self.actions.count - 1);
    cell.separatorView.backgroundColor       = self.separatorsColor;
    cell.textLabel.textAlignment             = action.textAlignment;
    cell.textLabel.font                      = action.font;
    cell.textLabel.numberOfLines             = action.numberOfLines;
    cell.textLabel.lineBreakMode             = action.lineBreakMode;
    cell.textLabel.adjustsFontSizeToFitWidth = action.adjustsFontSizeToFitWidth;
    cell.textLabel.minimumScaleFactor        = action.minimumScaleFactor;

    if (action.style == YYUIAlertActionStyleCancel && ![YYUIAlertViewHelper isCancelButtonSeparateForAlertController:self] && indexPath.row == self.actions.count - 1) {
        cell.separatorView.hidden = YES;
    }
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self configCell:self.heightCell forRowAtIndexPath:indexPath];

    CGSize size = [self.heightCell sizeThatFits:CGSizeMake(CGRectGetWidth(tableView.bounds), CGFLOAT_MAX)];

    if (size.height < self.buttonsHeight) {
        size.height = self.buttonsHeight;
    }

    return size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self actionAlertAction:self.actions[indexPath.row]];
}

#pragma mark - Show

- (void)showAnimated:(BOOL)animated completionHandler:(YYUIAlertControllerCompletionHandler)completionHandler {
    [self showAnimated:animated hidden:NO completionHandler:completionHandler];
}

- (void)showAnimated {
    [self showAnimated:YES completionHandler:nil];
}

- (void)show {
    [self showAnimated:NO completionHandler:nil];
}

- (void)showAnimated:(BOOL)animated hidden:(BOOL)hidden completionHandler:(YYUIAlertControllerCompletionHandler)completionHandler {
    if (!self.isValid || self.isShowing) return;

    self.window.windowLevel = UIWindowLevelStatusBar + (self.windowLevel == YYUIAlertControllerWindowLevelAboveStatusBar ? 1 : -1);
    self.view.userInteractionEnabled = NO;

    [self subviewsValidateWithSize:CGSizeZero];
    [self layoutValidateWithSize:CGSizeZero];

    self.showing = YES;

    // -----

    UIWindow *keyWindow = YYUIAlertViewHelper.keyWindow;

    [keyWindow endEditing:YES];

    if (!hidden && keyWindow != YYUIAlertViewHelper.appWindow) {
        keyWindow.hidden = YES;
    }

    [self.window makeKeyAndVisible];

    // -----

    [self addObservers];

    // -----

    [self willShowCallback];

    // -----

    if (hidden) {
        self.scrollView.hidden = YES;
        self.backgroundView.hidden = YES;
        self.shadowView.hidden = YES;
        self.blurView.hidden = YES;

        if ([YYUIAlertViewHelper isCancelButtonSeparateForAlertController:self]) {
            self.cancelButton.hidden = YES;
            self.shadowCancelView.hidden = YES;
            self.blurCancelView.hidden = YES;
        }
    }

    // -----

    if (animated) {
        [YYUIAlertViewHelper
         animateWithDuration:self.animationDuration
         animations:^(void) {
             [self showAnimations];

             // -----

             [[NSNotificationCenter defaultCenter] postNotificationName:YYUIAlertControllerShowAnimationsNotification
                                                                 object:self
                                                               userInfo:@{kYYUIAlertControllerAnimationDuration: @(self.animationDuration)}];

             if (self.showAnimationsBlock) {
                 self.showAnimationsBlock(self, self.animationDuration);
             }

             if (self.delegate && [self.delegate respondsToSelector:@selector(showAnimationsForAlertController:duration:)]) {
                 [self.delegate showAnimationsForAlertController:self duration:self.animationDuration];
             }
         }
         completion:^(BOOL finished) {
             if (!hidden) {
                 [self showComplete];
             }

             if (completionHandler) {
                 completionHandler();
             }
         }];
    }
    else {
        [self showAnimations];

        if (!hidden) {
            [self showComplete];
        }

        if (completionHandler) {
            completionHandler();
        }
    }
}

- (void)showAnimations {
    self.backgroundView.alpha = self.coverAlpha;

    if (self.preferredStyle == YYUIAlertControllerStyleAlert || [YYUIAlertViewHelper isPadAndNotForceForAlertController:self]) {
        self.scrollView.transform = CGAffineTransformIdentity;
        self.scrollView.alpha = 1.0;

        self.shadowView.transform = CGAffineTransformIdentity;
        self.shadowView.alpha = 1.0;

        self.blurView.transform = CGAffineTransformIdentity;
        self.blurView.alpha = 1.0;
    }
    else {
        self.scrollView.center = self.scrollViewCenterShowed;

        self.shadowView.center = self.scrollViewCenterShowed;

        self.blurView.center = self.scrollViewCenterShowed;
    }

    if ([YYUIAlertViewHelper isCancelButtonSeparateForAlertController:self] && self.cancelButton) {
        self.cancelButton.center = self.cancelButtonCenterShowed;

        self.shadowCancelView.center = self.cancelButtonCenterShowed;

        self.blurCancelView.center = self.cancelButtonCenterShowed;
    }
}

- (void)showComplete {
    if (self.type == YYUIAlertControllerTypeTextFields && self.textFields.count) {
        [self.textFields[0] becomeFirstResponder];
    }

    // -----

    [self didShowCallback];

    // -----

    self.view.userInteractionEnabled = YES;
}

#pragma mark - Dismiss

- (void)dismissAnimated:(BOOL)animated completionHandler:(YYUIAlertControllerCompletionHandler)completionHandler {
    if (!self.isShowing) return;

    if (self.window.isHidden) {
        [self dismissComplete];
        return;
    }

    self.view.userInteractionEnabled = NO;

    self.showing = NO;

    [self.view endEditing:YES];

    // -----

    [self willDismissCallback];

    // -----

    if (animated) {
        [YYUIAlertViewHelper
         animateWithDuration:self.animationDuration
         animations:^(void) {
             [self dismissAnimations];

             // -----

             [[NSNotificationCenter defaultCenter] postNotificationName:YYUIAlertControllerDismissAnimationsNotification
                                                                 object:self
                                                               userInfo:@{kYYUIAlertControllerAnimationDuration: @(self.animationDuration)}];

             if (self.dismissAnimationsBlock) {
                 self.dismissAnimationsBlock(self, self.animationDuration);
             }

             if (self.delegate && [self.delegate respondsToSelector:@selector(dismissAnimationsForAlertController:duration:)]) {
                 [self.delegate dismissAnimationsForAlertController:self duration:self.animationDuration];
             }
         }
         completion:^(BOOL finished) {
             [self dismissComplete];

             if (completionHandler) {
                 completionHandler();
             }
         }];
    }
    else {
        [self dismissAnimations];

        [self dismissComplete];

        if (completionHandler) {
            completionHandler();
        }
    }
}

- (void)dismissAnimated {
    [self dismissAnimated:YES completionHandler:nil];
}

- (void)dismiss {
    [self dismissAnimated:NO completionHandler:nil];
}

- (void)dismissAnimations {
    self.backgroundView.alpha = 0.0;

    if (self.preferredStyle == YYUIAlertControllerStyleAlert || [YYUIAlertViewHelper isPadAndNotForceForAlertController:self]) {
        CGAffineTransform transform = CGAffineTransformMakeScale(self.finalScale, self.finalScale);
        CGFloat alpha = 0.0;

        self.scrollView.transform = transform;
        self.scrollView.alpha = alpha;

        self.shadowView.transform = transform;
        self.shadowView.alpha = alpha;

        self.blurView.transform = transform;
        self.blurView.alpha = alpha;
    }
    else {
        self.scrollView.center = self.scrollViewCenterHidden;

        self.shadowView.center = self.scrollViewCenterHidden;

        self.blurView.center = self.scrollViewCenterHidden;
    }

    if ([YYUIAlertViewHelper isCancelButtonSeparateForAlertController:self] && self.cancelButton) {
        self.cancelButton.center = self.cancelButtonCenterHidden;

        self.shadowCancelView.center = self.cancelButtonCenterHidden;

        self.blurCancelView.center = self.cancelButtonCenterHidden;
    }
}

- (void)dismissComplete {
    [self removeObservers];

    self.window.hidden = YES;

    // -----

    [self didDismissCallback];

    // -----

    self.view = nil;
    self.viewController = nil;
    self.window = nil;
    self.delegate = nil;
}

#pragma mark - Transition

- (void)transitionToAlertController:(nonnull YYUIAlertController *)alertController completionHandler:(YYUIAlertControllerCompletionHandler)completionHandler {
    if (![self isAlertControllerValid:alertController] || !self.isShowing) return;

    self.view.userInteractionEnabled = NO;

    [alertController showAnimated:NO
                           hidden:YES
                completionHandler:^(void) {
              NSTimeInterval duration = 0.3;

        BOOL cancelButtonSelf = [YYUIAlertViewHelper isCancelButtonSeparateForAlertController:self] && self.cancelButton;
              BOOL cancelButtonNext = [YYUIAlertViewHelper isCancelButtonSeparateForAlertController:alertController] && [alertController hasCancelAction];

              // -----

              [UIView animateWithDuration:duration
                               animations:^(void) {
                                   self.scrollView.alpha = 0.0;

                                   if (cancelButtonSelf) {
                                       self.cancelButton.alpha = 0.0;

                                       if (!cancelButtonNext) {
                                           self.shadowCancelView.alpha = 0.0;
                                           self.blurCancelView.alpha = 0.0;
                                       }
                                   }
                               }
                               completion:^(BOOL finished) {
                                    alertController.backgroundView.alpha = 0.0;
                                    alertController.backgroundView.hidden = NO;

                                   [UIView animateWithDuration:duration * 2.0
                                                    animations:^(void) {
                                                        self.backgroundView.alpha = 0.0;
                                                        alertController.backgroundView.alpha = alertController.coverAlpha;
                                                    }];

                                   // -----

                                   CGRect shadowViewFrame = alertController.shadowView.frame;

                                   alertController.shadowView.frame = self.shadowView.frame;

                                   alertController.shadowView.hidden = NO;
                                   self.shadowView.hidden = YES;

                                   // -----

                                   CGRect blurViewFrame = alertController.blurView.frame;

                                   alertController.blurView.frame = self.blurView.frame;

                                   alertController.blurView.hidden = NO;
                                   self.blurView.hidden = YES;

                                   // -----

                                   if (cancelButtonNext) {
                                       alertController.shadowCancelView.hidden = NO;
                                       alertController.blurCancelView.hidden = NO;

                                       if (!cancelButtonSelf) {
                                           alertController.shadowCancelView.alpha = 0.0;
                                           alertController.blurCancelView.alpha = 0.0;
                                       }
                                   }

                                   // -----

                                   if (cancelButtonSelf && cancelButtonNext) {
                                       self.shadowCancelView.hidden = YES;
                                       self.blurCancelView.hidden = YES;
                                   }

                                   // -----

                                   [UIView animateWithDuration:duration
                                                    animations:^(void) {
                                                        alertController.shadowView.frame = shadowViewFrame;
                                                        alertController.blurView.frame = blurViewFrame;
                                                    }
                                                    completion:^(BOOL finished) {
                                                        alertController.scrollView.alpha = 0.0;
                                                        alertController.scrollView.hidden = NO;

                                                        if (cancelButtonNext) {
                                                            alertController.cancelButton.alpha = 0.0;
                                                            alertController.cancelButton.hidden = NO;
                                                        }

                                                        [UIView animateWithDuration:duration
                                                                         animations:^(void) {
                                                                             self.scrollView.alpha = 0.0;
                                                                                alertController.scrollView.alpha = 1.0;

                                                                             if (cancelButtonNext) {
                                                                                 alertController.cancelButton.alpha = 1.0;

                                                                                 if (!cancelButtonSelf) {
                                                                                     alertController.shadowCancelView.alpha = 1.0;
                                                                                     alertController.blurCancelView.alpha = 1.0;
                                                                                 }
                                                                             }
                                                                         }
                                                                         completion:^(BOOL finished) {
                                                                             [self dismissAnimated:NO
                                                                                 completionHandler:^(void) {
                                                                                     [alertController showComplete];

                                                                                     if (completionHandler) {
                                                                                         completionHandler();
                                                                                     }
                                                                                 }];
                                                                         }];
                                                    }];
                               }];
          }];
}

- (void)transitionToAlertController:(YYUIAlertController *)alertController {
    [self transitionToAlertController:alertController completionHandler:nil];
}

#pragma mark -

- (void)subviewsValidateWithSize:(CGSize)size {
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = self.viewController.view.bounds.size;
    }
    
    
    // -----

    CGFloat width = self.width;
    
    
    // -----

    if (!self.isExists) {
        self.exists = YES;
     
        self.backgroundView.backgroundColor = self.coverColor;
        self.backgroundView.effect = self.coverBlurEffect;

        self.shadowView = [YYUIAlertViewShadowView new];
        self.shadowView.clipsToBounds = YES;
        self.shadowView.userInteractionEnabled = NO;
        self.shadowView.cornerRadius = self.layerCornerRadius;
        self.shadowView.strokeColor = self.layerBorderColor;
        self.shadowView.strokeWidth = self.layerBorderWidth;
        self.shadowView.shadowColor = self.layerShadowColor;
        self.shadowView.shadowBlur = self.layerShadowRadius;
        self.shadowView.shadowOffset = self.layerShadowOffset;
        [self.view addSubview:self.shadowView];

        self.blurView = [[UIVisualEffectView alloc] initWithEffect:self.backgroundBlurEffect];
        self.blurView.contentView.backgroundColor = self.backgroundColor;
        self.blurView.clipsToBounds = YES;
        self.blurView.layer.cornerRadius = self.layerCornerRadius;
        self.blurView.layer.borderWidth = self.layerBorderWidth;
        self.blurView.layer.borderColor = self.layerBorderColor.CGColor;
        self.blurView.userInteractionEnabled = NO;
        [self.view addSubview:self.blurView];

        self.scrollView = [UIScrollView new];
        self.scrollView.backgroundColor = UIColor.clearColor;
        self.scrollView.indicatorStyle = self.indicatorStyle;
        self.scrollView.showsVerticalScrollIndicator = self.showsVerticalScrollIndicator;
        self.scrollView.alwaysBounceVertical = NO;
        self.scrollView.clipsToBounds = YES;
        self.scrollView.layer.cornerRadius = self.layerCornerRadius - self.layerBorderWidth - (self.layerBorderWidth ? 1.0 : 0.0);
        [self.view addSubview:self.scrollView];

        CGFloat offsetY = 0.0;

        if (self.title) {
            self.titleLabel = [UILabel new];
            self.titleLabel.text = self.title;
            self.titleLabel.textColor = self.titleTextColor;
            self.titleLabel.textAlignment = self.titleTextAlignment;
            self.titleLabel.numberOfLines = 0;
            self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.titleLabel.backgroundColor = UIColor.clearColor;
            self.titleLabel.font = self.titleFont;

            CGSize titleLabelSize = [self.titleLabel sizeThatFits:CGSizeMake(width - YYUIAlertViewPaddingWidth * 2.0, CGFLOAT_MAX)];
            CGRect titleLabelFrame = CGRectMake(YYUIAlertViewPaddingWidth, self.innerMarginHeight, width - YYUIAlertViewPaddingWidth * 2.0, titleLabelSize.height);

            if (YYUIAlertViewHelper.isNotRetina) {
                titleLabelFrame = CGRectIntegral(titleLabelFrame);
            }

            self.titleLabel.frame = titleLabelFrame;
            [self.scrollView addSubview:self.titleLabel];

            offsetY = CGRectGetMinY(self.titleLabel.frame) + CGRectGetHeight(self.titleLabel.frame);
        }

        if (self.message) {
            self.messageLabel = [UILabel new];
            self.messageLabel.text = self.message;
            self.messageLabel.textColor = self.messageTextColor;
            self.messageLabel.textAlignment = self.messageTextAlignment;
            self.messageLabel.numberOfLines = 0;
            self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.messageLabel.backgroundColor = UIColor.clearColor;
            self.messageLabel.font = self.messageFont;

            if (!offsetY) {
                offsetY = self.innerMarginHeight / 2.0;
            }
            else if (self.preferredStyle == YYUIAlertControllerStyleActionSheet) {
                offsetY -= self.innerMarginHeight / 3.0;
            }

            CGSize messageLabelSize = [self.messageLabel sizeThatFits:CGSizeMake(width - YYUIAlertViewPaddingWidth * 2.0, CGFLOAT_MAX)];
            CGRect messageLabelFrame = CGRectMake(YYUIAlertViewPaddingWidth, offsetY + self.innerMarginHeight / 2.0, width-YYUIAlertViewPaddingWidth * 2.0, messageLabelSize.height);

            if (YYUIAlertViewHelper.isNotRetina) {
                messageLabelFrame = CGRectIntegral(messageLabelFrame);
            }

            self.messageLabel.frame = messageLabelFrame;
            [self.scrollView addSubview:self.messageLabel];

            offsetY = CGRectGetMinY(self.messageLabel.frame) + CGRectGetHeight(self.messageLabel.frame);
        }

        if (self.innerView) {
            self.innerContainerView = [UIView new];
            self.innerContainerView.backgroundColor = UIColor.clearColor;

            CGRect innerContainerViewFrame = CGRectMake(0.0, offsetY + self.innerMarginHeight, width, CGRectGetHeight(self.innerView.bounds));

            if (YYUIAlertViewHelper.isNotRetina) {
                innerContainerViewFrame = CGRectIntegral(innerContainerViewFrame);
            }

            self.innerContainerView.frame = innerContainerViewFrame;
            [self.scrollView addSubview:self.innerContainerView];

            CGRect innerViewFrame = CGRectMake((width / 2.0) - (CGRectGetWidth(self.innerView.bounds) / 2.0),
                                               0.0,
                                               CGRectGetWidth(self.innerView.bounds),
                                               CGRectGetHeight(self.innerView.bounds));

            if (YYUIAlertViewHelper.isNotRetina) {
                innerViewFrame = CGRectIntegral(innerViewFrame);
            }

            self.innerView.frame = innerViewFrame;
            [self.innerContainerView addSubview:self.innerView];

            offsetY = CGRectGetMinY(self.innerContainerView.frame) + CGRectGetHeight(self.innerContainerView.frame);
        }
        else if (self.type == YYUIAlertControllerTypeActivityIndicator || self.type == YYUIAlertControllerTypeProgressView) {
            if (self.type == YYUIAlertControllerTypeActivityIndicator) {
                self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
                self.activityIndicator.color = self.activityIndicatorViewColor;
                self.activityIndicator.backgroundColor = UIColor.clearColor;
                [self.activityIndicator startAnimating];

                CGRect activityIndicatorFrame = CGRectMake(width / 2.0 - CGRectGetWidth(self.activityIndicator.bounds) / 2.0,
                                                           offsetY + self.innerMarginHeight,
                                                           CGRectGetWidth(self.activityIndicator.bounds),
                                                           CGRectGetHeight(self.activityIndicator.bounds));

                if (YYUIAlertViewHelper.isNotRetina) {
                    activityIndicatorFrame = CGRectIntegral(activityIndicatorFrame);
                }

                self.activityIndicator.frame = activityIndicatorFrame;
                [self.scrollView addSubview:self.activityIndicator];

                offsetY = CGRectGetMinY(self.activityIndicator.frame) + CGRectGetHeight(self.activityIndicator.frame);
            }
            else if (self.type == YYUIAlertControllerTypeProgressView) {
                self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
                self.progressView.progress = self.progress;
                self.progressView.backgroundColor = UIColor.clearColor;
                self.progressView.progressTintColor = self.progressViewProgressTintColor;
                self.progressView.trackTintColor = self.progressViewTrackTintColor;

                if (self.progressViewProgressImage) {
                    self.progressView.progressImage = self.progressViewProgressImage;
                }

                if (self.progressViewTrackImage) {
                    self.progressView.trackImage = self.progressViewTrackImage;
                }

                CGRect progressViewFrame = CGRectMake(YYUIAlertViewPaddingWidth,
                                                      offsetY + self.innerMarginHeight,
                                                      width - (YYUIAlertViewPaddingWidth * 2.0),
                                                      CGRectGetHeight(self.progressView.bounds));

                if (YYUIAlertViewHelper.isNotRetina) {
                    progressViewFrame = CGRectIntegral(progressViewFrame);
                }

                self.progressView.frame = progressViewFrame;
                [self.scrollView addSubview:self.progressView];

                offsetY = CGRectGetMinY(self.progressView.frame) + CGRectGetHeight(self.progressView.frame);
            }

            if (self.progressLabelText) {
                self.progressLabel = [UILabel new];
                self.progressLabel.text = self.progressLabelText;
                self.progressLabel.textColor = self.progressLabelTextColor;
                self.progressLabel.textAlignment = self.progressLabelTextAlignment;
                self.progressLabel.numberOfLines = self.progressLabelNumberOfLines;
                self.progressLabel.backgroundColor = UIColor.clearColor;
                self.progressLabel.font = self.progressLabelFont;
                self.progressLabel.lineBreakMode = self.progressLabelLineBreakMode;

                CGRect progressLabelFrame = CGRectMake(YYUIAlertViewPaddingWidth,
                                                       offsetY + (self.innerMarginHeight / 2.0),
                                                       width - (YYUIAlertViewPaddingWidth * 2.0),
                                                       self.progressLabelNumberOfLines * self.progressLabelFont.lineHeight);

                if (YYUIAlertViewHelper.isNotRetina) {
                    progressLabelFrame = CGRectIntegral(progressLabelFrame);
                }

                self.progressLabel.frame = progressLabelFrame;
                [self.scrollView addSubview:self.progressLabel];

                offsetY = CGRectGetMinY(self.progressLabel.frame) + CGRectGetHeight(self.progressLabel.frame);
            }
        }
        
    }
}

- (void)layoutValidateWithSize:(CGSize)size {
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = self.viewController.view.bounds.size;
    }
    
    // -----

    CGFloat width = self.width;
    
    // -----

    self.view.frame = CGRectMake(0.0, 0.0, size.width, size.height);
    self.backgroundView.frame = CGRectMake(0.0, 0.0, size.width, size.height);
    
    // -----

    CGFloat heightMax = size.height - self.keyboardHeight - (self.offsetVertical * 2.0);
    
    if (self.windowLevel == YYUIAlertControllerWindowLevelBelowStatusBar) {
        heightMax -= YYUIAlertViewHelper.statusBarHeight;
    }
    
    if (self.heightMax != NSNotFound && self.heightMax < heightMax) {
        heightMax = self.heightMax;
    }

    if ([YYUIAlertViewHelper isCancelButtonSeparateForAlertController:self] && self.cancelButton) {
        heightMax -= self.buttonsHeight + self.cancelButtonOffsetY;
    }
    else if (self.cancelOnTouch && ![self hasCancelAction] && size.width < width + (self.buttonsHeight * 2.0)) {
        heightMax -= self.buttonsHeight * 2.0;
    }

    if (self.scrollView.contentSize.height < heightMax) {
        heightMax = self.scrollView.contentSize.height;
    }

    // -----

    CGRect scrollViewFrame = CGRectZero;
    CGAffineTransform scrollViewTransform = CGAffineTransformIdentity;
    CGFloat scrollViewAlpha = 1.0;

    if (self.preferredStyle == YYUIAlertControllerStyleAlert || [YYUIAlertViewHelper isPadAndNotForceForAlertController:self]) {
        scrollViewFrame = CGRectMake((size.width - width) / 2.0, (size.height - self.keyboardHeight - heightMax) / 2.0, width, heightMax);

        if (self.windowLevel == YYUIAlertControllerWindowLevelBelowStatusBar) {
            scrollViewFrame.origin.y += YYUIAlertViewHelper.statusBarHeight / 2.0;
        }

        if (!self.isShowing) {
            scrollViewTransform = CGAffineTransformMakeScale(self.initialScale, self.initialScale);

            scrollViewAlpha = 0.0;
        }
    }
    else
    {
        CGFloat bottomShift = self.offsetVertical;

        if ([YYUIAlertViewHelper isCancelButtonSeparateForAlertController:self] && self.cancelButton) {
            bottomShift += self.buttonsHeight+self.cancelButtonOffsetY;
        }

        scrollViewFrame = CGRectMake((size.width - width) / 2.0, size.height - bottomShift - heightMax, width, heightMax);
    }

    // -----

    if (self.preferredStyle == YYUIAlertControllerStyleActionSheet && ![YYUIAlertViewHelper isPadAndNotForceForAlertController:self]) {
        CGRect cancelButtonFrame = CGRectZero;

        if ([YYUIAlertViewHelper isCancelButtonSeparateForAlertController:self] && self.cancelButton) {
            cancelButtonFrame = CGRectMake((size.width - width) / 2.0, size.height - self.cancelButtonOffsetY - self.buttonsHeight, width, self.buttonsHeight);
        }

        self.scrollViewCenterShowed = CGPointMake(CGRectGetMinX(scrollViewFrame) + (CGRectGetWidth(scrollViewFrame) / 2.0),
                                                  CGRectGetMinY(scrollViewFrame) + (CGRectGetHeight(scrollViewFrame) / 2.0));

        self.cancelButtonCenterShowed = CGPointMake(CGRectGetMinX(cancelButtonFrame) + (CGRectGetWidth(cancelButtonFrame) / 2.0),
                                                    CGRectGetMinY(cancelButtonFrame) + (CGRectGetHeight(cancelButtonFrame) / 2.0));

        // -----

        CGFloat commonHeight = CGRectGetHeight(scrollViewFrame) + self.offsetVertical;

        if ([YYUIAlertViewHelper isCancelButtonSeparateForAlertController:self] && self.cancelButton) {
            commonHeight += self.buttonsHeight + self.cancelButtonOffsetY;
        }

        self.scrollViewCenterHidden = CGPointMake(CGRectGetMinX(scrollViewFrame) + (CGRectGetWidth(scrollViewFrame) / 2.0),
                                                  CGRectGetMinY(scrollViewFrame) + (CGRectGetHeight(scrollViewFrame) / 2.0) + commonHeight + self.layerBorderWidth + self.layerShadowRadius);

        self.cancelButtonCenterHidden = CGPointMake(CGRectGetMinX(cancelButtonFrame) + (CGRectGetWidth(cancelButtonFrame) / 2.0),
                                                    CGRectGetMinY(cancelButtonFrame) + (CGRectGetHeight(cancelButtonFrame) / 2.0) + commonHeight);

        if (!self.isShowing) {
            scrollViewFrame.origin.y += commonHeight;

            if ([YYUIAlertViewHelper isCancelButtonSeparateForAlertController:self] && self.cancelButton) {
                cancelButtonFrame.origin.y += commonHeight;
            }
        }

        // -----

        if ([YYUIAlertViewHelper isCancelButtonSeparateForAlertController:self] && self.cancelButton) {
            if (YYUIAlertViewHelper.isNotRetina) {
                cancelButtonFrame = CGRectIntegral(cancelButtonFrame);
            }

            self.cancelButton.frame = cancelButtonFrame;

            CGFloat offset = self.layerBorderWidth + self.layerShadowRadius;
            self.shadowCancelView.frame = CGRectInset(cancelButtonFrame, -offset, -offset);
            [self.shadowCancelView setNeedsDisplay];

            self.blurCancelView.frame = CGRectInset(cancelButtonFrame, -self.layerBorderWidth, -self.layerBorderWidth);
        }
    }

    // -----

    if (YYUIAlertViewHelper.isNotRetina) {
        scrollViewFrame = CGRectIntegral(scrollViewFrame);

        if (CGRectGetHeight(scrollViewFrame) - self.scrollView.contentSize.height == 1.0) {
            scrollViewFrame.size.height -= 2.0;
        }
    }

    // -----

    self.scrollView.frame = scrollViewFrame;
    self.scrollView.transform = scrollViewTransform;
    self.scrollView.alpha = scrollViewAlpha;

    // -----

    CGFloat offset = self.layerBorderWidth + self.layerShadowRadius;
    self.shadowView.frame = CGRectInset(scrollViewFrame, -offset, -offset);
    self.shadowView.transform = scrollViewTransform;
    self.shadowView.alpha = scrollViewAlpha;
    [self.shadowView setNeedsDisplay];

    // -----

    self.blurView.frame = CGRectInset(scrollViewFrame, -self.layerBorderWidth, -self.layerBorderWidth);
    self.blurView.transform = scrollViewTransform;
    self.blurView.alpha = scrollViewAlpha;
}

- (void)cancelButtonInit {
    self.cancelButton = [YYUIAlertViewButton new];
//    self.cancelButton.titleLabel.numberOfLines = self.cancelButtonNumberOfLines;
//    self.cancelButton.titleLabel.lineBreakMode = self.cancelButtonLineBreakMode;
//    self.cancelButton.titleLabel.adjustsFontSizeToFitWidth = self.cancelButtonAdjustsFontSizeToFitWidth;
//    self.cancelButton.titleLabel.minimumScaleFactor = self.cancelButtonMinimumScaleFactor;
//    self.cancelButton.titleLabel.font = self.cancelButtonFont;
//    self.cancelButton.titleLabel.textAlignment = self.cancelButtonTextAlignment;
//    self.cancelButton.iconPosition = self.cancelButtonIconPosition;
//    [self.cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
//
//    [self.cancelButton setTitleColor:self.cancelButtonTitleColor forState:UIControlStateNormal];
//    [self.cancelButton setTitleColor:self.cancelButtonTitleColorHighlighted forState:UIControlStateHighlighted];
//    [self.cancelButton setTitleColor:self.cancelButtonTitleColorHighlighted forState:UIControlStateSelected];
//    [self.cancelButton setTitleColor:self.cancelButtonTitleColorDisabled forState:UIControlStateDisabled];
//
//    [self.cancelButton setBackgroundColor:self.cancelButtonBackgroundColor forState:UIControlStateNormal];
//    [self.cancelButton setBackgroundColor:self.cancelButtonBackgroundColorHighlighted forState:UIControlStateHighlighted];
//    [self.cancelButton setBackgroundColor:self.cancelButtonBackgroundColorHighlighted forState:UIControlStateSelected];
//    [self.cancelButton setBackgroundColor:self.cancelButtonBackgroundColorDisabled forState:UIControlStateDisabled];
//
//    [self.cancelButton setImage:self.cancelButtonIconImage forState:UIControlStateNormal];
//    [self.cancelButton setImage:self.cancelButtonIconImageHighlighted forState:UIControlStateHighlighted];
//    [self.cancelButton setImage:self.cancelButtonIconImageHighlighted forState:UIControlStateSelected];
//    [self.cancelButton setImage:self.cancelButtonIconImageDisabled forState:UIControlStateDisabled];

//    if (self.cancelButtonTextAlignment == NSTextAlignmentLeft) {
//        self.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    }
//    else if (self.cancelButtonTextAlignment == NSTextAlignmentRight) {
//        self.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    }
//
//    if (self.cancelButton.imageView.image && self.cancelButton.titleLabel.text.length) {
//        self.cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0.0,
//                                                             YYUIAlertViewButtonImageOffsetFromTitle / 2.0,
//                                                             0.0,
//                                                             YYUIAlertViewButtonImageOffsetFromTitle / 2.0);
//    }
//
//    self.cancelButton.enabled = self.cancelButtonEnabled;
    [self.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Actions

- (void)actionAlertAction:(YYUIAlertAction *)action {
    if (action.handler) {
        action.handler(action);
    }
}

#pragma mark - Callbacks

- (void)willShowCallback {
    if (self.willShowHandler) {
        self.willShowHandler(self);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(alertControllerWillShow:)]) {
        [self.delegate alertControllerWillShow:self];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:YYUIAlertControllerWillShowNotification object:self userInfo:nil];
}

- (void)didShowCallback {
    if (self.didShowHandler) {
        self.didShowHandler(self);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(alertControllerDidShow:)]) {
        [self.delegate alertControllerDidShow:self];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:YYUIAlertControllerDidShowNotification object:self userInfo:nil];
}

- (void)willDismissCallback {
    if (self.willDismissHandler) {
        self.willDismissHandler(self);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(alertControllerWillDismiss:)]) {
        [self.delegate alertControllerWillDismiss:self];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:YYUIAlertControllerWillDismissNotification object:self userInfo:nil];
}

- (void)didDismissCallback {
    if (self.didDismissHandler) {
        self.didDismissHandler(self);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(alertControllerDidDismiss:)]) {
        [self.delegate alertControllerDidDismiss:self];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:YYUIAlertControllerDidDismissNotification object:self userInfo:nil];
}

#pragma mark - Helpers

- (BOOL)hasCancelAction {
    for (YYUIAlertAction *action in self.actions) {
        if (action.style == YYUIAlertActionStyleCancel) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isAlertControllerValid:(YYUIAlertController *)alertController {
    NSAssert(alertController.isInitialized, @"You need to use one of \"- initWith...\" or \"+ alertViewWith...\" methods to initialize YYUIAlertController");

    return YES;
}

- (BOOL)isValid {
    return [self isAlertControllerValid:self];
}

- (CGFloat)innerMarginHeight {
    return self.preferredStyle == YYUIAlertControllerStyleAlert ? 16.0 : 12.0;
}

@end
