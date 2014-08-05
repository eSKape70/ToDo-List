//
//  TODOTaskManagerViewController.h
//  ToDo
//
//  Created by Gemini - Alex on 02/08/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TODOTaskManagerViewController : UIViewController <UITextFieldDelegate>{
  IBOutlet UILabel *screenTitle;
  IBOutlet UITextField *taskTitle;
  IBOutlet UITextField *taskDescription;
  IBOutlet UIButton *doneBtn;
  IBOutlet UIButton *cancelBtn;
  IBOutlet UISwitch *completedSwitch;
  IBOutlet UILabel *lastModifiedLabel;
  IBOutlet UILabel *staticLastModified;
  IBOutlet UILabel *staticCompleted;
}

-(IBAction)doneBtnPressed:(id)sender;
-(IBAction)cancelBtnPressed:(id)sender;
-(void)editTask:(Task*)task;

@end
