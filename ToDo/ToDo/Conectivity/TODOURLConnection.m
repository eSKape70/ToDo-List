//
//  TODOURLConnection.m
//  ToDo
//
//  Created by Gemini - Alex on 04/08/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import "Headers.h"

@implementation TODOURLConnection

@synthesize _connection;
@synthesize _URLRequest;
@synthesize _response;

- (id)initWithURLRequest:(NSURLRequest *)request onComplete:(URLResponseBlock)onComplete {
  self = [super init];
  
  if (self) {
    // Set blocks
    _onComplete = onComplete;
    
    // Set request
    _URLRequest = (NSMutableURLRequest *)request;

    // Create connection
    _connection = [[NSURLConnection alloc] initWithRequest:_URLRequest delegate:self startImmediately:NO];
  }
  return self;

}
- (void)open {
   [_connection start];
}

- (void)close {
  [_connection cancel];
   _connection = nil;
  _onComplete = nil;
  _response = nil;
}

+ (NSArray *)getNSArrayFromJSONNSString:(NSString *)jsonString {
  NSData *rawData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
  return [self getNSArrayFromJSONNSData:(NSData *)rawData];
}
+ (NSArray *)getNSArrayFromJSONNSData:(NSData *)rawData {
  if (!rawData) {
    return @[];
  }
  
  NSError *jsonError = nil;
  
  // Attempt to read the data
  id jsonObject = [NSJSONSerialization JSONObjectWithData:rawData options:kNilOptions error:&jsonError];
  
  if (jsonError) {
    return @[];
  }
  
  NSArray *jsonData;
  
  // If the data was a dictionary put it in an array so we can have one unified type to return
  if ([jsonObject isKindOfClass:[NSArray class]]) {
    jsonData = (NSArray *)jsonObject;
  } else {
    jsonData = @[(NSDictionary *)jsonObject];
  }
  
  return jsonData;
}
+ (id)destroyNullJSONObjects:(id)jsonObject {
  
  // If object is null return nil
  if ([jsonObject isKindOfClass:[NSNull class]]) {
    jsonObject = nil;
  }
  
  // If object is a dictionary parse it's keys
  if ([jsonObject isKindOfClass:[NSDictionary class]]) {
    NSMutableDictionary *mutableJSONObjectDict = [jsonObject mutableCopy];
    
    for (id key in [jsonObject allKeys]) {
      // Process object and get it's cleaned value
      id cleanValue = [TODOURLConnection destroyNullJSONObjects:[jsonObject objectForKey:key]];
      
      // Remove key from dictionary if it's blank
      if (!cleanValue) {
        [mutableJSONObjectDict removeObjectForKey:key];
      } else {
        [mutableJSONObjectDict setValue:cleanValue forKey:key];
      }
    }
    
    jsonObject = (NSDictionary *)mutableJSONObjectDict;
  }
  
  // If object is an array parse it's contents
  if ([jsonObject isKindOfClass:[NSArray class]]) {
    NSMutableArray *cleanArray = [[NSMutableArray alloc] init];
    
    for (id value in jsonObject) {
      // Get claned array value
      id cleanValue = [TODOURLConnection destroyNullJSONObjects:value];
      
      // Add object to cleaned array
      if (cleanValue) {
        [cleanArray addObject:cleanValue];
      }
    }
    
    jsonObject = (NSArray *)cleanArray;
  }
  
  return jsonObject;
}

+ (NSString *)buildQueryString:(NSDictionary *)params {
  NSString *result;
  
  if (params.count > 0) {
    NSMutableString *queryString = [[NSMutableString alloc] init];
    
    for (NSString *key in params) {
      
      // Get URL safe escaped value
      id valueObject = [params objectForKey:key];
      
      if ([valueObject isKindOfClass:[NSArray class]]) {
        // Process array values in params
        for (id item in(NSArray *) valueObject) {
          if([item isKindOfClass:[NSString class]]){
            NSString *value = [item stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            queryString = (NSMutableString *)[queryString stringByAppendingString:@"&"];
            queryString = (NSMutableString *)[queryString stringByAppendingString:key];
            queryString = (NSMutableString *)[queryString stringByAppendingString:@"="];
            queryString = (NSMutableString *)[queryString stringByAppendingString:value];
          }
          //          if([item isKindOfClass:[NSDictionary class]]){
          //            //json encode string
          //            NSError *error;
          //            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:valueObject
          //                                                               options:NSJSONWritingPrettyPrinted
          //                                                                 error:&error];
          //            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
          //          }
        }
      } else if ([valueObject isKindOfClass:[NSNumber class]]) {
        NSString *value;
        
        // Compare the type of NSNumbers and make BOOLs true/false JSON data values
        if (strcmp([valueObject objCType], @encode(BOOL)) == 0) {
          value = [valueObject boolValue] ? @"true" : @"false";
        } else {
          value = [NSString stringWithFormat:@"%d", [valueObject intValue]];
        }
        
        queryString = (NSMutableString *)[queryString stringByAppendingString:@"&"];
        queryString = (NSMutableString *)[queryString stringByAppendingString:key];
        queryString = (NSMutableString *)[queryString stringByAppendingString:@"="];
        queryString = (NSMutableString *)[queryString stringByAppendingString:value];
      } else {
        NSString *value;
        
        if ([[params objectForKey:key] isKindOfClass:[NSString class]]) {
          value = [[params objectForKey:key] URLEncodedString];
        } else {
          if([[params objectForKey:key] isKindOfClass:[NSString class]])
            value = [[[params objectForKey:key] stringValue] URLEncodedString];
        }
        if(value){
          queryString = (NSMutableString *)[queryString stringByAppendingString:@"&"];
          queryString = (NSMutableString *)[queryString stringByAppendingString:key];
          queryString = (NSMutableString *)[queryString stringByAppendingString:@"="];
          queryString = (NSMutableString *)[queryString stringByAppendingString:value];
        }
      }
    }
    
    if (queryString.length) {
      result = [queryString substringFromIndex:1];
    } else {
      result = @"";
    }
  } else {
    result = @"";
  }
  return result;
}

+ (NSURL *)appendParametersToURL:(NSURL *)base_url params:(NSDictionary *)params {
  NSURL *url;
  NSString *paramString = [self buildQueryString:params];
  
  //fix for adding "?" at the end if no params exist
  if ([params count]==0) {
    url=base_url;
  }
  else{
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", base_url, [[base_url absoluteString] rangeOfString:@"?"].location == NSNotFound ? @"?" : @"&" , paramString]];
  }
  
  return url;
}

+ (NSURLRequest *)buildAuthenticatedURLRequest:(NSURL *)base_url requestMethod:(NSString *)request_method params:(id)params {
  NSURL *url;
  
  // Create request
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:base_url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:REQUEST_TIMEOUT];
  
  // Set request timeout
  request.timeoutInterval = REQUEST_TIMEOUT;
  
  // Set post information
  if ([request_method isEqualToString:@"POST"]) {
    // Set request and content type
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", APP_ID, API_SECRET];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    // Build body from query string
    NSData *body = [[TODOURLConnection buildQueryString:params] dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:body];
    
    url = base_url;
  } else if (params && [params isKindOfClass:[NSDictionary class]]) {
    url = [TODOURLConnection appendParametersToURL:base_url params:params];
  } else {
    url = base_url;
  }
  
  // Set request URL
  [request setURL:url];
  
  
  // Set request method
  if (request_method) {
    [request setHTTPMethod:request_method];
  }
  
  // Return request
  return [request copy];
}

+ (NSURLRequest *)buildURLRequest:(NSURL *)url params:(NSDictionary *)params {
  // Add params
  if (params) {
    url = [TODOURLConnection appendParametersToURL:url params:params];
  }
  
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  request.timeoutInterval = REQUEST_TIMEOUT;
  
  return [request copy];
}

#pragma mark - URLConnection Delegate

- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSHTTPURLResponse *)aResponse {
  _response = [TODOURLResponse responseFromHTTPResponse:aResponse forConnection:aConnection];
}

/**
 * Recieves a chunk of data and stores it
 */
- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)newData {
  [_response.rawData appendData:newData];
}

/**
 * Fails with error
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  if (_response == nil) {
    _response = [[TODOURLResponse alloc] init];
  }
  
  _response.successful = NO;
  _response.rawData = [[error.description dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
  _response.error = error;
  [TODOAPI setNetworkActivityIndicatorVisible:NO];
  
  _onComplete(_response);
}

/**
 * Fires when the connection has finished loading
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
  
  [TODOAPI setNetworkActivityIndicatorVisible:NO];
  
  if (_response != nil) {
    // Cache successful responses
    if (_response.successful) {
      
      NSLog(@"************* RESPONSE: ****************\n%@ for %@", _response,_URLRequest);
      
      // Fire oncomplete if one was provided
      if (_onComplete)
      {
        _onComplete(_response);
      }
    }
    // Close all remaining connection elements
    [self close];
  }
}

@end
