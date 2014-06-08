//
//  NSDictionary+DictionaryString.m
//  BTCountly
//
//  Created by Thaddeus on 6/7/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import "NSDictionary+DictionaryString.h"

@implementation NSDictionary (DictionaryString)

- (NSString *)bt_stringForDictionary
{
    NSString *jsonString = @"";
    NSError *jsonError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&jsonError];
    
    if(jsonData && !jsonError)
    {
        jsonString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
    }

    return jsonString;
}

@end
