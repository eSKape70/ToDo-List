//
//  TODOUserViewController.h
//  ToDo
//
//  Created by Gemini - Alex on 04/08/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TODOUserViewController : UIViewController <UIWebViewDelegate> {
  
}

@property(strong, nonatomic) IBOutlet UIView *webViewContainer;
@property(strong, nonatomic) IBOutlet UIWebView *webView;
@property(strong, nonatomic) IBOutlet UIButton *loginBtn;
@property(strong, nonatomic) IBOutlet UILabel *userEmail;
@property(strong, nonatomic) IBOutlet UILabel *userAlias;
@property(strong, nonatomic) IBOutlet UIButton *staticEmail;
@property(strong, nonatomic) IBOutlet UIButton *staticAlias;

-(IBAction)loginBtnPressed:(id)sender;
-(IBAction)closeWebViewPressed:(id)sender;

@end
