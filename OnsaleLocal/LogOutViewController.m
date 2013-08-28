//
//  LogOutViewController.m
//  OnsaleLocal
//
//  Created by Admin on 8/18/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "LogOutViewController.h"
#import "OnsaleLocalConstants.h"

@interface LogOutViewController ()

@end

@implementation LogOutViewController

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
    [self.navigationItem setHidesBackButton:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logOutPressed:(id)sender {
     NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for(NSHTTPCookie* cookie in [cookieJar cookies]){
        [cookieJar deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:USER_EMAIL];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:USER_ID];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:FB_LOGIN_SUCCESS];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:USER_FIRST_NAME];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:USER_LAST_NAME];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:USER_LOGGED_IN];
}
@end
