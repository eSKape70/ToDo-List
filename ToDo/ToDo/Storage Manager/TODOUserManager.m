//
//  TODOUserManager.m
//  ToDo
//
//  Created by Gemini - Alex on 04/08/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import "Headers.h"

@implementation TODOUserManager

+ (TODOUserManager*)singleton{
  static dispatch_once_t pred;
  static TODOUserManager* shared = nil;
  dispatch_once(&pred, ^{
    shared = [[TODOUserManager alloc] init];
    if ([[User all] count]) {
      shared.user = [[User all] lastObject];
    } else
      shared.user = [User new];
  });
  return shared;
}
- (BOOL)isAuthenticated {
  return self.user.access_token && [self.user.access_token length];
}
- (BOOL)isAuthorized {
  return self.user.code && [self.user.code length];
}
@end
