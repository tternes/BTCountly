//
//  BTCountlyExtendSessionRequest.m
//  BTCountly
//
//  Created by Thaddeus Ternes on 6/7/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import "BTCountlyExtendSessionRequest.h"
#import "BTCountlyEvent.h"
#import "NSDictionary+DictionaryString.h"

@interface BTCountlyExtendSessionRequest ()
@property (nonatomic, retain) NSDate *reportedSessionTime;
@property (nonatomic, assign) NSTimeInterval unreportedTimeDelta;
@end

@implementation BTCountlyExtendSessionRequest

- (void)dealloc
{
    self.reportedSessionTime = nil;
    self.events = nil;
    [super dealloc];
}

- (NSMutableDictionary *)requestUrlParameters
{
    NSMutableDictionary *dictionary = [super requestUrlParameters];

    self.reportedSessionTime = [NSDate date];
    self.unreportedTimeDelta = [self.reportedSessionTime timeIntervalSinceDate:self.session.lastReportedSessionTime];
    
    [dictionary setValue:[NSNumber numberWithInteger:self.unreportedTimeDelta] forKey:@"session_duration"];
    
    if(self.events.count)
    {
        __block NSMutableArray *jsonArray = [NSMutableArray array];
        [self.events enumerateObjectsUsingBlock:^(BTCountlyEvent *event, NSUInteger idx, BOOL *stop) {

            [jsonArray addObject:[event eventDictionaryRepresentation]];
            
        }];
        
        [dictionary setValue:[jsonArray bt_stringForDictionary] forKey:@"events"];
    }

    return dictionary;
}

@end
