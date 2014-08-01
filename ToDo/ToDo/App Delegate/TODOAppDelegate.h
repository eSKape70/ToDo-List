//
//  TODOAppDelegate.h
//  ToDo
//
//  Created by Gemini - Alex on 31/07/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TODOAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
