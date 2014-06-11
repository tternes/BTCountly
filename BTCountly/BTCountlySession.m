//
//  BTCountlySession.m
//  BTCountly
//
//  Created by Thaddeus Ternes on 6/7/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import "BTCountlySession.h"
#import "BTCountlyArcCheck.h"
#import "BTCountlyBeginSessionRequest.h"
#import "BTCountlyEndSessionRequest.h"
#import "BTCountlyExtendSessionRequest.h"
#import "BTCountlyEventCollection.h"
#import "BTCountlyEvent.h"

#define kSessionTimerInterval (30.0)

@interface BTCountlySession () <BTCountlyRequestDelegate>
@property (nonatomic, retain) NSURL *baseUrl;
@property (nonatomic, retain) NSString *appToken;
@property (nonatomic, retain) BTCountlyDevice *currentDevice;
@property (nonatomic, retain) NSTimer *sessionTimer;
@property (nonatomic, retain) BTCountlyBeginSessionRequest *beginRequest;
@property (nonatomic, retain) BTCountlyEndSessionRequest *endRequest;
@property (nonatomic, retain) BTCountlyEventCollection *queuedEvents;
@property (nonatomic, retain) NSDate *lastReportedSessionTime;
@end

@implementation BTCountlySession

- (instancetype)init
{
    return [self initWithURL:nil appToken:nil];
}

- (instancetype)initWithURL:(NSURL *)baseUrl appToken:(NSString *)appToken
{
    self = [super init];
    if(self)
    {
        self.baseUrl = baseUrl;
        self.appToken = appToken;
        self.lastReportedSessionTime = nil;
        self.currentDevice = [[[BTCountlyDevice alloc] init] autorelease];
        self.queuedEvents = [[[BTCountlyEventCollection alloc] init] autorelease];
    }
    
    return self;
}

- (void)dealloc
{
    self.baseUrl = nil;
    self.appToken = nil;
    self.currentDevice = nil;

    self.beginRequest.delegate = nil;
    self.beginRequest = nil;
    self.endRequest.delegate = nil;
    self.endRequest = nil;
    
    self.queuedEvents = nil;
    
    [super dealloc];
}

- (BOOL)beginSession
{
    NSAssert(self.baseUrl, @"baseUrl property must be set before starting a session");
    NSAssert(self.appToken.length, @"appToken property must be set before starting a session");
    NSAssert(self.beginRequest == nil, @"Cannot beingSession while another request is active");

    if(self.beginRequest)
    {
        return NO;
    }

    self.lastReportedSessionTime = [NSDate date];
    self.beginRequest = [[[BTCountlyBeginSessionRequest alloc] initWithSession:self] autorelease];
    self.beginRequest.delegate = self;
    return [self.beginRequest send];
}

- (BOOL)endSession
{
    NSAssert(self.endRequest == nil, @"Cannot endSession while another request is active");
    if(self.endRequest)
    {
        return NO;
    }

    self.endRequest = [[[BTCountlyEndSessionRequest alloc] initWithSession:self] autorelease];
    self.endRequest.delegate = self;
    self.endRequest.events = [self.queuedEvents events];
    
    if([self.endRequest send])
    {
        [self.queuedEvents purge];
        return YES;
    }

    return NO;
}

- (NSTimeInterval)sessionDuration
{
    if(self.lastReportedSessionTime)
        return ([[NSDate date] timeIntervalSinceDate:self.lastReportedSessionTime]);
    return 0;
}

- (BOOL)addEvent:(BTCountlyEvent *)event
{
    return [self.queuedEvents addEvent:event];
}

#pragma mark - BTCountlyRequestDelegate

- (void)countlyRequestSuccessfullyCompleted:(BTCountlyRequest *)request
{
    if(request == self.beginRequest)
    {
        // begin_session was successfully sent - start the session timer
        [self.sessionTimer invalidate];
        self.sessionTimer = [NSTimer scheduledTimerWithTimeInterval:kSessionTimerInterval target:self selector:@selector(sessionTimerFired:) userInfo:nil repeats:YES];
        
        self.beginRequest.delegate = nil;
        self.beginRequest = nil;
    }
    else if(request == self.endRequest)
    {
        // session is over - invalidate the timer
        [self.sessionTimer invalidate];
        self.sessionTimer = nil;
        
        self.endRequest.delegate = nil;
        self.endRequest = nil;
        
        self.lastReportedSessionTime = nil;
    }
    else if([request isKindOfClass:[BTCountlyExtendSessionRequest class]])
    {
        // record lastReportedTime
        BTCountlyExtendSessionRequest *extendRequest = (BTCountlyExtendSessionRequest *)request;
        extendRequest.delegate = nil;
        
        self.lastReportedSessionTime = extendRequest.reportedSessionTime;
        [extendRequest release];
    }
}

- (void)countlyRequest:(BTCountlyRequest *)request failedWithError:(NSError *)error
{
    if(request == self.beginRequest)
    {
        // begin_session was successfully sent - start the session timer
        [self.sessionTimer invalidate];
        self.sessionTimer = [NSTimer scheduledTimerWithTimeInterval:kSessionTimerInterval target:self selector:@selector(sessionTimerFired:) userInfo:nil repeats:YES];
        
        self.beginRequest.delegate = nil;
        self.beginRequest = nil;
    }
    else if(request == self.endRequest)
    {
        // session is over - invalidate the timer
        [self.sessionTimer invalidate];
        self.sessionTimer = nil;
        
        self.endRequest.delegate = nil;
        self.endRequest = nil;
        
        self.lastReportedSessionTime = nil;
    }
    else if([request isKindOfClass:[BTCountlyExtendSessionRequest class]])
    {
        BTCountlyExtendSessionRequest *extendRequest = (BTCountlyExtendSessionRequest *)request;
        extendRequest.delegate = nil;
        [extendRequest release];
    }
}

#pragma mark - Session Timer

- (void)sessionTimerFired:(NSTimer *)timer
{
    BTCountlyExtendSessionRequest *extend = [[BTCountlyExtendSessionRequest alloc] initWithSession:self];
    extend.events = [self.queuedEvents events];
    extend.delegate = self;
    if([extend send])
    {
        [self.queuedEvents purge];
    }
}

@end
