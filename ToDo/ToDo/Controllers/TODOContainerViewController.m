//
//  TODOContainerViewController.m
//  ToDo
//
//  Created by Gemini - Alex on 02/08/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import "Headers.h"

@interface TODOContainerViewController () {

  TODOTaskListViewController *taskListVC;
  TODOTaskManagerViewController *taskManagerVC;
  
  BOOL isSwitchingVC;
  UIViewController *currentDetailViewController;
}
@end

@implementation TODOContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - App Navigation Logic

- (void)swapCurrentControllerWith:(UIViewController*)viewController{
  if (!currentDetailViewController) {
    viewController.view.frame = CGRectMake(0, 0, container.bounds.size.width, container.bounds.size.height);
    [container addSubview:viewController.view];
    currentDetailViewController = viewController;
    return;
  }
  if (isSwitchingVC) {
    return;
  }
  isSwitchingVC = YES;
  [viewController willMoveToParentViewController:nil];
  viewController.view.frame = CGRectMake(0, 0, container.bounds.size.width, container.bounds.size.height);
  viewController.view.alpha = 0.0;
  [container addSubview:viewController.view];
  
  [UIView animateWithDuration:.3
                   animations:^{
                     currentDetailViewController.view.alpha = 0.0;
                     viewController.view.alpha = 1.0;
                   } completion:^(BOOL finished) {
                     currentDetailViewController = viewController;
                     isSwitchingVC = NO;
                   }];
}

#pragma mark - Header Actions 

-(IBAction)goToListPressed:(id)sender {
  if (!taskListVC) {
    taskListVC = [[TODOTaskListViewController alloc] initWithNibName:@"TODOTaskListViewController" bundle:nil];
  }
  [self swapCurrentControllerWith:taskListVC];
}

-(IBAction)addTaskPressed:(id)sender {
  if (!taskManagerVC) {
    taskManagerVC = [[TODOTaskManagerViewController alloc] initWithNibName:@"TODOTaskManagerViewController" bundle:nil];
  }
  [self swapCurrentControllerWith:taskManagerVC];
}
@end