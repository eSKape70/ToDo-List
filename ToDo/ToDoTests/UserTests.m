//
//  Base.m
//  ToDo
//
//  Created by Gemini - Alex on 01/08/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Headers.h"

@interface UserTests : XCTestCase

@end

@implementation UserTests

- (void)setUp
{
  NSLog(@"setUp");
  [super setUp];
  [TODOStorageManager singleton];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
  
  NSLog(@"tearDown");
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testCreate {
  User *user = [User new];
  user.alias = @"alias1";
  user.email = @"email1";
  [user save];
  XCTAssertNotNil(user, @"new issue");
}

- (void)testFindOrCreate {
  User *user = [User findOrCreate:@{@"userID":@"testID"}];
  user.alias = @"alias1";
  user.email = @"email1";
  [user save];
  XCTAssertNotNil(user, @"findOrCreate issue");
}

- (void)testGetAll {
  User *user = [User findOrCreate:@{@"userID":@"testID"}];
  [user save];
  NSArray *allUsers = [User all];
  XCTAssert([allUsers count], @"all issue");
}

- (void)testFind {
  User *user = [User findOrCreate:@{@"userID":@"testID"}];
  [user save];
  NSArray *users = [User find:@{@"userID":@"testID"}];
  XCTAssert([users count], @"find issue");
}

@end
