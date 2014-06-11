//
//  BTCountlySession.h
//  BTCountly
//
//  Created by Thaddeus Ternes on 6/7/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTCountlyDevice.h"
#import "BTCountlyEvent.h"

@interface BTCountlySession : NSObject

@property (nonatomic, retain, readonly) NSString *appToken;
@property (nonatomic, retain, readonly) NSURL *baseUrl;
@property (nonatomic, assign, readonly) BOOL isActive;
@property (nonatomic, retain, readonly) BTCountlyDevice *currentDevice;
@property (nonatomic, retain, readonly) NSDate *lastReportedSessionTime;

- (instancetype)initWithURL:(NSURL *)baseUrl appToken:(NSString *)appToken;

- (BOOL)beginSession;
- (BOOL)endSession;

- (BOOL)addEvent:(BTCountlyEvent *)event;

@end
