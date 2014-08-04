//
//  TODOURLConnection.h
//  ToDo
//
//  Created by Gemini - Alex on 04/08/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TODOURLResponse;

/**
 * A function definition for onComplete callbacks with URL responses
 */
typedef void (^URLResponseBlock)(TODOURLResponse *);
@interface TODOURLConnection : NSObject <NSURLConnectionDataDelegate> {
  NSURLConnection *_connection;
  NSMutableURLRequest *_URLRequest;
}
/**
 * The onComplete to run after a connection is finished
 */
@property (nonatomic, copy) URLResponseBlock onComplete;
@property (nonatomic, retain) NSURLConnection *_connection;
@property (nonatomic, retain) NSMutableURLRequest *_URLRequest;
@property (nonatomic, retain) TODOURLResponse *_response;

/**
 * Opens the connection
 */
- (id)initWithURLRequest:(NSURLRequest *)request onComplete:(URLResponseBlock)onComplete;
/**
 * Opens the connection
 */
- (void)open;

/**
 * Closes the connection
 */
- (void)close;

#pragma mark - Helpers
/**
 * Builds an NSArray object from a JSON NSString object
 */
+ (NSArray *)getNSArrayFromJSONNSString:(NSString *)jsonString;
+ (NSArray *)getNSArrayFromJSONNSData:(NSData *)rawData;

/**
 * Builds POST request body
 */
+ (NSString *)buildQueryString:(NSDictionary *)params;
/**
 * Appends paramters from a dictionary to a URL
 */
+ (NSURL *)appendParametersToURL:(NSURL *)base_url params:(NSDictionary *)params;
/**
 *  Builds a URL Request
 */
+ (NSURLRequest *)buildURLRequest:(NSURL *)url params:(NSDictionary *)params;
+ (NSURLRequest *)buildAuthenticatedURLRequest:(NSURL *)base_url requestMethod:(NSString *)request_method params:(id)params;
@end
