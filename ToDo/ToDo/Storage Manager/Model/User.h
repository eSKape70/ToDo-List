//
//  User.h
//  ToDo
//
//  Created by Gemini - Alex on 04/08/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Base.h"

@interface User : Base

@property (nonatomic, retain) NSString * alias;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * access_token;
@property (nonatomic, retain) NSString * refresh_token;
@property (nonatomic, retain) NSString * code;

@end
