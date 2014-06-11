//
//  BTCountlyRequest.m
//  BTCountly
//
//  Created by Thaddeus Ternes on 6/7/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#import "BTCountlyRequest.h"
#import "NSString+UrlStringEncoding.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

@interface BTCountlyRequest ()
@property (nonatomic, retain) BTCountlySession *session;
@property (nonatomic, retain) NSMutableURLRequest *urlRequest;
@property (nonatomic, retain) NSURLConnection *urlConnection;
#if TARGET_OS_IPHONE
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTask;
#endif
@end

@implementation BTCountlyRequest

- (instancetype)initWithSession:(BTCountlySession *)session
{
    self = [super init];
    if(self)
    {
        self.session = session;
    }
    
    return self;
}

- (void)dealloc
{
    self.session = nil;
    self.urlRequest = nil;
    self.urlConnection = nil;
    [super dealloc];
}

- (NSString *)requestEndpoint
{
    NSAssert(NO, @"requestEndpoint should be implemented in BTCountlyRequest subclasses");
    return nil;
}

- (NSMutableDictionary *)requestUrlParameters
{
    return [NSMutableDictionary dictionary];
}

- (BOOL)send
{
    // Add request parameters
    __block NSMutableString *endpoint = [NSMutableString stringWithString:[self requestEndpoint]];
    __block NSDictionary *parameters = [self requestUrlParameters];
    [parameters.allKeys enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {

        id value = [parameters valueForKey:name];
        if([value isKindOfClass:[NSString class]])
            value = [value bt_urlEncoded];
        [endpoint appendFormat:@"%c%@=%@", (idx==0) ? '?' : '&', [name bt_urlEncoded], value];
    }];
 
    NSURL *url = [NSURL URLWithString:endpoint relativeToURL:self.session.baseUrl];
    self.urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    self.urlConnection = [NSURLConnection connectionWithRequest:self.urlRequest delegate:self];
    [self.urlConnection start];

#if TARGET_OS_IPHONE
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{

        NSLog(@"background task expired for request: %@", self);
        [self.urlConnection cancel];
        
    }];
#endif
    
    return YES;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"** failed to make connection: %@, error=%@", self.urlRequest, error);
    [self.delegate countlyRequest:self failedWithError:error];
    
#if TARGET_OS_IPHONE
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
#endif
}

#pragma mark - NSURLConnectionDataDelegate

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    // ...
    NSLog(@"will send: %@", request.URL);
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // ...
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if([response isKindOfClass:[NSHTTPURLResponse class]])
    {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"received: %i", httpResponse.statusCode);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *str = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"%@", str);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // ...
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.delegate countlyRequestSuccessfullyCompleted:self];
    
#if TARGET_OS_IPHONE
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
#endif
}


- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];

    [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
}

@end
