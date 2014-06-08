	!!! This is a work in progress. It is incomplete, and not ready for production. !!!

BTCountly
=========
[BTCountly] is an API client for the esteemed [Count.ly] mobile analytics platform. It is written in Objective-C and builds for iOS 6.0+ and OS X 10.7+.

This from-scratch project has been influenced and inspired by the [official Count.ly iOS SDK](https://github.com/Countly/countly-sdk-ios). However, it was created with the following design goals in mind:

* no external dependencies
* no dependency on Core Data for local queuing
* testability
* no singletons


Installation
---
TODO..

Sessions
---
You have two options when integrating the library: automatic or manual session management. Most applications that wish to track sessions will likely opt for the simpler automatic method. If you don't want to track sessions (only events), simply set the appToken and serverUrl properties on the `BTCountly` instance and omit any session calls.

	// -----------------------------------
	// Automatic configuration:
	// The library will manage sessions (foreground/background) automatically
	// -----------------------------------
	[[BTCountly shared] startSessionWithServer:server forAppToken:token];

	
-or-

	// -----------------------------------
	// Manual Session Management:
	// The library will not handle sessions - it's up to the app to begin/end sessions
	// -----------------------------------
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
	    [[BTCountly shared] setAppToken:token];
	    [[BTCountly shared] setServerUrl:url];
	    [[BTCountly shared] beginSession];
    }
    
	- (void)applicationWillResignActive:(UIApplication *)application
	{
		// ...
	    [[BTCountly shared] endSession];
	}
	
	- (void)applicationDidBecomeActive:(UIApplication *)application
	{
		// ...
	    [[BTCountly shared] beginSession];
	}
	
	- (void)applicationWillTerminate:(UIApplication *)application
	{
		// ...
	    [[BTCountly shared] endSession];
	}


ARC
-----
BTCountly is knowingly built with manual `-retain` / `-release`, rather than using Automatic Reference Counting. This is to prevent the library from being incompatible with older OSes, in hopes that other modern dependencies (`NSJSONSerialization`) can be removed.

Contact
---
* ADN: [@thaddeus](http://alpha.app.net/thaddeus)
* Twitter: [@thaddeus](http://twitter.com/thaddeus)



[BTCountly]:https://github.com/tternes/BTCountly
[Count.ly]:https://count.ly
[countly-sdk-ios]:https://github.com/Countly/countly-sdk-ios