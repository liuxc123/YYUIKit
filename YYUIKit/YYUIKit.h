#if __has_include(<YYUIKit/YYUIKit.h>)

#import <UIKit/UIKit.h>
#import <YYKit/YYKit.h>

#import <YYUIKit/YYUIKitMacro.h>
#import <YYUIKit/YYUITheme.h>
#import <YYUIKit/YYUIShape.h>
#import <YYUIKit/YYUIToast.h>
#import <YYUIKit/YYUIEmpty.h>

#else

#import <UIKit/UIKit.h>
#import <YYKit/YYKit.h>

#import "YYUIKitMacro.h"
#import "YYUITheme.h"
#import "YYUIShape.h"
#import "YYUIToast.h"
#import "YYUIEmpty.h"

#endif
