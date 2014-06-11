//
//  BTCountlyEvent.h
//  BTCountly
//
//  Created by Thaddeus Ternes on 6/8/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTCountlyEvent : NSObject

@property (nonatomic, retain) NSString *key;

@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign) NSUInteger sum;
@property (nonatomic, retain) NSDictionary *segmentation;

+ (BTCountlyEvent *)eventWithkey:(NSString *)key;
+ (BTCountlyEvent *)eventWithKey:(NSString *)key count:(NSUInteger)count;
+ (BTCountlyEvent *)eventWithKey:(NSString *)key segmentation:(NSDictionary *)segmentation;

- (id)eventDictionaryRepresentation;

@end
