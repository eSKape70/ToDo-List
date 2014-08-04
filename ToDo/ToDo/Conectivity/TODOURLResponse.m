//
//  TODOURLResponse.m
//  ToDo
//
//  Created by Gemini - Alex on 04/08/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import "Headers.h"

@implementation TODOURLResponse

+ (TODOURLResponse *) responseFromHTTPResponse: (NSHTTPURLResponse*)response {
  return [[TODOURLResponse alloc] initWithHTTPResponse:response forConnection:nil];
}
// Returns a new TODOURLResponse based on an NSHTTPURLResponse
+ (TODOURLResponse *) responseFromHTTPResponse: (NSHTTPURLResponse*)response forConnection:(NSURLConnection*)connection
{
  return [[TODOURLResponse alloc] initWithHTTPResponse:response forConnection:connection];
}

// Init
- (id) init{
  self = [super init];
  if (self)
  {
    _successful = NO;
  }
  return self;
}

// Initializes a URLResponse with an NSHTTPURLResponse
- (id) initWithHTTPResponse: (NSHTTPURLResponse*) response forConnection:(NSURLConnection*)connection
{
  self = [super init];
  
  if (self)
  {
    _rawResponse = response;
    
    // Set informaiton from HTTPResponse and data
    _statusCode = (int)response.statusCode;
    _allHeaderFields = [response allHeaderFields];
    _successful = NO;
    
    // Set error message on failure
    if (_statusCode == 200)
    {
      _successful = YES;
    } else
      _successful = NO;
    
    // Set content length and alloc space for data
    NSInteger contentLength = [[_allHeaderFields objectForKey:@"Content-Length"] integerValue];
    
    if (contentLength > 0)
    {
      _rawData = [[NSMutableData alloc] initWithCapacity:contentLength];
    }
    else
    {
      _rawData = [[NSMutableData alloc] init];
    }
  }
  
  // Return self
  return self;
}

// Returns an NSArray parsed from the data (JSON)
- (NSArray *) getDataAsNSArray
{
  return [TODOURLConnection getNSArrayFromJSONNSData:_rawData];
}

@end
