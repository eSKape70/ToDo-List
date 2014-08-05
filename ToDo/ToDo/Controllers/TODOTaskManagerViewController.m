//
//  TODOTaskManagerViewController.m
//  ToDo
//
//  Created by Gemini - Alex on 02/08/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import "Headers.h"

@interface TODOTaskManagerViewController ()

@property(strong, nonatomic) Task* taskToEdit;

@end

@implementation TODOTaskManagerViewController

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
  [self customiseView];
}
- (void)viewWillDisappear:(BOOL)animated {
  [self hideKeyboard];
}
- (void)viewDidDisappear:(BOOL)animated {
  [self cleanView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)customiseView {
  doneBtn.backgroundColor = [UIColor semiTransparentDarkColor];
  cancelBtn.backgroundColor = [UIColor semiTransparentLightColor];
  [doneBtn.titleLabel setFont:[UIFont TODOFontWithSize:18]];
  [cancelBtn.titleLabel setFont:[UIFont TODOFontWithSize:18]];
  screenTitle.font = [UIFont TODOFontWithSize:24];
}
-(void)editTask:(Task*)task {
  _taskToEdit = task;
  taskTitle.text = _taskToEdit.title;
  taskDescription.text = _taskToEdit.note;
}
#pragma mark - Buttons Actions 

-(IBAction)doneBtnPressed:(id)sender {
  if (![self checkData]) {
    return;
  }
  
  if (_taskToEdit) {
    BOOL didChange = NO;
    if (![_taskToEdit.title isEqualToString:taskTitle.text]) {
      didChange = YES;
    }
    if (![_taskToEdit.note isEqualToString:taskDescription.text]) {
      didChange = YES;
    }
    if (didChange) {
      [[TODOStorageManager singleton] updateTask:_taskToEdit withTitle:taskTitle.text note:taskDescription.text completed:NO];
    }
  }
  else
    [[TODOStorageManager singleton] addTaskWithTitle:taskTitle.text andDescription:taskDescription.text];
  
  [self cancelBtnPressed:nil];
}
-(IBAction)cancelBtnPressed:(id)sender {
  [[TODOContainerViewController singleton] goToListPressed:nil];
}
#pragma mark - Helpers

- (BOOL)checkData {
    //check if task is valid for saving
  if (![taskTitle.text length]) {
    return NO;
  }
  return YES;
}
- (void)hideKeyboard {
  [taskTitle resignFirstResponder];
  [taskDescription resignFirstResponder];
}
- (void)cleanView {
  taskTitle.text = @"";
  taskDescription.text = @"";
  _taskToEdit = nil;
}
@end
