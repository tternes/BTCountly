//
//  BTCountlyEventCollection.m
//  BTCountly
//
//  Created by Thaddeus on 6/8/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import "BTCountlyEventCollection.h"

@interface BTCountlyEventCollection ()
@property (nonatomic, retain) NSMutableArray *eventList;
@end

@implementation BTCountlyEventCollection

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.eventList = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc
{
    self.eventList = nil;
    [super dealloc];
}

- (BOOL)addEvent:(BTCountlyEvent *)event
{
    NSAssert(self.eventList, @"invalid event list");
    
    __block BTCountlyEvent *matchingItem = nil;
    [self.eventList enumerateObjectsUsingBlock:^(BTCountlyEvent *existing, NSUInteger idx, BOOL *stop) {

        if([existing.key isEqualToString:event.key])
        {
            *stop = NO;
            if(existing.segmentation && event.segmentation)
            {
                // has to match segmentation
                if([existing.segmentation isEqualToDictionary:event.segmentation])
                    *stop = YES;
            }
            else
            {
                // no segmentation - matches
                *stop = YES;
            }
        }
        
        if(*stop)
            matchingItem = existing;
        
    }];

    if(matchingItem)
    {
        // existing item
        matchingItem.count += event.count;
        matchingItem.sum += event.sum;
        matchingItem.segmentation = event.segmentation;
    }
    else
    {
        [self.eventList addObject:event];
    }
    
    return YES; // TODO failure cases
}

- (NSArray *)events
{
    return [[self.eventList copy] autorelease];
}

- (BOOL)purge
{
    [self.eventList removeAllObjects];
    return (self.eventList.count == 0) ? YES : NO;
}

@end
