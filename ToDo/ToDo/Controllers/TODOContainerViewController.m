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
  TODOUserViewController *userVC;
  
  BOOL isSwitchingVC;
  UIViewController *currentDetailViewController;
}
@end

@implementation TODOContainerViewController

+ (TODOContainerViewController*)singleton{
  static dispatch_once_t pred;
  static TODOContainerViewController* shared = nil;
  dispatch_once(&pred, ^{
    shared = [[TODOContainerViewController alloc] initWithNibName:@"TODOContainerViewController" bundle:nil];
  });
  return shared;
}

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
  [self goToListPressed:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)editTask:(Task*)task {
  if (!taskManagerVC) {
    taskManagerVC = [[TODOTaskManagerViewController alloc] initWithNibName:@"TODOTaskManagerViewController" bundle:nil];
  }
  [taskManagerVC editTask:task];
  [self addTaskPressed:nil];
}
#pragma mark - App Navigation Logic

- (void)swapCurrentControllerWith:(UIViewController*)viewController{
  if (!currentDetailViewController) {
    viewController.view.frame = CGRectMake(0, 0, container.bounds.size.width, container.bounds.size.height);
    [container addSubview:viewController.view];
    currentDetailViewController = viewController;
    return;
  }
  if (isSwitchingVC || currentDetailViewController==viewController) {
    return;
  }
  isSwitchingVC = YES;
  viewController.view.frame = CGRectMake(0, 0, container.bounds.size.width, container.bounds.size.height);
  viewController.view.alpha = 0.0;
  [container addSubview:viewController.view];
  
  [currentDetailViewController viewWillDisappear:YES];
  [viewController viewWillAppear:YES];
  
  [UIView animateWithDuration:.3
                   animations:^{
                     currentDetailViewController.view.alpha = 0.0;
                     viewController.view.alpha = 1.0;
                   } completion:^(BOOL finished) {
                     [currentDetailViewController viewDidDisappear:YES];
                     [currentDetailViewController.view removeFromSuperview];
                     currentDetailViewController = viewController;
                     isSwitchingVC = NO;
                   }];
}

#pragma mark - Header Actions 

-(IBAction)goToListPressed:(id)sender {
  if (!taskListVC) {
    taskListVC = [[TODOTaskListViewController alloc] initWithNibName:@"TODOTaskListViewController" bundle:nil];
  }
  [_backgroundImage horizontallyAdjustLayerForPercent:0.0];
  [self swapCurrentControllerWith:taskListVC];
}

-(IBAction)addTaskPressed:(id)sender {
  if (!taskManagerVC) {
    taskManagerVC = [[TODOTaskManagerViewController alloc] initWithNibName:@"TODOTaskManagerViewController" bundle:nil];
  }
  [_backgroundImage horizontallyAdjustLayerForPercent:0.33];

  [self swapCurrentControllerWith:taskManagerVC];
}

-(IBAction)goToUserPressed:(id)sender {
  if (!userVC) {
    userVC = [[TODOUserViewController alloc] initWithNibName:@"TODOUserViewController" bundle:nil];
  }
  [_backgroundImage horizontallyAdjustLayerForPercent:0.66];
  [self swapCurrentControllerWith:userVC];
}
#pragma mark - Background Effect

-(void)viewDidScrollVerticallyWithPercent:(CGFloat)percent {
  [_backgroundImage verticallyAdjustLayerForPercent:percent];
}
@end
