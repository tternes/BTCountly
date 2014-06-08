//
//  BTCountlySession.h
//  BTCountly
//
//  Created by Thaddeus on 6/7/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTCountlyDevice.h"

@interface BTCountlySession : NSObject

@property (nonatomic, retain, readonly) NSString *appToken;
@property (nonatomic, retain, readonly) NSURL *baseUrl;
@property (nonatomic, assign, readonly) BOOL isActive;
@property (nonatomic, retain, readonly) BTCountlyDevice *currentDevice;
@property (nonatomic, assign, readonly) NSTimeInterval sessionDuration;

- (instancetype)initWithURL:(NSURL *)baseUrl appToken:(NSString *)appToken;

- (BOOL)beginSession;
- (BOOL)endSession;

@end
