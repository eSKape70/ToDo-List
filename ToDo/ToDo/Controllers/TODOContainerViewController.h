//
//  TODOContainerViewController.h
//  ToDo
//
//  Created by Gemini - Alex on 02/08/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TODOContainerViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *container;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;

+ (TODOContainerViewController*)singleton;

-(IBAction)goToListPressed:(id)sender;
-(IBAction)addTaskPressed:(id)sender;
-(IBAction)goToUserPressed:(id)sender;

-(UIViewController*)currentViewController;

- (void)viewDidScrollVerticallyWithPercent:(CGFloat)percent;
- (void)editTask:(Task*)task;

@end
