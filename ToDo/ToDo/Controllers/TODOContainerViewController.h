//
//  TODOContainerViewController.h
//  ToDo
//
//  Created by Gemini - Alex on 02/08/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TODOContainerViewController : UIViewController {
  IBOutlet UIView *container;
}

+ (TODOContainerViewController*)singleton;

-(IBAction)goToListPressed:(id)sender;
-(IBAction)addTaskPressed:(id)sender;

@end
