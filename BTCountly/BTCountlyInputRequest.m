//
//  BTCountlyInputRequest.m
//  BTCountly
//
//  Created by Thaddeus Ternes on 6/7/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import "BTCountlyInputRequest.h"
#import "BTCountlyDevice.h"

@implementation BTCountlyInputRequest

- (NSString *)requestEndpoint
{
    return @"/i";
}

- (NSMutableDictionary *)requestUrlParameters
{
    NSMutableDictionary *dictionary = [super requestUrlParameters];
    
    // required parameters for the Write API
    [dictionary setValue:self.session.appToken forKey:@"app_key"];
    [dictionary setValue:[self.session.currentDevice uniqueIdentifier] forKey:@"device_id"];
    [dictionary setValue:[NSNumber numberWithLong:time(NULL)] forKey:@"timestamp"];
    
    return dictionary;
}

@end
