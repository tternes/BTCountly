//
//  NSString+UrlStringEncoding.m
//  BTCountly
//
//  Created by Thaddeus on 6/7/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import "NSString+UrlStringEncoding.h"

@implementation NSString (UrlStringEncoding)

- (NSString *)bt_urlEncoded
{
    CFStringRef cfString =
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            NULL,
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
    
    NSString *result = [NSString stringWithString:(NSString *)cfString];
    CFRelease(cfString);
    return result;
}

@end
