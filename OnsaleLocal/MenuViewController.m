//
//  MenuViewController.m
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import "MenuViewController.h"
#import "EGOCache.h"
#import "ResultsTableViewController.h"
#import "NavigationTopViewController.h"
#import "WebViewController.h"

@interface MenuViewController()<UIAlertViewDelegate>
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSArray *userMenuItems;
@property (strong, nonatomic) NSString* identifier;
@property (strong, nonatomic) NSArray* iconArray;
@property (strong, nonatomic) NSArray* iconArray2;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

 
//@property (strong , nonatomic) IBOutlet UITableView* tableView;
@end

@implementation MenuViewController
@synthesize menuItems = _menuItems;
@synthesize userMenuItems = _userMenuItems;
@synthesize identifier = _identifier;
@synthesize iconArray = _iconArray;
@synthesize iconArray2  = _iconArray2;
//@synthesize tableView = _tableView;

- (void)awakeFromNib
{
    self.menuItems = [NSArray arrayWithObjects:@"Home", @"Weekly Ads", @"Local Offers",@"Search", @"Change Location",  @"Bookmarks",@"Refresh", nil];
    self.iconArray = [NSArray arrayWithObjects:@"home_48",@"ic_menu_category48",@"ic_menu_category48",@"search_48",@"ic_menu_location48",@"ic_menu_favorites48",@"ic_menu_refresh48", nil];
    self.userMenuItems = [NSArray arrayWithObjects:@"Invite Friends", @"Clear Cache", @"About Us", @"Rate the App", @"Terms of Use", @"Privacy Policy",   nil];
    self.iconArray2 = [NSArray arrayWithObjects:@"ic_menu_invite48",@"ic_menu_clear_history48",@"ic_menu_about_us48",@"ic_menu_rate48",@"ic_menu_terms48",@"ic_menu_privacy48", nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.tableView.clearsSelectionOnViewWillAppear = NO;
    [self.slidingViewController setAnchorRightRevealAmount:240.0f];
    [self.slidingViewController setAnchorLeftRevealAmount:260.0f];
    self.slidingViewController.underLeftWidthLayout = ECFixedRevealWidth;
    self.slidingViewController.underRightWidthLayout = ECFixedRevealWidth;
    
    [self.navBar setBackgroundImage:[UIImage imageNamed:@"navBarBackground.png"] forBarMetrics:UIBarMetricsDefault];
    /*
    if(self.slidingViewController){
        
        [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    }
     */
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if(sectionIndex == 0){
        return self.menuItems.count;
    }else{
        return self.userMenuItems.count;
    }
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return nil;
        
    }else{
        return @"User";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"menuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        //cell.textLabel.font =
    }
    //cell.backgroundColor = [UIColor darkGrayColor];
    if(indexPath.section == 0){
        cell.accessoryView.backgroundColor = [UIColor grayColor];
        cell.textLabel.text = [self.menuItems objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat: @"%@.png",self.iconArray[indexPath.row]]];
    }
    else{
        cell.accessoryView.backgroundColor = [UIColor grayColor];
        cell.textLabel.text = [self.userMenuItems objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat: @"%@.png",self.iconArray2[indexPath.row]]];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"%f, %f, %f")
    cell.backgroundColor = [UIColor colorWithWhite:.3 alpha:1];
    cell.textLabel.textColor = [UIColor colorWithWhite:.9 alpha:1];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL* url = nil;
    NSString *oldIdentifier = self.identifier ? [self.identifier copy] : @"OffersOrDealsNavigation";
    BOOL refresh = NO;
    if(indexPath.section == 0){
        
        self.identifier = [NSString stringWithFormat:@"%@NavigationTop", [self.menuItems objectAtIndex:indexPath.row]];
        if( [self.menuItems[indexPath.row] isEqualToString:@"Home"]){
            self.identifier = @"OffersOrDealsNavigation";
        }
        if( [self.menuItems[indexPath.row] isEqualToString:@"Search"]){
            self.identifier = @"SearchVC";
        }
        if([self.menuItems[indexPath.row] isEqualToString:@"Refresh"]){
            refresh = YES;
            self.identifier = oldIdentifier;
        }
        if([self.menuItems[indexPath.row] isEqualToString:@"Weekly Ads"]){
            self.identifier = @"StoresNavigationTop";
        }
        if([self.menuItems[indexPath.row] isEqualToString:@"Local Offers"]){
            self.identifier = @"CategoriesNavigationTop";
        }
    }
    else if(indexPath.section == 1){
        
        if([self.userMenuItems[indexPath.row] isEqualToString:@"Clear Cache"]){
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Clear Cache" message:@"This will clear both querys and images from the cahce.  Are you sure?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
            
        }
        //@"About Us", @"Rate the App", @"Terms of Use", @"Privacy Policy", 
        else if([self.userMenuItems[indexPath.row] isEqualToString:@"About Us"]){
            self.identifier = @"webViewFromMenu";
            NSString *path = [[NSBundle mainBundle] pathForResource:@"aboutus" ofType:@"html"];
            url = [NSURL fileURLWithPath:path];
            
        }
        else if([self.userMenuItems[indexPath.row] isEqualToString:@"Terms of Use"]){
            self.identifier = @"webViewFromMenu";
            NSString *path = [[NSBundle mainBundle] pathForResource:@"tos" ofType:@"html"];
            url = [NSURL fileURLWithPath:path];
            
        }
        else if([self.userMenuItems[indexPath.row] isEqualToString:@"Privacy Policy"]){
            self.identifier = @"webViewFromMenu";
            NSString *path = [[NSBundle mainBundle] pathForResource:@"privacypolicy" ofType:@"html"];
            url = [NSURL fileURLWithPath:path];
            
        }
        else if ([self.userMenuItems[indexPath.row] isEqualToString:@"Invite Friends"]){
            self.identifier = @"inviteFriendsNavigationTop";
        }
        
    }
    if (refresh) {
        
        [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
            //CGRect frame = self.slidingViewController.topViewController.view.frame;
            //self.slidingViewController.topViewController = newTopViewController;
            //self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
            if([self.slidingViewController.topViewController isKindOfClass:[NavigationTopViewController class]]){
                if([self.slidingViewController.topViewController.childViewControllers[0] respondsToSelector:@selector(eliminateCahcedURL)]){
                    [(ResultsTableViewController*)self.slidingViewController.topViewController.childViewControllers[0] eliminateCahcedURL];
                }
                
            }
            else if([self.slidingViewController.topViewController isKindOfClass:[ResultsTableViewController class]]){
                [(ResultsTableViewController*)self.slidingViewController.topViewController eliminateCahcedURL];
            }
        }];
        return;
         
    }
    
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:self.identifier];
    if([newTopViewController isKindOfClass:[NavigationTopViewController class]]&&
       [[newTopViewController.childViewControllers lastObject] isKindOfClass:[WebViewController class]]){
        WebViewController* wvc = (WebViewController*)[newTopViewController.childViewControllers lastObject];
        wvc.url = url;
    }
    
    
    
    /*
    if([newTopViewController isKindOfClass:[NavigationTopViewController class]]&&
       [[newTopViewController.childViewControllers lastObject] isKindOfClass:[ResultsTableViewController class]]){
        [[[(NavigationTopViewController *)newTopViewController childViewControllers] lastObject] refresh: self];
        NSLog(@"%@", [[(NavigationTopViewController *)newTopViewController childViewControllers] lastObject] );
    }
     */
    //NSLog(@"%@", [newTopViewController class]);
    //[self.navigationController addChildViewController:newTopViewController];
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        NSLog(@"OK");
        [[EGOCache globalCache]clearCache];
    }
    else{
        NSLog(@"Cancel pressed");
    }
}

@end
