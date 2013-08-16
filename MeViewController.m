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

-(void)setInfo:(id)info{
    _info = info;
    if([info isKindOfClass:[NSString class]]){
        self.otherUser = info;
    }
}

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
       
}

-(void)viewWillAppear:(BOOL)animated{
    NSString* urlString2 = nil;
    self.downloadObject = [[DownloadObject alloc]init];
    if(self.otherUser){
        urlString2 = [NSString stringWithFormat: @"http://onsalelocal.com/osl2/ws/user/details?userId=%@",self.otherUser];
        self.followerCountLabel.hidden = YES;
        
    }
    else{
        if(self.dataObject){
            NSString* urlString = [NSString stringWithFormat:@"http://onsalelocal.com/osl2/ws/user/avatar/%@",self.dataObject];
            NSURL* url = [NSURL URLWithString:urlString];
            [self.imageView setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                
            }];
        }
        NSString* firstName = [[NSUserDefaults standardUserDefaults] valueForKey: USER_FIRST_NAME];
        NSString* lastName = [[NSUserDefaults standardUserDefaults] valueForKey: USER_LAST_NAME];
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",firstName, lastName];
        
        
        urlString2 = @"http://onsalelocal.com/osl2/ws/user/me?format=json";
    }
    [self.downloadObject beginConnectionWithURL:urlString2];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)firstObjectDownloaded:(NSNotification*) notification{
    NSDictionary* d = notification.userInfo[@"key"];
    NSLog(@"%@",d);
    if(self.otherUser){
        NSString* firstName = d[USER_FIRST_NAME];
        NSString* lastName = d[USER_LAST_NAME];
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",firstName, lastName];

    }else{
        self.followerCountLabel.text = [NSString stringWithFormat:@"%@\nfollowers", d[@"followers"] ];

    }
}


@end
