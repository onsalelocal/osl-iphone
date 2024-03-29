//
//  LoginViewController.m
//  OnsaleLocal
//
//  Created by Jon on 6/11/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "OnsaleLocalConstants.h"
#import "CustomTabBarController.h"
#import "RegisterViewController.h"

@interface LoginViewController ()<NSURLConnectionDataDelegate, NSURLConnectionDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSURLConnection *fbConnection;
@property (strong, nonatomic) NSMutableData* fbData;
@property (strong, nonatomic) NSURLConnection *loginConnection;
@property (strong, nonatomic) NSMutableData *loginData;
@property (strong, nonatomic) CustomTabBarController* customTabBarController;


@end

@implementation LoginViewController

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
	// Do any additional setup after loading the view.
    //self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fbLogin) name:FB_LOGIN_SUCCESS object:nil];
    //NSLog(@"%@", NSStringFromCGRect(self.loginButton.frame  ));
    //[self viewWillAppear:YES];
    //NSLog(@"%@", NSStringFromCGRect(self.loginButton.frame  ));
    //[self viewDidAppear:YES];
    //NSLog(@"%@", NSStringFromCGRect(self.loginButton.frame  ));
    self.emailTextField.userInteractionEnabled = YES;
    self.passwordTextField.userInteractionEnabled = YES;
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] );
    if([[NSUserDefaults standardUserDefaults] boolForKey:FB_LOGIN_SUCCESS]){
        [self fbLogin];
    }
    else if([[NSUserDefaults standardUserDefaults] boolForKey:USER_LOGGED_IN]){
        [self login];
    }

}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:FB_LOGIN_SUCCESS object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginPressed:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:self.emailTextField.text forKey:USER_EMAIL];
#warning encrypt email password
    [[NSUserDefaults standardUserDefaults] setValue:self.passwordTextField.text forKey:USER_PASSWORD];

    [self login];
}



- (IBAction)forgotYourPasswordPressed:(id)sender {
}

- (IBAction)facebookSignInPressed:(id)sender {
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) openSessionWithAllowLoginUI:YES];
    //[self fbLogin];
    //[self.loginDelegate didFinishLoggingIn:self];
}

- (void) login{
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://onsalelocal.com/osl2/ws/user/login"]];
    NSUUID* uuid = [[UIDevice currentDevice]identifierForVendor];
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString* userID = [[NSUserDefaults standardUserDefaults]objectForKey:USER_EMAIL];
    NSString *header = [NSString stringWithFormat:@"ios;%@;%@;%@;%f;%f;%ld",[uuid UUIDString], version, userID,0.0, 0.0, (long)[[NSDate date]timeIntervalSince1970]];
    
    NSString *login = self.emailTextField.text;
#warning encrypt password
    NSString* password = self.passwordTextField.text;
    //
    if([[NSUserDefaults standardUserDefaults] boolForKey:USER_LOGGED_IN ]){
        login = [[NSUserDefaults standardUserDefaults] valueForKey:USER_EMAIL];
        password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_PASSWORD];
    }
    NSString* s = [NSString stringWithFormat: @"password=%@&login=%@",password, login];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [s dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:header forHTTPHeaderField:@"Reqid"];
    //[request setValue:@"text/plain"/*@"application/x-www-form-urlencoded"*/ forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPShouldHandleCookies:YES];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [[s dataUsingEncoding:NSUTF8StringEncoding] length]];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    
    self.loginConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    
}

- (void)fbLogin{
    NSString* token = [[NSUserDefaults standardUserDefaults] objectForKey:FB_ACCESS_TOKEN];
    NSString* url = [NSString stringWithFormat:@"http://www.onsalelocal.com/osl2/ws/user/facebook-login"];
    
    NSDictionary* _params = @{@"token":token};
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:
                              [cookieJar cookies]];
    [request setAllHTTPHeaderFields:headers];
    NSUUID* uuid = [[UIDevice currentDevice]identifierForVendor];
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString* userID = self.emailTextField.text;
    NSString *header = [NSString stringWithFormat:@"ios;%@;%@;%@;%f;%f;%ld",[uuid UUIDString], version, userID,0.0, 0.0, (long)[[NSDate date]timeIntervalSince1970]];
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:_params options:kNilOptions error:&error];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: jsonData];
    [request setValue:header forHTTPHeaderField:@"Reqid"];
    //[request setValue:@"text/plain"/*@"application/x-www-form-urlencoded"*/ forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPShouldHandleCookies:YES];
    
    NSString *msgLength = [NSString stringWithFormat:@"%d", [jsonData length]];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    
    self.fbConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Error: %@", error.localizedDescription);
}
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"%@", ((NSHTTPURLResponse*)response).allHeaderFields);
    if(connection == self.loginConnection){
        self.loginData = [[NSMutableData alloc]init];
    }
    else if (connection == self.fbConnection){
        self.fbData = [NSMutableData data];
    }
}
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if(connection == self.loginConnection){
        [self.loginData appendData:data];
    }
    else if (connection == self.fbConnection){
        [self.fbData appendData:data];
    }
}
- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
#warning possibly stop spinner
    NSString* txt = nil;
    NSError* error;
    NSDictionary* d;
    if(connection == self.loginConnection){
        txt = [[NSString alloc]initWithData:self.loginData encoding:NSUTF8StringEncoding];
        d = [NSJSONSerialization JSONObjectWithData:self.loginData options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers error:&error];
        if(error){
            NSLog(@"%@", error.localizedDescription);
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error signing in to server" message:@"Please try again" delegate:self cancelButtonTitle:@"Skip" otherButtonTitles:@"OK", nil];
            [alert show];
        }else{
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:USER_LOGGED_IN];
            [[NSUserDefaults standardUserDefaults] setValue:d[USER_ID] forKey:USER_ID];
            [self.loginDelegate didFinishLoggingIn:self];
            [self prepCustomTabController];
        }
    }
    else if (connection == self.fbConnection){
        txt = [[NSString alloc]initWithData:self.fbData encoding:NSUTF8StringEncoding];
        d = [NSJSONSerialization JSONObjectWithData:self.fbData options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers error:&error];

        //NSLog(@"%@", d);
        if(error){
            NSLog(@"%@", error.localizedDescription);
        }else{
            //[[NSUserDefaults standardUserDefaults]setBool:YES forKey:USER_LOGGED_IN];
            //[[NSUserDefaults standardUserDefaults] setValue:d[USER_EMAIL] forKey:USER_EMAIL];
#warning encrypt email password
            //[[NSUserDefaults standardUserDefaults] setValue:d[USER_PASSWORD] forKey:USER_PASSWORD];
            [[NSUserDefaults standardUserDefaults]setValue:d[@"login"] forKey:USER_EMAIL];
            [[NSUserDefaults standardUserDefaults] setValue:d[USER_ID] forKey:USER_ID];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:FB_LOGIN_SUCCESS];
            [[NSUserDefaults standardUserDefaults] setValue:d[USER_FIRST_NAME] forKey:USER_FIRST_NAME];
            [[NSUserDefaults standardUserDefaults] setValue:d[USER_LAST_NAME] forKey:USER_LAST_NAME];
            [self.loginDelegate didFinishLoggingIn:self];
            [self prepCustomTabController];
        }
    }
    
}

-(void) prepCustomTabController{
    self.customTabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomTabBarController"];
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //appDelegate.window.rootViewController = self.customTabBarController;
    //[appDelegate.window addSubview:self.customTabBarController.view];
    //[appDelegate.window makeKeyAndVisible];
    //[self.view removeFromSuperview];
    //[appDelegate.window.rootViewController addChildViewController:self.customTabBarController];
    [appDelegate.window.rootViewController presentViewController:self.customTabBarController animated:NO completion:NULL];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    RegisterViewController* vc = (RegisterViewController*) segue.destinationViewController;
    vc.loginDelegate = self.loginDelegate;
}

#pragma mark - UIAlertView Delegate

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        //skip pressed
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:USER_EMAIL];
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:USER_PASSWORD];
        [self.loginDelegate didFinishLoggingIn:self];
    }
    else{//ok pressed
        self.emailTextField.text = @"";
        self.passwordTextField.text = @"";
    }
}

#pragma mark - text field delegates
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
   return YES;
}



@end
