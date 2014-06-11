//
//  BTCountly.h
//  BTCountly
//
//  Created by Thaddeus Ternes on 6/7/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTCountly : NSObject

// --------------------------------------------------------------------------------------------------------
#pragma mark - Killswitch
// --------------------------------------------------------------------------------------------------------
/**
 *  Determines if the library is enabled. If NO, all calls made to BTCountly instances
 *  will be no-op. Make note of the return values for each message when disabled.
 *
 *  Consider allowing your users to opt-out of anonymous analytics, and use this
 *  simple property if they do so.
 *
 *  Default is YES; set to NO to disable BTCountly
 */
@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

// --------------------------------------------------------------------------------------------------------
#pragma mark - Automatic Session API
// --------------------------------------------------------------------------------------------------------

/**
 *  Initializes the serverUrl and appToken properties, and then configures automatic session support. When used, the client application doesn't need to deal with background/foreground transitions to report session state - this handlers are registered within the BTCountly library.
 *
 *  @param serverUrl The Count.ly server installation URL. e.g. @"http://stats.company.com" or @"http://api.company.com/stats"
 *  @param appToken  Count.ly app token. This is retrieved from the Count.ly dashboard.
 *
 *  @return YES if the session is successfully configured, or NO if an error occurs. Returns NO if isEnabled is NO.
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
 *  @return YES if the session is successfully started, NO if an error occurs. Returns NO if isEnabled is NO.
 */
- (BOOL)beginSession;

/**
 *  Ends an established session with the Count.ly server. Pending events will be flushed, if possible.
 *
 *  @return YES if the session is successfully ended, NO if an error occurs. Returns NO if isEnabled is NO.
 */
- (BOOL)endSession;

/**
 *  Determines if a session is currently active
 *
 *  @return YES if a session is active, NO otherwise
 */
- (BOOL)isSessionActive;

// --------------------------------------------------------------------------------------------------------
#pragma mark - Events
// --------------------------------------------------------------------------------------------------------

/**
 *  Queues an event with the specified key to be sent during the next batch. If an instance of this key already exists, its count is incremented by one.
 *
 *  @param eventKey Unique event name
 *
 *  @return YES if the event is queued, NO if an error occurs. Returns NO if isEnabled is NO.
 */
- (BOOL)addEvent:(NSString *)eventKey;

/**
 *  Queues an event with the specified key and count to be sent during the next batch. If an instance of this key already exists, its count is incremented by count.
 *
 *  @param eventKey Unique event name
 *  @param count    Number of times event has occurred.
 *
 *  @return YES if the event is queued, NO if an error occurs. Returns NO if isEnabled is NO.
 */
- (BOOL)addEvent:(NSString *)eventKey count:(NSUInteger)count;

/**
 *  Queues an event with the specified key to be sent during the next batch. If an instance of this key already exists with the provided segmentation, its count is incremented by one.
 *
 *  @param eventKey     Unique event name
 *  @param segmentation Distinguishing set of parameters to segment event
 *
 *  @return YES if the event is queued, NO if an error occurs. Returns NO if isEnabled is NO.
 */
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
