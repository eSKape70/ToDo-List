//
//  TODOStorageManager.m
//  ToDo
//
//  Created by Gemini - Alex on 31/07/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import "Headers.h"

@implementation TODOStorageManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Core Data stack

+ (TODOStorageManager*)singleton{
  static dispatch_once_t pred;
  static TODOStorageManager* shared = nil;
  dispatch_once(&pred, ^{
    shared = [[TODOStorageManager alloc] init];
    [shared persistentStoreCoordinator];
  });
  return shared;
}

#pragma mark - Persistance

- (void)saveContext
{
  NSError *error = nil;
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  if (managedObjectContext != nil) {
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
      // Replace this implementation with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
  if (_managedObjectContext != nil) {
    return _managedObjectContext;
  }
  
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (coordinator != nil) {
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
  }
  return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
  if (_managedObjectModel != nil) {
    return _managedObjectModel;
  }
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
  _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
  if (_persistentStoreCoordinator != nil) {
    return _persistentStoreCoordinator;
  }
  
  NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
  
  NSError *error = nil;
  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
    /*
     Replace this implementation with code to handle the error appropriately.
     
     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
     
     Typical reasons for an error here include:
     * The persistent store is not accessible;
     * The schema for the persistent store is incompatible with current managed object model.
     Check the error message to determine what the actual problem was.
     
     
     If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
     
     If you encounter schema incompatibility errors during development, you can reduce their frequency by:
     * Simply deleting the existing store:
     [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
     
     * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
     @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
     
     Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
     
     */
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
  
  return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Task Manager

- (void)updateTask:(Task*)task withTitle:(NSString*)title note:(NSString*)note completed:(BOOL)completed {
  task.title = title;
  task.note = note;
  if(completed)
    task.completed = [NSDate new];
  else
    task.completed = nil;
  task.modified = [NSDate new];
  if (![task.toAdd boolValue]) {
    task.toUpdate = @(YES);
  }
  [task save];
  [self syncTasksOnComplete:nil];
}
- (void)deleteTask:(Task*)task {
  if (!task.taskID || ![task.taskID length]) {
    [task remove];
    [self syncTasksOnComplete:nil];
    return;
  }
  task.toDelete = @(YES);
  task.toAdd = @(NO);
  task.toUpdate = @(NO);
  [task save];
  [self syncTasksOnComplete:nil];
}
- (void)addTaskWithTitle:(NSString*)taskTitle andDescription:(NSString*)taskDescription {
  Task* task = [Task new];
  task.title = taskTitle;
  task.note = taskDescription;
  task.modified = [NSDate new];
  task.toAdd = @(YES);
  task.toDelete = @(NO);
  task.toUpdate = @(NO);
  [task save];
  [self syncTasksOnComplete:nil];
}
- (void)syncTasksOnComplete:(void (^)(void))onComplete {
  if (![[TODOUserManager singleton] isAuthenticated]) {
    return;
  }
  //delete all
  NSArray *tasksToDelete = [Task find:@{@"toDelete":@(YES)}];
  NSMutableArray *idsToDelete = [NSMutableArray new];
  for (Task *task in tasksToDelete) {
    [idsToDelete addObject:task.taskID];
  }
  NSMutableDictionary *toDelete = nil;
  if ([idsToDelete count]) {
    toDelete = [[NSMutableDictionary alloc] init];
    [toDelete setObject:idsToDelete forKey:@"tasks="];
  }
  [TODOAPI deleteTasks:toDelete onComplete:^(TODOURLResponse *response){
    if (response.successful) {
      //edit all
      for (Task *task in tasksToDelete) {
        task.toDelete = nil;
        [task save];
      }
      NSArray *tasksToUpdate = [Base getDictionariesFromTasks:[Task find:@{@"toUpdate":@(YES)}]];
      NSMutableDictionary *toUpdate = nil;
      if ([tasksToUpdate count]) {
        toUpdate = [[NSMutableDictionary alloc] init];
        [toUpdate setObject:tasksToUpdate forKey:@"tasks="];
      }
      [TODOAPI updateTasks:toUpdate onComplete:^(TODOURLResponse *response){
        if (response.successful) {
          //add all
          NSArray *tasksToClean = [Task find:@{@"toUpdate":@(YES)}];
          for (Task *task in tasksToClean) {
            task.toUpdate = nil;
            [task save];
          }
          NSArray *tasksToAdd = [Base getDictionariesFromTasks:[Task find:@{@"toAdd":@(YES)}]];
          NSMutableDictionary *toAdd = nil;
          if ([tasksToAdd count]) {
            toAdd = [[NSMutableDictionary alloc] init];
            [toAdd setObject:tasksToAdd forKey:@"tasks="];
          }
          [TODOAPI addTasks:toAdd onComplete:^(TODOURLResponse *response){
            if (response.successful) {
              NSArray *tasksToClean = [Task find:@{@"toAdd":@(YES)}];
              for (Task *task in tasksToClean) {
                task.toAdd = nil;
                [task save];
              }
              //get synced list from server
              [TODOAPI getTasksOnComplete:^(TODOURLResponse *response){
                if (response.successful) {
                  for (Task *task in [Task all]) {
                    [task remove];
                  }
                  NSArray *tasksAdded = [response getDataAsNSArray];
                  for (NSDictionary *dict in tasksAdded) {
                    if ([[dict allKeys] count]<4) {
                      continue;
                    }
                    Task *task = [Task new];
                    task.title = [dict objectForKey:@"title"];
                    task.note = [dict objectForKey:@"note"];
                    task.taskID = [[dict objectForKey:@"id"] stringValue];
                    task.modified = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"modified"] intValue]];
                    if([[dict objectForKey:@"completed"] intValue])
                      task.completed = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"completed"] intValue]];
                    task.toDelete = @(NO);
                    task.toUpdate = @(NO);
                    task.toAdd = @(NO);
                    [task save];
                  }
                  [[NSNotificationCenter defaultCenter] postNotificationName:DID_SYNC object:nil];
                } else
                  NSLog(@"could not get tasks");
              }];
            } else
              NSLog(@"could not add tasks");
          }];
        } else
          NSLog(@"could not update tasks");
      }];
    } else
      NSLog(@"could not delete tasks");
  }];

    //get all
}
@end
