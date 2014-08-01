//
//  Base.h
//  ToDo
//
//  Created by Gemini - Alex on 01/08/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Base : NSManagedObject

/**
 * Returns all objects of this class type
 */
+ (NSArray *)all;

/**
 * Returns all items sorted by the objects in the |sort_items| dictionary
 */
+ (NSArray *)all:(NSDictionary *)sort_items;

/**
 * Returns an array of objects with the given params
 */
+ (NSArray *)find:(NSDictionary *)params;

/**
 * Finds an object with the given params or creates it if it doesn't exist
 */
+ (id)findOrCreate:(NSDictionary *)params;

/**
 * Commits the NSManagedObjectContext, saving ALL objects of ALL types
 * This does not specifically save just this object
 */
- (BOOL)save;

/**
 * Deletes this object and commits the managed object contenxt
 */
- (void)remove;

@end
