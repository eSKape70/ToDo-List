//
//  TODOAPI.m
//  ToDo
//
//  Created by Gemini - Alex on 04/08/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import "Headers.h"

@implementation TODOAPI

+ (TODOAPI*)singleton{
  static dispatch_once_t pred;
  static TODOAPI* shared = nil;
  dispatch_once(&pred, ^{
    shared = [[TODOAPI alloc] init];
  });
  return shared;
}

+ (TODOURLConnection *)getAccessToken:(NSDictionary*)params onComplete:(URLResponseBlock)onComplete {
  return [self makeAPICall:@"/account/token.php"
                    params:params
             requires_auth:YES
            request_method:@"POST"
                onComplete:onComplete];
}

+ (TODOURLConnection *)makeAPICall:(NSString *)api_method onComplete:(URLResponseBlock)onComplete {
  return [self makeAPICall:api_method params:nil requires_auth:NO request_method:nil onComplete:onComplete];
}
+ (TODOURLConnection *)makeAPICall:(NSString *)api_method params:(id)params requires_auth:(BOOL)requires_auth request_method:(NSString *)request_method onComplete:(URLResponseBlock)onComplete{
  
  if (requires_auth && [[TODOUserManager singleton] isAuthenticated]) {
    NSString *token = [TODOUserManager singleton].user.access_token;
    [params addObject:token];
  }
  if (requires_auth && ![[TODOUserManager singleton] isAuthenticated] && [[TODOUserManager singleton] isAuthorized]) {
    [params setObject:[TODOUserManager singleton].user.code forKey:@"code"];
    [params setObject:@"authorization_code" forKey:@"grant_type"];
  }
  NSString *currentApiHost = [self buildHost:api_method];
  NSURL *url = [NSURL URLWithString:currentApiHost];
  
  NSURLRequest *request = (requires_auth && [[TODOUserManager singleton] isAuthorized]) ? [TODOURLConnection buildAuthenticatedURLRequest:url requestMethod:request_method params:params] : [TODOURLConnection buildURLRequest:url params:params];
  
  TODOURLConnection *connection = [[TODOURLConnection alloc] initWithURLRequest:request onComplete:onComplete];
  NSLog(@"%@",[[request URL] absoluteString]);
  [connection open];
  
  [self setNetworkActivityIndicatorVisible:YES];
  
  return connection;

}

#pragma mark - Helpers
+ (NSString *)buildHost:(NSString *)method {
  return [NSString stringWithFormat:@"%@%@",API_HOST,method];
}

+ (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible {
  static NSInteger NumberOfCallsToSetVisible = 0;
  if (setVisible)
    NumberOfCallsToSetVisible = MAX(NumberOfCallsToSetVisible + 1,1);
  else
    NumberOfCallsToSetVisible = MAX(NumberOfCallsToSetVisible - 1, 0);
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:(NumberOfCallsToSetVisible > 0)];
}


@end
