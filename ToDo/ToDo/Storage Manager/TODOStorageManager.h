//
//  TODOStorageManager.h
//  ToDo
//
//  Created by Gemini - Alex on 31/07/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Task;

@interface TODOStorageManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (TODOStorageManager*)singleton;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)updateTask:(Task*)task withTitle:(NSString*)title note:(NSString*)note completed:(BOOL)completed;
- (void)deleteTask:(Task*)task;
- (void)addTaskWithTitle:(NSString*)taskTitle andDescription:(NSString*)taskDescription;

- (void)syncTasksOnComplete:(void (^)(void))onComplete;
@end
