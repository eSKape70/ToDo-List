//
//  Base.m
//  ToDo
//
//  Created by Gemini - Alex on 01/08/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import "Headers.h"

@implementation Base

// Create a new model object based off of the table
// Example:  User *user = [User new];
+ (id) new
{
  NSString *name = NSStringFromClass ([self class]);
  NSEntityDescription *entityDescription = [NSEntityDescription entityForName:name inManagedObjectContext:[TODOStorageManager singleton].managedObjectContext];
  id newObject = [[self alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:[TODOStorageManager singleton].managedObjectContext];
  
  return newObject;
}

+ (NSArray *)all
{
  NSString *name = NSStringFromClass ([self class]);
  //set the request
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:[TODOStorageManager singleton].managedObjectContext];
  [request setEntity:entity];
  
  
  //execute the request
  NSError *error = nil;
  NSMutableArray *mutableFetchResults = [[[TODOStorageManager singleton].managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
  if (mutableFetchResults == nil) {
    // Handle the error.
    return [NSMutableArray arrayWithArray:@[]];
  } else {
    return [mutableFetchResults copy];
  }
}

+ (NSArray *)all:(NSDictionary*)sort_items
{
  NSString *name = NSStringFromClass ([self class]);
  //set the request
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:[TODOStorageManager singleton].managedObjectContext];
  [request setEntity:entity];
  
  //set the sort descriptor
  [request setSortDescriptors: [self getSortDescriptorsFromDictionary:sort_items] ];
  
  //execute the request
  NSError *error = nil;
  NSMutableArray *mutableFetchResults = [[[TODOStorageManager singleton].managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
  if (mutableFetchResults == nil) {
    // Handle the error.
    return @[];
  } else {
    return [mutableFetchResults copy];
  }
}

+ (id)findOrCreate:(NSDictionary *)params
{
  id object;
  NSArray *objects = [[self class] find:params];
  
  if ([objects count] > 0)
  {
    // Return first object
    object = objects[0];
  }
  else
  {
    // Create new object
    object = [[self class] new];
    
    // Set parameters
    for (NSString* key in params) {
      id value = [params objectForKey:key];
      
      [object setValue:value forKey:key];
    }
  }
  
  return object;
}
+ (id)create {
  id object = [[self class] new];
  return object;
}
+ (NSArray *)find:(NSDictionary *)params
{
  NSMutableArray* values = [[NSMutableArray alloc] init];
  NSMutableString *where_clause = [NSMutableString stringWithString:@""];
  
  
  for (NSString *key in [params allKeys])
  {
    NSString *value = [params objectForKey:key];
    
    if ([where_clause length] == 0)
      [where_clause appendString:[NSString stringWithFormat:@"%@ = %%@",key]];
    else
      [where_clause appendString:[NSString stringWithFormat:@" and %@ = %%@",key]];
    
    [values addObject:value];
  }
  
  return [[self class] find:where_clause withValues:[values copy]];
}

- (BOOL)save
{
  NSError *error = nil;
  if (![[TODOStorageManager singleton].managedObjectContext save:&error]) {
    return NO;
  }
  return YES;
}

- (void)remove
{
  [[TODOStorageManager singleton].managedObjectContext deleteObject:self];
  [self save];
}
#pragma mark - Helpers 

+ (NSMutableArray *) getSortDescriptorsFromDictionary:(NSDictionary *)sort_items
{
  NSMutableArray *sortDescriptors = [NSMutableArray array];
  for(NSString *key in sort_items) {
    bool ascending = (bool) [[sort_items objectForKey:key] integerValue];
    [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:key ascending:ascending]];
  }
  return sortDescriptors;
}

+ (NSArray *) find:(NSString *)where_clause withValues:(NSArray*)arguments
{
  if (where_clause.length == 0) return nil ;
  if (arguments.count == 0) return nil ;
  NSString *name = NSStringFromClass ([self class]);
  
  //set the request
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:[TODOStorageManager singleton].managedObjectContext];
  [request setEntity:entity];
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:where_clause argumentArray:arguments];
  [request setPredicate:predicate];
  
  //execute the request
  NSError *error = nil;
  NSMutableArray *mutableFetchResults;
  mutableFetchResults = [[[TODOStorageManager singleton].managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
  
  if (mutableFetchResults == nil) {
    // Handle the error.
    return @[];
  } else {
    return [mutableFetchResults copy];
  }
}
+ (NSArray*)getDictionariesFromTasks:(NSArray*)objects {
  NSMutableArray *array = [NSMutableArray new];
  for (Task *task in objects) {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:task.title forKey:@"title"];
    if (task.note) {
      [dict setObject:task.note forKey:@"note"];
    }
    if (task.completed) {
      [dict setObject:task.completed forKey:@"completed"];
    }
    if (task.taskID) {
      [dict setObject:task.taskID forKey:@"id"];
    }
    [array addObject:dict];
  }
  return [NSArray arrayWithArray:array];
}
@end
