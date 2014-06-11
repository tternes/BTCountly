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

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.enabled = YES;
    }
    
    return self;
}

#pragma mark - Automatic Session API

- (BOOL)startSessionWithServer:(NSString *)serverUrl forAppToken:(NSString *)appToken
{
    if(self.isEnabled == NO)
        return NO;

    self.serverUrl = serverUrl;
    self.appToken = appToken;
    
    switch(self.sessionManagement)
    {
        case BTSessionStateUnknown:
            self.sessionManagement = BTSessionStateAutomatic;
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
    if(self.isEnabled == NO)
        return NO;

    switch(self.sessionManagement)
    {
        case BTSessionStateUnknown:
            self.sessionManagement = BTSessionStateManual;
            return [self privateBeginSession];
            
        case BTSessionStateAutomatic:
        case BTSessionStateManual:
            NSLog(@"*** invalid session management state - already using (%s:%i)", __PRETTY_FUNCTION__, __LINE__);
            return NO;
    }
}

- (BOOL)endSession
{
    BOOL result = NO;

    // if enabled, we want to be sure end_session gets sent
    // if not, we __DON'T__ want data sent out
    result = (self.enabled) ? [self.session endSession] : NO;
    self.sessionManagement = BTSessionStateUnknown;
    self.session = nil;

    return result;
}

- (BOOL)isSessionActive
{
    return [self.session isActive];
}

- (void)setEnabled:(BOOL)enabled
{
    [self willChangeValueForKey:@"enabled"];
    _enabled = enabled;
    
    // are we enabled? - endSession will purge
    if(enabled == NO)
        [self endSession];
    
    [self didChangeValueForKey:@"enabled"];
}

#pragma mark - Events

- (BOOL)addEvent:(NSString *)eventKey
{
    return [self.session addEvent:[BTCountlyEvent eventWithkey:eventKey]];
}

- (BOOL)addEvent:(NSString *)eventKey count:(NSUInteger)count
{
    return [self.session addEvent:[BTCountlyEvent eventWithKey:eventKey count:count]];
}

- (BOOL)addEvent:(NSString *)eventKey segmentation:(NSDictionary *)segmentation
{
    return [self.session addEvent:[BTCountlyEvent eventWithKey:eventKey segmentation:segmentation]];
}

#pragma mark - Private

- (BOOL)privateBeginSession
{
    NSAssert(self.serverUrl, @"serverUrl must be set before beginning a session");
    NSAssert(self.appToken.length, @"appToken must be set before beginning a session");
    
    // Is session already active?
    if(self.session)
    {
        return NO;
    }
    
    self.session = [[[BTCountlySession alloc] initWithURL:[NSURL URLWithString:self.serverUrl] appToken:self.appToken] autorelease];
    return [self.session beginSession];
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
