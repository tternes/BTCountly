//
//  BTCountly.h
//  BTCountly
//
//  Created by Thaddeus on 6/7/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTCountly : NSObject

// --------------------------------------------------------------------------------------------------------
#pragma mark - Automatic Session API
// --------------------------------------------------------------------------------------------------------

/**
 *  Initializes the serverUrl and appToken properties, and then configures automatic session support. When used, the client application doesn't need to deal with background/foreground transitions to report session state - this handlers are registered within the BTCountly library.
 *
 *  @param serverUrl The Count.ly server installation URL. e.g. @"http://stats.company.com" or @"http://api.company.com/stats"
 *  @param appToken  Count.ly app token. This is retrieved from the Count.ly dashboard.
 *
 *  @return YES if the session is successfully configured, or NO if an error occurs.
 */
- (BOOL)startSessionWithServer:(NSString *)serverUrl forAppToken:(NSString *)appToken;

// --------------------------------------------------------------------------------------------------------
#pragma mark - Manual Session API
// --------------------------------------------------------------------------------------------------------

/**
 *  The Count.ly server installation URL. This does not include paths to specific API endpoints on the server.
 *  This property must be set before starting a session.
 */
@property (nonatomic, retain) NSString *serverUrl;

/**
 *  The application-specific token used to identify events to the Count.ly server installation.
 *  You should retrieve this from your Count.ly dashboard.
 */
@property (nonatomic, retain) NSString *appToken;

/**
 *  Starts a session with the Count.ly server. The session will be updated automatically until -endSession
 *  is sent, or the application is sent to the background (on iOS)
 *
 *  @return YES if the session is successfully started, NO if an error occurs
 */
- (BOOL)beginSession;

/**
 *  Ends an established session with the Count.ly server. Pending events will be flushed, if possible.
 *
 *  @return YES if the session is successfully ended, NO if an error occurs
 */
- (BOOL)endSession;

// --------------------------------------------------------------------------------------------------------
#pragma mark - Events
// --------------------------------------------------------------------------------------------------------

- (BOOL)addEvent:(NSString *)eventKey;

- (BOOL)addEvent:(NSString *)eventKey count:(NSUInteger)count;

- (BOOL)addEvent:(NSString *)eventKey segmentation:(NSDictionary *)segmentation;


// --------------------------------------------------------------------------------------------------------
#pragma mark - Shared Instance
// --------------------------------------------------------------------------------------------------------

/**
 *  A convenience method for lazy programmers.
 *
 *  @return A static instance of the BTCountly class. Other instances may be allocated and initialized with -init as expected.
 */
+ (BTCountly *)shared;

@end
