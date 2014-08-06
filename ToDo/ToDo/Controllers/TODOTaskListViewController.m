//
//  TODOTaskListViewController.m
//  ToDo
//
//  Created by Gemini - Alex on 01/08/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import "Headers.h"

@interface TODOTaskListViewController ()

@property (strong, nonatomic) NSMutableArray *allTasks;
@property (assign) BOOL shouldSendPercent;
@end

@implementation TODOTaskListViewController

@synthesize tableView;
@synthesize allTasks;

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
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAllData) name:DID_SYNC object:nil];
  //[[TODOStorageManager singleton] syncTasksOnComplete:nil];
  [self reloadAllData];
}
- (void)viewWillAppear:(BOOL)animated {
  [self reloadAllData];
  _shouldSendPercent = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
  _shouldSendPercent = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)reloadAllData {
  allTasks = [[NSMutableArray alloc] initWithArray:[Task find:@{@"toDelete":@(NO)}]];
  [tableView reloadData];
}
#pragma mark - Table View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  //TODO
  return [allTasks count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  Task *task = [allTasks objectAtIndex:indexPath.row];
  if (task.note && [task.note length]) {
    return 60;
  }
  return 40;
}
- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  //TODO
  Task *task = [allTasks objectAtIndex:indexPath.row];
  UITableViewCell *cell;
  if (task.note && [task.note length]) {
    cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:TASK_CELL_IDENTIFIER_NOTE];
    if (!cell)
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TASK_CELL_IDENTIFIER_NOTE];
    
    cell.detailTextLabel.text = task.note;
    if (task.completed)
      cell.detailTextLabel.textColor = [UIColor greenColor];
    else
      cell.detailTextLabel.textColor = [UIColor whiteColor];
  } else {
    cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:TASK_CELL_IDENTIFIER_SIMPLE];
    if (!cell)
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TASK_CELL_IDENTIFIER_SIMPLE];
  }
  [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
  cell.textLabel.text = task.title;

  
  cell.backgroundColor = (indexPath.row%2?[UIColor semiTransparentLightColor]:[UIColor semiTransparentDarkColor]);
  //cell.backgroundColor = [UIColor clearColor];
  if (task.completed) {
    cell.textLabel.textColor = [UIColor greenColor];
  } else {
    cell.textLabel.textColor = [UIColor whiteColor];
  }
  
  if ([cell.contentView.gestureRecognizers count]) {
    for (UIGestureRecognizer *gesture in cell.contentView.gestureRecognizers) {
      [cell.contentView removeGestureRecognizer:gesture];
    }
  }
  if (!task.completed) {
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didCompleteTask:)];
    [swipe setDelegate:self];
    [cell.contentView addGestureRecognizer:swipe];
    cell.contentView.tag = indexPath.row;
  }
  return cell;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (!_shouldSendPercent) {
    return;
  }
  CGFloat percent = scrollView.contentOffset.y/(scrollView.contentSize.height-scrollView.frame.size.height);
  [[TODOContainerViewController singleton] viewDidScrollVerticallyWithPercent:percent];
}

- (void)tableView:(UITableView *)thisTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    Task *task = [allTasks objectAtIndex:indexPath.row];
    task.toAdd = [NSNumber numberWithBool:NO];
    task.toDelete = [NSNumber numberWithBool:YES];
    task.modified = [NSDate new];
    [task save];
    
    [allTasks removeObject:task];
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];

    [[TODOStorageManager singleton] syncTasksOnComplete:nil];
  }
}
- (void)tableView:(UITableView *)thisTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [[TODOContainerViewController singleton] editTask:[allTasks objectAtIndex:indexPath.row]];
}
- (void)didCompleteTask:(UISwipeGestureRecognizer *)gesture {
  NSIndexPath *index = [NSIndexPath indexPathForRow:gesture.view.tag inSection:0];
  Task *task = [allTasks objectAtIndex:index.row];
  task.completed = [NSDate new];
  task.modified = [NSDate new];
  if (!task.toAdd || [task.toAdd boolValue] == NO) {
    task.toUpdate = @(YES);
  }
  [task save];
  [self reloadAllData];
//  [tableView beginUpdates];
//  [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationFade];
//  [tableView endUpdates];
  [[TODOStorageManager singleton] syncTasksOnComplete:nil];
}
@end
