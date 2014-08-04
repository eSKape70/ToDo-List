//
//  TODOURLResponse.h
//  ToDo
//
//  Created by Gemini - Alex on 04/08/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TODOURLResponse : NSObject
/**
 * The raw URLResponse received, generally this isn't referenced outside this class but it is
 * made available just in case
 */
@property (nonatomic, retain) NSHTTPURLResponse *rawResponse;

/**
 * The raw NSData received, generally this isn't referenced outside this class but it is
 * made available just in case
 */
@property (nonatomic, retain) NSMutableData *rawData;

@property (nonatomic, retain) NSError *error;

/**
 * A relevant error message based on the status code
 */
@property (nonatomic, readonly) NSString *errorMessage;

/**
 * The HTTP status code
 */
@property (nonatomic, readonly) int statusCode;

/**
 * The header fields of the response
 */
@property (nonatomic, readonly) NSDictionary *allHeaderFields;

/**
 * Was the call successful
 */
@property BOOL successful;


#pragma mark - Instance Methods

/**
 * Returns an NSArrray version of the data.
 * JSON Dictionaries come back in the form @[@{}]
 */
- (NSArray *) getDataAsNSArray;

/**
 * inits a URLResponse from an NSHTTPURLResponse
 */
- (id) initWithHTTPResponse: (NSHTTPURLResponse*) response forConnection:(NSURLConnection*)connection;

#pragma mark - Class Methods
/**
 * Builds a URLResponse from an NSHTTPURLResponse
 */
+ (TODOURLResponse *) responseFromHTTPResponse: (NSHTTPURLResponse*) response;
+ (TODOURLResponse *) responseFromHTTPResponse: (NSHTTPURLResponse*) response forConnection:(NSURLConnection*)connection;


@end
