//
//  BTCountlyEventCollection.h
//  BTCountly
//
//  Created by Thaddeus Ternes on 6/8/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTCOuntlyEvent.h"

@interface BTCountlyEventCollection : NSObject

- (BOOL)addEvent:(BTCountlyEvent *)event;

- (NSArray *)events;

- (BOOL)purge;

@end
