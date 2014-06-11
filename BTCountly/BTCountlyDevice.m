//
//  BTCountlyDevice.m
//  BTCountly
//
//  Created by Thaddeus Ternes on 6/7/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#include <sys/types.h>
#include <sys/sysctl.h>
#import "BTCountlyDevice.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#else
#error Implement OS X support
#endif

@implementation BTCountlyDevice

- (NSString *)uniqueIdentifier
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

- (NSString *)operationSystemName
{
#if TARGET_OS_IPHONE
    return @"iOS";
#else
    return @"OS X";
#endif
}

- (NSString *)operationSystemVersion
{
#if TARGET_OS_IPHONE
    return [[UIDevice currentDevice] systemVersion];
#else
    NSAssert(NO, @"not implemented");
    return nil;
#endif
}

- (NSString *)deviceProductName;
{
    NSString *result = @"";
#if TARGET_OS_IPHONE
    const char *szName = "hw.machine";
    size_t size;
    sysctlbyname(szName, NULL, &size, NULL, 0);

    if(size < 1024)
    {
        char *szMachineName = malloc(size);
        sysctlbyname(szName, szMachineName, &size, NULL, 0);
        result = [NSString stringWithUTF8String:szMachineName];
        free(szMachineName);
    }
#else
    NSAssert(NO, @"not implemented");
#endif
    
    return result;
}

- (NSString *)mainScreenResolution
{
#if TARGET_OS_IPHONE
    
    // official sdk accounts for screen scale, so multiply bounds by scale for retina
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = [mainScreen scale];
    return [NSString stringWithFormat:@"%ix%i",
            (int)floorf(mainScreen.bounds.size.width * scale),
            (int)floorf(mainScreen.bounds.size.height * scale)];
#else
    NSAssert(NO, @"not implemented");
    return nil;
#endif
}

- (NSString *)cellularCarrier
{
#if TARGET_OS_IPHONE
    CTTelephonyNetworkInfo *netinfo = [[[CTTelephonyNetworkInfo alloc] init] autorelease];
    CTCarrier *carrier = [netinfo subscriberCellularProvider];
    return [carrier carrierName];
#else
    NSAssert(NO, @"not implemented");
    return nil;
#endif
}

- (NSString *)appVersion
{
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if(version.length == 0)
        version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersionString"];
    
    return version;
}

- (NSString *)locale
{
    return [[NSLocale currentLocale] localeIdentifier];
}

@end
