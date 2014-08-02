//
//  TODOTaskManagerViewController.m
//  ToDo
//
//  Created by Gemini - Alex on 02/08/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import "Headers.h"

@interface TODOTaskManagerViewController ()

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)customiseView {
  doneBtn.backgroundColor = [UIColor lightGrayColor];
  cancelBtn.backgroundColor = [UIColor darkGrayColor];
  [doneBtn.titleLabel setFont:[UIFont TODOFontWithSize:18]];
  [cancelBtn.titleLabel setFont:[UIFont TODOFontWithSize:18]];
  screenTitle.font = [UIFont TODOFontWithSize:24];
}

#pragma mark - Buttons Actions 

-(IBAction)doneBtnPressed:(id)sender {
  
}
-(IBAction)cancelBtnPressed:(id)sender {
  
}

@end
