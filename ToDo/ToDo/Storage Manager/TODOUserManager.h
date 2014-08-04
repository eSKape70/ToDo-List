//
//  TODOUserManager.h
//  ToDo
//
//  Created by Gemini - Alex on 04/08/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@interface TODOUserManager : NSObject

@property (strong, nonatomic) NSMutableString *state;
@property (strong, nonatomic) User *user;

+ (TODOUserManager*)singleton;
- (BOOL)isAuthorized;
- (BOOL)isAuthenticated;
@end
