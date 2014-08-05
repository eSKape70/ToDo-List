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
- (void)viewWillAppear:(BOOL)animated {
  if (_taskToEdit) {
    [self editTask:_taskToEdit];
  } else {
    [self cleanView];
  }
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
//  [doneBtn.titleLabel setFont:[UIFont TODOFontWithSize:18]];
//  [cancelBtn.titleLabel setFont:[UIFont TODOFontWithSize:18]];
  screenTitle.font = [UIFont TODOFontWithSize:24];
}
-(void)editTask:(Task*)task {
  _taskToEdit = task;

  screenTitle.text = EDIT_TASK;
  taskTitle.text = _taskToEdit.title;
  taskDescription.text = _taskToEdit.note;
  staticLastModified.hidden = NO;
  staticCompleted.hidden = NO;
  completedSwitch.hidden = NO;
  
  NSDateFormatter *df = [[NSDateFormatter alloc] init];
  [df setDateFormat:@"MM-dd HH:mm"];
  [df setLocale:[NSLocale currentLocale]];
  lastModifiedLabel.text = [df stringFromDate:_taskToEdit.modified];
  completedSwitch.on = NO;
  if (_taskToEdit.completed) {
    completedSwitch.on = YES;
  }
    
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
    if ((completedSwitch.on && !_taskToEdit.completed) || (!completedSwitch.on && _taskToEdit.completed)) {
      didChange = YES;
    }
    if (didChange) {
      [[TODOStorageManager singleton] updateTask:_taskToEdit withTitle:taskTitle.text note:taskDescription.text completed:completedSwitch.on];
    }
  }
  else
    [[TODOStorageManager singleton] addTaskWithTitle:taskTitle.text andDescription:taskDescription.text];
  
  [self cancelBtnPressed:nil];
}
-(IBAction)cancelBtnPressed:(id)sender {
  [[TODOContainerViewController singleton] goToListPressed:nil];
}
#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return NO;
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
  screenTitle.text = ADD_TASK;
  taskTitle.text = @"";
  taskDescription.text = @"";
  completedSwitch.on = NO;
  staticLastModified.hidden = YES;
  lastModifiedLabel.text = @"";
  _taskToEdit = nil;
  staticCompleted.hidden = YES;
  completedSwitch.hidden = YES;
}
@end
