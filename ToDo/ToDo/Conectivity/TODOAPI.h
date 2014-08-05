//
//  TODOAPI.h
//  ToDo
//
//  Created by Gemini - Alex on 04/08/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TODOURLConnection.h"

#define API_HOST              @"https://api.toodledo.com/3"


@interface TODOAPI : NSObject

+ (TODOAPI*)singleton;

//get access token and refresh token
+ (TODOURLConnection *)getAccessToken:(NSDictionary*)params onComplete:(URLResponseBlock)onComplete;
//add an array of tasks
+ (TODOURLConnection *)addTasks:(NSDictionary*)tasks onComplete:(URLResponseBlock)onComplete;
//add an array of tasks
+ (TODOURLConnection *)deleteTasks:(NSDictionary*)tasks onComplete:(URLResponseBlock)onComplete;
//add an array of tasks
+ (TODOURLConnection *)updateTasks:(NSDictionary*)tasks onComplete:(URLResponseBlock)onComplete;
//add an array of tasks
+ (TODOURLConnection *)getTasksOnComplete:(URLResponseBlock)onComplete;
//manage network activity
+ (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible;
@end
