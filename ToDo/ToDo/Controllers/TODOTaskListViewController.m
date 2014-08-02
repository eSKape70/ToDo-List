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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)reloadAllData {
  allTasks = [[NSMutableArray alloc] initWithArray:[Task all]];
}
#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  //TODO
  return [allTasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  //TODO
  Task *task = [allTasks objectAtIndex:indexPath.row];
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TASK_CELL_IDENTIFIER];
  cell.textLabel.text = task.title;
  return cell;
}

@end
