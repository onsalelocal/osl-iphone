//
//  MeViewController.m
//  OnsaleLocal
//
//  Created by Admin on 6/21/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "MeViewController.h"
#import "UIImageView+WebCache.h"
#import "OnsaleLocalConstants.h"
#import "ResultsTableViewController.h"
#import "DownloadObject.h"

@interface MeViewController ()<NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (strong, nonatomic) NSURLConnection* userConnection;
@property (strong, nonatomic) NSMutableData* userData;
@property (strong, nonatomic) DownloadObject* downloadObject;

@end

@implementation MeViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firstObjectDownloaded:) name:DATA_OBJECT_ONE_DONE object:nil];
    if(self.dataObject){
        NSString* urlString = [NSString stringWithFormat:@"http://onsalelocal.com/osl2/ws/user/avatar/%@",self.dataObject];
        NSURL* url = [NSURL URLWithString:urlString];
        [self.imageView setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
            
        }];
    }
    NSString* firstName = [[NSUserDefaults standardUserDefaults] valueForKey: USER_FIRST_NAME];
    NSString* lastName = [[NSUserDefaults standardUserDefaults] valueForKey: USER_LAST_NAME];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",firstName, lastName];
    
    self.downloadObject = [[DownloadObject alloc]init];
    NSString* urlString = @"http://onsalelocal.com/osl2/ws/user/me?format=json";
    [self.downloadObject beginConnectionWithURL:urlString];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)firstObjectDownloaded:(NSNotification*) notification{
    NSDictionary* d = notification.userInfo[@"key"];
    NSLog(@"%@",d);
    self.followerCountLabel.text = [NSString stringWithFormat:@"%@\nfollowers", d[@"followers"] ];
}


@end
