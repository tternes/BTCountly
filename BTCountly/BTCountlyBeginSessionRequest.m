//
//  BTCountlyBeginSessionRequest.m
//  BTCountly
//
//  Created by Thaddeus Ternes on 6/7/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import "BTCountlyBeginSessionRequest.h"
#import "NSDictionary+DictionaryString.h"

@implementation BTCountlyBeginSessionRequest

- (NSMutableDictionary *)requestUrlParameters
{
    NSMutableDictionary *dictionary = [super requestUrlParameters];
    
    [dictionary setValue:@"1" forKey:@"begin_session"];
    [dictionary setValue:@"1.0" forKey:@"sdk_version"];

    NSDictionary *metrics = [self metricsDictionary];
    if([metrics count])
    {
        NSString *metricsString = [metrics bt_stringForDictionary];
        if(metricsString)
            [dictionary setValue:metricsString forKey:@"metrics"];
    }

    return dictionary;
}

- (NSDictionary *)metricsDictionary
{
    BTCountlyDevice *device = self.session.currentDevice;
    
    NSMutableDictionary *metrics = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [device operationSystemName], @"_os",
                                    [device operationSystemVersion], @"_os_version",
                                    [device deviceProductName], @"_device",
                                    [device mainScreenResolution], @"_resolution",
                                    [device appVersion], @"_app_version",
                                    nil];
    
    if(device.cellularCarrier)
        [metrics setValue:[device cellularCarrier] forKey:@"_carrier"];
    
    return metrics;
}

@end
