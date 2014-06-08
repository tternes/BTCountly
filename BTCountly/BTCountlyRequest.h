//
//  BTCountlyRequest.h
//  BTCountly
//
//  Created by Thaddeus on 6/7/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTCountlySession.h"

@class BTCountlyRequest;
@protocol BTCountlyRequestDelegate <NSObject>

@required
- (void)countlyRequestSuccessfullyCompleted:(BTCountlyRequest *)request;
- (void)countlyRequest:(BTCountlyRequest *)request failedWithError:(NSError *)error;

@end

@interface BTCountlyRequest : NSObject

@property (nonatomic, retain, readonly) BTCountlySession *session;
@property (nonatomic, assign) id<BTCountlyRequestDelegate> delegate;

- (instancetype)initWithSession:(BTCountlySession *)session;
- (BOOL)send;

- (NSString *)requestEndpoint;
- (NSMutableDictionary *)requestUrlParameters;

@end
