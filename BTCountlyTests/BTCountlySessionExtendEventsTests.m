//
//  BTCountlySessionExtendEventsTests.m
//  BTCountly
//
//  Created by Thaddeus on 6/8/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BTCountlyEventCollection.h"
#import "BTCountlyExtendSessionRequest.h"

@interface BTCountlySessionExtendEventsTests : XCTestCase
@property (nonatomic, retain) BTCountlyEventCollection *queuedEvents;

@end

@implementation BTCountlySessionExtendEventsTests

- (void)setUp
{
    [super setUp];
    self.queuedEvents = [[[BTCountlyEventCollection alloc] init] autorelease];
}

- (void)tearDown
{
    self.queuedEvents = nil;
    [super tearDown];
}

- (void)testNoEventsPending
{
    BTCountlyExtendSessionRequest *request = [[[BTCountlyExtendSessionRequest alloc] init] autorelease];
    request.events = [self.queuedEvents events];
    [self.queuedEvents purge];
    
    NSDictionary *parameters = [request requestUrlParameters];
    XCTAssertNil([parameters valueForKey:@"events"], @"no events key in session extension message");
}

- (void)testPendingEvents
{
    [self.queuedEvents addEvent:[BTCountlyEvent eventWithkey:@"hi"]];
    
    BTCountlyExtendSessionRequest *request = [[[BTCountlyExtendSessionRequest alloc] init] autorelease];
    request.events = [self.queuedEvents events];
    [self.queuedEvents purge];
    
    NSDictionary *parameters = [request requestUrlParameters];
    XCTAssertNotNil([parameters valueForKey:@"events"], @"one message in session extension message");
}

@end
