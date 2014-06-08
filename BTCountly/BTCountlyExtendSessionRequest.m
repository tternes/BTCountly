//
//  BTCountlyExtendSessionRequest.m
//  BTCountly
//
//  Created by Thaddeus on 6/7/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import "BTCountlyExtendSessionRequest.h"

@implementation BTCountlyExtendSessionRequest

- (NSMutableDictionary *)requestUrlParameters
{
    NSMutableDictionary *dictionary = [super requestUrlParameters];
    [dictionary setValue:[NSNumber numberWithInteger:[self.session sessionDuration]] forKey:@"session_duration"];
    return dictionary;
}

@end
