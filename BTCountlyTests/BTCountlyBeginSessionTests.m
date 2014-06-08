//
//  BTCountlyBeginSessionTests.m
//  BTCountly
//
//  Created by Thaddeus on 6/8/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BTCountlyBeginSessionRequest.h"

@interface BTCountlyBeginSessionTests : XCTestCase
@property (nonatomic, retain) BTCountlyBeginSessionRequest *request;
@end

@implementation BTCountlyBeginSessionTests

- (void)setUp
{
    [super setUp];
    BTCountlySession *session = [[[BTCountlySession alloc] init] autorelease];
    self.request = [[BTCountlyBeginSessionRequest alloc] initWithSession:session];
}

- (void)tearDown
{
    self.request = nil;
    [super tearDown];
}

- (void)testBeginSessionHasDevice
{
    XCTAssertNotNil(self.request.session.currentDevice, @"Current device is not nil");
}

- (void)testBeginSessionUrl
{
    XCTAssertEqualObjects([self.request requestEndpoint], @"/i", @"Begin session endoint is /i");
}

- (void)testBeginSessionRequiredParameters
{
    NSDictionary *parameters = [self.request requestUrlParameters];

    XCTAssertNotNil([parameters valueForKey:@"begin_session"], @"begin_session must be present");
    XCTAssertNotNil([parameters valueForKey:@"sdk_version"], @"sdk_version must be present");
    XCTAssertNotNil([parameters valueForKey:@"timestamp"], @"timestamp must be present");
    XCTAssertNotNil([parameters valueForKey:@"metrics"], @"metrics must be present");
}

- (void)testBeginSessionMetricsJsonString
{
    NSDictionary *parameters = [self.request requestUrlParameters];
    NSString *metricsJsonString = [parameters valueForKey:@"metrics"];
    
    id json = [NSJSONSerialization JSONObjectWithData:[metricsJsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    XCTAssertNotNil(json, @"Can parse metrics json substring");
    
    XCTAssertNotNil(json[@"_device"], @"metrics contains device product name");
    XCTAssertNotNil(json[@"_os"], @"metrics contains os name");
    XCTAssertNotNil(json[@"_os_version"], @"metrics contains os version");
    XCTAssertNotNil(json[@"_resolution"], @"metrics contains device main screen resolution");
}

@end
