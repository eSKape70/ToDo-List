//
//  TODOAppNavigation.m
//  ToDo
//
//  Created by Gemini - Alex on 06/08/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import <KIF/KIF.h>
#import "KIFUITestActor+TODOActor.h"

@interface TODOAppNavigation : KIFTestCase {
}
@end

@implementation TODOAppNavigation

- (void)beforeAll {
}

- (void)beforeEach {
  
}

- (void)afterEach {
  
}

- (void)afterAll {
}
- (void)testHeaderButtons {
  [tester tapViewWithAccessibilityLabel:@"Home Btn" value:nil traits:UIAccessibilityTraitNone];
  [tester waitForViewWithAccessibilityLabel:@"Task List"];
  
  [tester tapViewWithAccessibilityLabel:@"Task Btn" value:nil traits:UIAccessibilityTraitNone];
  [tester waitForViewWithAccessibilityLabel:@"Task View"];
  
  [tester tapViewWithAccessibilityLabel:@"User Btn" value:nil traits:UIAccessibilityTraitNone];
  [tester waitForViewWithAccessibilityLabel:@"User View"];
}

@end
