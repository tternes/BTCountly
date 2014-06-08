//
//  BTCountlyDeviceTests.m
//  BTCountly
//
//  Created by Thaddeus on 6/8/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BTCountlyDevice.h"

@interface BTCountlyDeviceTests : XCTestCase
@property (nonatomic, retain) BTCountlyDevice *device;
@end

@implementation BTCountlyDeviceTests

- (void)setUp
{
    [super setUp];
    self.device = [[[BTCountlyDevice alloc] init] autorelease];
}

- (void)tearDown
{
    self.device = nil;
    [super tearDown];
}

#if TARGET_OS_IPHONE
- (void)testSimulatorOperatingSystemName
{
    XCTAssertEqualObjects([self.device operationSystemName], @"iOS", @"Simulator reports 'iOS' for os name");
}

- (void)testSimulatorScreenResolution
{
    NSLog(@"screen resolution: %@", [self.device mainScreenResolution]);
    XCTAssertNotNil([self.device mainScreenResolution], @"Screen resolution is not nil");
}

- (void)testSimulatorCellularProvider
{
    XCTAssertNil([self.device cellularCarrier], @"Simulator has no cellular provider");
}
#endif

@end
