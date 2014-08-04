//
//  TODOUserViewController.m
//  ToDo
//
//  Created by Gemini - Alex on 04/08/14.
//  Copyright (c) 2014 Stan Alexandru. All rights reserved.
//

#import "Headers.h"

@interface TODOUserViewController ()

@end

@implementation TODOUserViewController

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
  //[self prepareView];
}
- (void)prepareView {
  if ([[TODOUserManager singleton] isAuthorized]) {
    _authorizeBtn.hidden = YES;
  }
  if ([[TODOUserManager singleton] isAuthenticated]) {
    _loginBtn.hidden = YES;
  }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
-(IBAction)authorizeBtnPressed:(id)sender {
  [self loadWebView];
  [self.view addSubview:_webViewContainer];
}
-(IBAction)loginBtnPressed:(id)sender {
  NSMutableDictionary *params = [NSMutableDictionary new];
  [TODOAPI getAccessToken:params onComplete:^(TODOURLResponse *response) {
    if (response.successful) {
      NSDictionary *userData = [response getDataAsNSArray][0];
      [TODOUserManager singleton].user.access_token = [userData objectForKey:@"access_token"];
      [TODOUserManager singleton].user.refresh_token = [userData objectForKey:@"refresh_token"];
      [[TODOUserManager singleton].user save];
    } else
      NSLog(@"could not login");
    [self prepareView];
  }];
}
-(IBAction)closeWebViewPressed:(id)sender {
  [self prepareView];
  [_webViewContainer removeFromSuperview];
}

#pragma mark UIWebView delegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  
  /**
   *  If we're receiving a request response from the Toodledo api host..
   */
  if([request.URL.absoluteString rangeOfString:[NSString stringWithFormat:@"state=%@", [TODOUserManager singleton].state]].location != NSNotFound) {
    
    /**
     *  And the response contains a code..
     */
    if([request.URL.absoluteString rangeOfString:@"code="].location != NSNotFound) {
      NSError *regularExpressionError = nil;
      
      /**
       *  Find the authorization code using a regular expression..
       */
      NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"code=.*(;|&)" options:NSRegularExpressionCaseInsensitive error:&regularExpressionError];
      
      NSArray *regularExpressionMatches = [regularExpression matchesInString:request.URL.absoluteString options:0 range:NSMakeRange(0, [request.URL.absoluteString length])];
      
      if([regularExpressionMatches count]){
        NSTextCheckingResult *match = [regularExpressionMatches firstObject];
        
        [TODOUserManager singleton].user.code = [NSString stringWithString:[request.URL.absoluteString substringWithRange:NSMakeRange(match.range.location+5, match.range.length-6)]];
        [[TODOUserManager singleton].user save];
        [self closeWebViewPressed:nil];
      }
      return NO;
    }
    else if([request.URL.absoluteString rangeOfString:@"error="].location != NSNotFound) {
      return NO;
    }
  }
  
  return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
}
- (void)loadWebView {
  /**
   *  Generate a random alpha string for our state value to check on against the response.
   */
  NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  [TODOUserManager singleton].state = [NSMutableString stringWithCapacity: 16];
  
  for (int i=0; i < 16; i++) {
    [[TODOUserManager singleton].state appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
  }
  
  /**
   *  Set up our request and include the state.
   */
  NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.toodledo.com/3/account/authorize.php?response_type=code&client_id=%@&state=%@&scope=basic%%20tasks", APP_ID, [TODOUserManager singleton].state]];
  
  NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
  [self.webView loadRequest:request];

}
@end
