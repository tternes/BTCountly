//
//  BTCountlyExtendSessionRequest.h
//  BTCountly
//
//  Created by Thaddeus Ternes on 6/7/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import "BTCountlyInputRequest.h"
#import "BTCountlyEvent.h"

@interface BTCountlyExtendSessionRequest : BTCountlyInputRequest
@property (nonatomic, retain) NSArray *events;
@property (nonatomic, retain, readonly) NSDate *reportedSessionTime;
@end
