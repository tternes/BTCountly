//
//  BTCountly.m
//  BTCountly
//
//  Created by Thaddeus on 6/7/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import "BTCountly.h"
#import "BTCountlyArcCheck.h"
#import "BTCountlySession.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

typedef NS_OPTIONS(NSUInteger, BTCountlySessionManagementState)
{
    BTSessionStateUnknown,
    BTSessionStateAutomatic,
    BTSessionStateManual
};

@interface BTCountly ()
@property (nonatomic, retain) BTCountlySession *session;
@property (nonatomic, assign) BTCountlySessionManagementState sessionManagement;
@end

@implementation BTCountly

+ (BTCountly *)shared
{
    static BTCountly *s_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_shared = [[BTCountly alloc] init];
    });
    
    return s_shared;
}

#pragma mark - Automatic Session API

- (BOOL)startSessionWithServer:(NSString *)serverUrl forAppToken:(NSString *)appToken
{
    switch(self.sessionManagement)
    {
        case BTSessionStateUnknown:
            [self privateRegisterForApplicationEvents:YES];
            return [self privateBeginSession];

        case BTSessionStateAutomatic:
        case BTSessionStateManual:
            NSLog(@"*** invalid session management state - already using (%s:%i)", __PRETTY_FUNCTION__, __LINE__);
            return NO;
    }
}

#pragma mark - Manual Session API

- (BOOL)beginSession;
{
    switch(self.sessionManagement)
    {
        case BTSessionStateUnknown:
            return [self privateBeginSession];
            
        case BTSessionStateAutomatic:
        case BTSessionStateManual:
            NSLog(@"*** invalid session management state - already using (%s:%i)", __PRETTY_FUNCTION__, __LINE__);
            return NO;
    }
}

- (BOOL)privateBeginSession
{
    NSAssert(self.serverUrl, @"serverUrl must be set before beginning a session");
    NSAssert(self.appToken.length, @"appToken must be set before beginning a session");
    
    // Is session already active?
    if(self.session)
    {
        return NO;
    }
    
    self.session = [[[BTCountlySession alloc] initWithURL:self.serverUrl appToken:self.appToken] autorelease];
    return [self.session beginSession];
}

- (BOOL)endSession
{
    return [self.session endSession];
}

#pragma mark - UIApplication Events

- (void)privateRegisterForApplicationEvents:(BOOL)shouldRegister
{
    if(shouldRegister)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillTerminate:)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
        
    }
    else
    {
        
    }
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    
}

@end