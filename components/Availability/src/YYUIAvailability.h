//
//  YYUIAvailability.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/16.
//

#ifndef YYUI_AVAILABILITY
#define YYUI_AVAILABILITY

#include <Availability.h>

/*
 A header to be used in conjunction with Availability.h to conditionally
 compile OS sensitive code.
 
 YYUI_AVAILABLE_SDK_IOS(_ios) evaluates to true when the maximum target SDK is
 greater than equal to the given value. This will only prevent code from
 compiling when built with a maximum SDK version lower than the version
 specified. A runtime check may still be necessary. Example:
 
 #if YYUI_AVAILABLE_SDK_IOS(13_0)
 // iOS 13 specific code.
 #endif
 */

#define YYUI_AVAILABLE_SDK_IOS(_ios) \
((__IPHONE_##_ios != 0) &&        \
(__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_##_ios))


#endif // YYUI_AVAILABILITY
