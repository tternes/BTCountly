//
//  BTcountlyEnabledTests.m
//  BTCountly
//
//  Created by Thaddeus Ternes on 6/11/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BTCountly.h"

@interface BTcountlyEnabledTests : XCTestCase
@property (nonatomic, retain) BTCountly *countly;
@property (nonatomic, retain) BTCountly *enabledCountly;
@end

@implementation BTcountlyEnabledTests

- (void)setUp
{
    [super setUp];
    self.countly = [[[BTCountly alloc] init] autorelease];
    self.countly.enabled = NO;
    self.countly.serverUrl = @"https://testserver.local";
    self.countly.appToken = @"123";
    
    self.enabledCountly = [[[BTCountly alloc] init] autorelease];
    self.enabledCountly.serverUrl = @"https://testserver.local";
    self.enabledCountly.appToken = @"123";
}

- (void)tearDown
{
    self.countly = nil;
    self.enabledCountly = nil;
    [super tearDown];
}

- (void)testEnabledByDefault
{
    XCTAssertTrue(self.enabledCountly.isEnabled, @"BTCountly is enabled by default");
}

- (void)testStartSessionReturnsNo
{
    XCTAssertFalse([self.countly startSessionWithServer:@"https://testserver.local" forAppToken:@"123"], @"-startSessionWithServer returns NO when disabled");
    XCTAssertFalse([self.countly isSessionActive], @"Session is not active when startSessionWithServer returns NO");
}

- (void)testBeginSessionReturnsNo
{
    XCTAssertTrue([self.countly beginSession] == NO, @"-beginSession returns NO when disabled");
    XCTAssertFalse([self.countly isSessionActive], @"Session is not active when beginSession returns NO");
}

- (void)testEndSessionReturnsNo
{
    XCTAssertFalse([self.countly endSession], @"-endSession returns NO when disabled");
}

- (void)testAddEventReturnsNo
{
    XCTAssertFalse([self.countly addEvent:@"hi"], @"-addEvent returns NO when disabled");
}

- (void)testAddEventCountReturnsNo
{
    XCTAssertFalse([self.countly addEvent:@"hi" count:100], @"-addEvent:count: returns NO when disabled");
}

- (void)testAddEventSegmentationReturnsNo
{
    XCTAssertFalse([self.countly addEvent:@"hi" segmentation:@{@"color" : @"red" }], @"-addEvent:segmentation: returns NO when disabled");
}

- (void)testAddEventReturnsYes
{
    XCTAssertTrue([self.enabledCountly beginSession], @"-beginSession returns YES when enabled");
    XCTAssertTrue([self.enabledCountly addEvent:@"hi"], @"-addEvent returns YES when enabled");
}

- (void)testAddEventCountReturnsYes
{
    XCTAssertTrue([self.enabledCountly beginSession], @"-beginSession returns YES when enabled");
    XCTAssertTrue([self.enabledCountly addEvent:@"hi" count:100], @"-addEvent:count: returns YES when enabled");
}

- (void)testAddEventSegmentationReturnsYes
{
    XCTAssertTrue([self.enabledCountly beginSession], @"-beginSession returns YES when enabled");
    XCTAssertTrue([self.enabledCountly addEvent:@"hi" segmentation:@{@"color" : @"red" }], @"-addEvent:segmentation: returns YES when enabled");
}

@end
