//
//  TODOStorageManager.h
//  ToDo
//
//  Created by Gemini - Alex on 31/07/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Headers.h"

@interface TODOStorageManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (TODOStorageManager*)singleton;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
