//
//  MePeopleViewController.m
//  OnsaleLocal
//
//  Created by Admin on 6/26/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "MePeopleViewController.h"
#import "RootViewController.h"
#import "ModelController.h"
#import "OnsaleLocalConstants.h"
#import "FollowingTableViewCell.h"

@interface MePeopleViewController ()

- (IBAction)storesPressed:(id)sender;
@end

@implementation MePeopleViewController

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
    NSString* userID = self.otherUser ? self.otherUser : [[NSUserDefaults standardUserDefaults] valueForKey:USER_ID];
    self.nextQuery = [NSString stringWithFormat:@"http://onsalelocal.com/osl2/ws/v2/user/followings?format=json&userId=%@",userID];
}

-(void)setResultsArrayOfDictionaries:(NSArray *)resultsArrayOfDictionaries{
    [super setResultsArrayOfDictionaries:resultsArrayOfDictionaries];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)storesPressed:(id)sender {
    RootViewController* root = (RootViewController*)self.parentViewController.parentViewController;
    UIViewController* vc = [root.modelController viewControllerAtIndex:2 storyboard:self.storyboard];
    NSArray* arr = @[vc];
    [root.pageViewController setViewControllers:arr direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    return self.resultsArrayOfDictionaries.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@", self.restorationIdentifier);
    FollowingTableViewCell *cell = (FollowingTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"FollowingTableViewCell" forIndexPath:indexPath];
    //NSString* urlString = [NSString stringWithFormat:@"http://onsalelocal.com/osl2/ws/user/details?format=json&userId=%@",self.resultsArrayOfDictionaries[indexPath.row][USER_ID] ];
    //NSLog(@"%@", urlString);
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //    cell.details = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:urlString ]];
    //    NSLog(@"%@",cell.details);
    //});
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* uid = nil;//self.resultsArrayOfDictionaries[indexPath.row][USER_ID];
    uid = @"26deae9d-3f83-4acb-ae99-5a09b3a4dc7e";
    if(uid.length){
        RootViewController* rvc = [self.storyboard instantiateViewControllerWithIdentifier:@"me"];
        rvc.info = uid;
        [self.navigationController pushViewController:rvc animated:YES];
        NSLog(@"Pushed OtherUserVC");
    }
}
@end
