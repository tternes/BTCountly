//
//  BTCountlyEventCollectionTests.m
//  BTCountly
//
//  Created by Thaddeus on 6/8/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BTCountlyEventCollection.h"

@interface BTCountlyEventCollectionTests : XCTestCase
@property (nonatomic, retain) BTCountlyEventCollection *collection;
@end

@implementation BTCountlyEventCollectionTests

- (void)setUp
{
    [super setUp];
    self.collection = [[[BTCountlyEventCollection alloc] init] autorelease];
}

- (void)tearDown
{
    self.collection = nil;
    [super tearDown];
}

- (void)testSingleEvent
{
    BTCountlyEvent *event = [BTCountlyEvent eventWithKey:@"single" count:1];
    [self.collection addEvent:event];
    
    XCTAssertEqual([[self.collection events] count], (NSUInteger)1, @"One event in the collection");
}

- (void)testIncrementCount
{
    [self.collection addEvent:[BTCountlyEvent eventWithKey:@"single" count:1]];
    [self.collection addEvent:[BTCountlyEvent eventWithKey:@"single" count:1]];
    
    XCTAssertEqual([[self.collection events] count], (NSUInteger)1, @"Still one event in the collection");

    BTCountlyEvent *event = [[self.collection events] objectAtIndex:0];
    XCTAssertEqual(event.count, (NSUInteger)2, @"Combined count should be 2");
}

- (void)testSimpleSegmentation
{
    [self.collection addEvent:[BTCountlyEvent eventWithKey:@"rawr" segmentation:@{@"color" : @"red" }]];
    [self.collection addEvent:[BTCountlyEvent eventWithKey:@"rawr" segmentation:@{@"color" : @"blue" }]];
    
    XCTAssertEqual([[self.collection events] count], (NSUInteger)2, @"Two events, segmented on color");
    
    BTCountlyEvent *first = [[self.collection events] objectAtIndex:0];
    BTCountlyEvent *second = [[self.collection events] objectAtIndex:1];
    XCTAssertNotEqualObjects([[first segmentation] valueForKey:@"color"], [[second segmentation] valueForKey:@"color"], @"Colors are not equal");
    
    [self.collection addEvent:[BTCountlyEvent eventWithKey:@"rawr" segmentation:@{@"color" : @"blue" }]];
    XCTAssertEqual([[self.collection events] count], (NSUInteger)2, @"After adding another blue, there are still two event");

    // make sure blue count is 2
    __block BOOL foundBlue = NO;
    [[self.collection events] enumerateObjectsUsingBlock:^(BTCountlyEvent *event, NSUInteger idx, BOOL *stop) {

        if([[[event segmentation] valueForKey:@"color"] isEqualToString:@"blue"])
        {
            foundBlue = YES;
            XCTAssertEqual(event.count, (NSUInteger)2, @"Blue has occurred twice");
        }
    }];
    
    XCTAssertTrue(foundBlue, @"Found the blue event");
}

- (void)testCompoundSegmentation
{
    [self.collection addEvent:[BTCountlyEvent eventWithKey:@"rawr" segmentation:@{@"color" : @"red", @"shape" : @"circle" }]];
    [self.collection addEvent:[BTCountlyEvent eventWithKey:@"rawr" segmentation:@{@"color" : @"red", @"shape" : @"square" }]];
   
    XCTAssertEqual([[self.collection events] count], (NSUInteger)2, @"Two rawr events, segmented on shape");

    // another red square
    [self.collection addEvent:[BTCountlyEvent eventWithKey:@"rawr" segmentation:@{@"color" : @"red", @"shape" : @"square" }]];
    XCTAssertEqual([[self.collection events] count], (NSUInteger)2, @"Still two rawr events, segmented on shape");
    
    // Add random colors squares
    [self.collection addEvent:[BTCountlyEvent eventWithKey:@"rawr" segmentation:@{@"shape" : @"square", @"color" : @"abc" }]];
    [self.collection addEvent:[BTCountlyEvent eventWithKey:@"rawr" segmentation:@{@"shape" : @"square", @"color" : @"def" }]];
    [self.collection addEvent:[BTCountlyEvent eventWithKey:@"rawr" segmentation:@{@"shape" : @"square", @"color" : @"ghi" }]];
    [self.collection addEvent:[BTCountlyEvent eventWithKey:@"rawr" segmentation:@{@"shape" : @"square", @"color" : @"jkl" }]];
    [self.collection addEvent:[BTCountlyEvent eventWithKey:@"rawr" segmentation:@{@"shape" : @"square", @"color" : @"mno" }]];
    [self.collection addEvent:[BTCountlyEvent eventWithKey:@"rawr" segmentation:@{@"shape" : @"square", @"color" : @"pqr" }]];
    
    // but now the count for the red square should be two
    __block BOOL foundRedSquare = NO;
    [[self.collection events] enumerateObjectsUsingBlock:^(BTCountlyEvent *event, NSUInteger idx, BOOL *stop) {
        
        if([[[event segmentation] valueForKey:@"shape"] isEqualToString:@"square"] &&
           [[[event segmentation] valueForKey:@"color"] isEqualToString:@"red"])
        {
            foundRedSquare = YES;
            XCTAssertEqual(event.count, (NSUInteger)2, @"Red square has occurred twice");
        }
    }];
    
    XCTAssertTrue(foundRedSquare, @"Found red square segment");
    
}

@end
