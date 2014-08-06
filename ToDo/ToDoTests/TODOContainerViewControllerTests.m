//
//  TODOContainerViewControllerTests.m
//  ToDo
//
//  Created by Gemini - Alex on 06/08/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Headers.h"
#import <objc/runtime.h>

@interface TODOContainerViewControllerTests : XCTestCase {
  TODOContainerViewController *viewController;
}

@end

@implementation TODOContainerViewControllerTests

- (void)setUp
{
  NSLog(@"setUp");
  [super setUp];
	viewController = [[TODOContainerViewController alloc] initWithNibName:@"TODOContainerViewController" bundle:nil];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
  
  NSLog(@"tearDown");
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  viewController = nil;
  [super tearDown];
}
- (void)testLoadView
{
	[viewController loadView];
	
	XCTAssertTrue([viewController isViewLoaded], @"View failed to load");
  XCTAssertNotNil(viewController.backgroundImage, @"background image issue");
  XCTAssertNotNil(viewController.container, @"container issue");
	
  [viewController viewDidLoad];
  
	XCTAssertTrue([[viewController currentViewController] isKindOfClass:[TODOTaskListViewController class]], @"wrong view loaded at start");

}

- (void)testSwapControllers
{
	[viewController loadView];
  [viewController viewDidLoad];
	XCTAssertTrue([[viewController currentViewController] isKindOfClass:[TODOTaskListViewController class]], @"wrong view loaded at start");
  
  [viewController goToListPressed:nil];
  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.5]];
  XCTAssertTrue([[viewController currentViewController] isKindOfClass:[TODOTaskListViewController class]], @"wrong controller");
  [viewController addTaskPressed:nil];
  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.5]];
  XCTAssertTrue([[viewController currentViewController] isKindOfClass:[TODOTaskManagerViewController class]], @"wrong controller");
  [viewController goToUserPressed:nil];
  [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.5]];
  XCTAssertTrue([[viewController currentViewController] isKindOfClass:[TODOUserViewController class]], @"wrong controller");
}

@end
