//
//  CustomTabBarController.m
//  OnsaleLocal
//
//  Created by Jon on 6/11/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "CustomTabBarController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "OnsaleLocalConstants.h"



@interface CustomTabBarController ()<Login, UIAlertViewDelegate>

@property (strong, nonatomic) NSArray* selectedButtonImages;
@property (strong, nonatomic) NSArray* unSelectedButtonImages;
@property (strong, nonatomic) NSArray* buttonImageNames;
@property (strong, nonatomic) NSArray* tabBarItems;
@property (strong, nonatomic) UIWindow* window;
@property (strong, nonatomic) UINavigationController* navController;
@property (strong, nonatomic) LoginViewController* vc;
@property (strong, nonatomic) NSMutableData* responseData;
@property (strong, nonatomic) NSURLConnection* fbConnection;

@end

@implementation CustomTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) setupLogin{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"iPhoneStoryboard2" bundle:nil];
    self.vc = (LoginViewController*)[storyboard instantiateViewControllerWithIdentifier:@"login"];
    self.vc.loginDelegate = self;
    //self.navController = [[UINavigationController alloc]initWithRootViewController:self.vc];
    
    //UINavigationController *nav = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"loginNav"];
    //self.navController = nav;
    //[((LoginViewController*)self.navController.viewControllers[0]) setLoginDelegate:self];
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    NSLog(@"%@",NSStringFromCGRect( _window.frame));
    //_window.rootViewController = self.navController;
    [_window setBackgroundColor:[UIColor clearColor]];
    [_window setWindowLevel:UIWindowLevelStatusBar+1];
    [_window makeKeyAndVisible];
    [_window addSubview:self.vc.view];
    NSLog(@"%@",NSStringFromCGRect( self.vc.view.frame));
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
    NSString* userID = [[NSUserDefaults standardUserDefaults] objectForKey:USER_EMAIL];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:USER_LOGGED_IN];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:FB_LOGIN_SUCCESS];
    /*
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies) {
        [cookieStorage deleteCookie:each];
    }
     */
    if (![[NSUserDefaults standardUserDefaults]boolForKey:USER_LOGGED_IN] && ![[NSUserDefaults standardUserDefaults] boolForKey:FB_LOGIN_SUCCESS]) {
        [self setupLogin];
    }
    else if([[NSUserDefaults standardUserDefaults] boolForKey:FB_LOGIN_SUCCESS]){
        [self fbLogin];
    }
#warning 'else' statement not verified
    else{//log user into server in the background
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://onsalelocal.com/osl2/ws/user/login"]];
        NSUUID* uuid = [[UIDevice currentDevice]identifierForVendor];
        NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        NSString* userID = [[NSUserDefaults standardUserDefaults]objectForKey:USER_EMAIL];
        NSString *header = [NSString stringWithFormat:@"ios;%@;%@;%@;%f;%f;%ld",[uuid UUIDString], version, userID,0.0, 0.0, (long)[[NSDate date]timeIntervalSince1970]];
        
        NSString *login = [[NSUserDefaults standardUserDefaults]stringForKey:USER_EMAIL];
        NSString* password = [[NSUserDefaults standardUserDefaults] stringForKey:USER_PASSWORD];
        NSString* s = [NSString stringWithFormat: @"password=%@&login=%@",login,password];
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody: [s dataUsingEncoding:NSUTF8StringEncoding]];
        [request setValue:header forHTTPHeaderField:@"Reqid"];
        //[request setValue:@"text/plain"/*@"application/x-www-form-urlencoded"*/ forHTTPHeaderField:@"content-type"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPShouldHandleCookies:YES];
        NSString *msgLength = [NSString stringWithFormat:@"%d", [[s dataUsingEncoding:NSUTF8StringEncoding] length]];
        [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
        
        NSURLConnection *c = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didFinishLoggingIn:(id)loginViewController{
    [self.vc.view removeFromSuperview];
	self.vc = nil;
    self.navController = nil;
	
	[_window setHidden:YES];
	_window = nil;
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSString* text = [[NSString alloc]initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", text);
    NSDictionary* d;
    NSError* error;
    d = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
    if(connection == self.fbConnection){
        NSLog(@"%@",d);
        [[NSUserDefaults standardUserDefaults]setValue:d[@"login"] forKey:USER_EMAIL];
        [[NSUserDefaults standardUserDefaults] setValue:d[USER_ID] forKey:USER_ID];
    }
    if(error){
        NSLog(@"%@", error.localizedDescription);
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error signing in to server" message:@"Please re-login or sign in with Facebook" delegate:self cancelButtonTitle:@"Skip" otherButtonTitles:@"OK", nil];
        [alert show];
    }else{
        
    }
    //NSLog(@"%@",)
    
    
}

#pragma mark - NSURLConnection delegates

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSDictionary* d = [((NSHTTPURLResponse*)response) allHeaderFields];
    NSLog(@"%@",d);
    self.responseData = [[NSMutableData alloc] init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Failed to fetch data");
    //[textView setString:@"Unable to fetch data"];
    
}

#pragma mark - UIAlertView Delegate

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        //skip pressed
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:USER_LOGGED_IN];
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:USER_EMAIL];
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:USER_PASSWORD];
        
    }
    else{//ok pressed
        [self setupLogin];
    }
}

@end
