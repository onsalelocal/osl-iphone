//
//  TestAFNetworkingViewController.m
//  OnsaleLocal
//
//  Created by Jon on 6/27/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "TestAFNetworkingViewController.h"
//#import "AFNetworking.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h" 
@interface TestAFNetworkingViewController ()

@end

@implementation TestAFNetworkingViewController

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
    NSUUID* uuid = [[UIDevice currentDevice]identifierForVendor];
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString* userID = @"jon@onsalelocal.com";
    long ms = (long)(CFAbsoluteTimeGetCurrent () * 1000);
    NSString *header = [NSString stringWithFormat:@"ios;%@;%@;%@;%f;%f;%ld",[uuid UUIDString], version, userID,0.0, 0.0, (long)[[NSDate date]timeIntervalSince1970]];
    NSDictionary* _params = @{@"firstName":@"Jon",
                              @"lastName":@"Doe",
                              @"login":@"jon@onsalelocal.com",
                              @"password":@"123456789",
                              @"zipcode":@"94587",
                              @"deviceId":[[[UIDevice currentDevice]identifierForVendor] UUIDString]};
    NSURL *url = [NSURL URLWithString:@"http://onsalelocal.com/osl2/ws/user/register"];
    /*
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client setDefaultHeader:@"Reqid" value:header];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [client setDefaultHeader:@"Content-Type" value:@"text/html"];
    [client postPath:@"http://onsalelocal.com/osl2/ws/user/register" parameters:_params success:^(AFHTTPRequestOperation* operation, id json){
        NSData* d = json;
        NSString* txt = [[NSString alloc]initWithData:d encoding:NSUTF8StringEncoding];
        NSLog(@"%@", txt);
    }failure:^(AFHTTPRequestOperation *response, NSError *error){
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"%@", response.debugDescription);
       
    }];
     */
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
