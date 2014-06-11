//
//  BTCountlyEvent.m
//  BTCountly
//
//  Created by Thaddeus Ternes on 6/8/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import "BTCountlyEvent.h"

@implementation BTCountlyEvent

+ (BTCountlyEvent *)eventWithkey:(NSString *)key
{
    return [self eventWithKey:key segmentation:nil count:1 sum:0];
}

+ (BTCountlyEvent *)eventWithKey:(NSString *)key count:(NSUInteger)count
{
    return [self eventWithKey:key segmentation:nil count:count sum:0];
}

+ (BTCountlyEvent *)eventWithKey:(NSString *)key segmentation:(NSDictionary *)segmentation
{
    return [self eventWithKey:key segmentation:segmentation count:1 sum:0];
}

+ (BTCountlyEvent *)eventWithKey:(NSString *)key segmentation:(NSDictionary *)segmentation count:(NSUInteger)count sum:(NSUInteger)sum
{
    BTCountlyEvent *event = [[[BTCountlyEvent alloc] init] autorelease];
    event.key = key;
    event.count = count;
    event.sum = sum;
    event.segmentation = segmentation;
    return event;
}

- (id)eventDictionaryRepresentation
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.key, @"key",
                                       [NSNumber numberWithInteger:self.count], @"count",
                                       nil];
    
    if(self.sum)
        [dictionary setValue:[NSNumber numberWithInteger:self.sum] forKey:@"sum"];
    
    if(self.segmentation)
        [dictionary setValue:self.segmentation forKey:@"segmentation"];
    
    return dictionary;
}

@end
