//
//  BTCountlyDevice.h
//  BTCountly
//
//  Created by Thaddeus Ternes on 6/7/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTCountlyDevice : NSObject

/**
 *  A unique identifer that can be used across app instances and vendor applications
 *
 *  @return A unique app identifier
 */
- (NSString *)uniqueIdentifier;

/**
 *  Name of the current operation system; @"iOS" or @"OS X"
 *
 *  @return String represention the operation system name
 */
- (NSString *)operationSystemName;

/**
 *  OS version; "6.1.1" or "10.9.3"
 *
 *  @return String representation of the host OS version
 */
- (NSString *)operationSystemVersion;

/**
 *  The internal product name for the device; "iMac2,1 or iPhone6,2"
 *
 *  @return String representation of the product name
 */
- (NSString *)deviceProductName;

/**
 *  String representation of the primary screen resolution (mainScreen on iOS, or primary screen on OS X). "320x480" for the original iPhone
 *
 *  @return String representation the primary screen resolution.
 */
- (NSString *)mainScreenResolution;

/**
 *  The carrier name of the primary telephony radio in the device. For devices without cellular service, this will be nil
 *
 *  @return String value for the carrier name, or nil if there is no celluar service
 */
- (NSString *)cellularCarrier;

/**
 *  CFBundleShortVersion string.. "1.0", "3.2.1", etc. If the marketing version can't be found, CFBundleVersion will be used instead.
 *
 *  @return String for the current app version.
 */
- (NSString *)appVersion;

/**
 *  The local string for the current user; "en_US"
 *
 *  @return Locale string for the current user
 */
- (NSString *)locale;

@end
