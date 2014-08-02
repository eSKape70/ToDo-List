//
//  Task.h
//  ToDo
//
//  Created by Gemini - Alex on 01/08/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Base.h"

@interface Task : Base

@property (nonatomic, retain) NSString * taskID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * parent;
@property (nonatomic, retain) NSNumber * children;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSDate * duedate;
@property (nonatomic, retain) NSDate * duetime;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * priority;
@property (nonatomic, retain) NSDate * completed;
@property (nonatomic, retain) NSString * note;

@end
