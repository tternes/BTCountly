//
//  BTCountlyEndSessionRequest.m
//  BTCountly
//
//  Created by Thaddeus on 6/7/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import "BTCountlyEndSessionRequest.h"

@implementation BTCountlyEndSessionRequest

- (NSMutableDictionary *)requestUrlParameters
{
    NSMutableDictionary *dictionary = [super requestUrlParameters];
    [dictionary setValue:@"1" forKey:@"end_session"];
    return dictionary;
}

@end
