//
//  TODOTaskListViewController.h
//  ToDo
//
//  Created by Gemini - Alex on 01/08/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TODOTaskListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
  
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
