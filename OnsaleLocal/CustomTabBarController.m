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



@interface CustomTabBarController ()<UIAlertViewDelegate,InfiniTabBarDelegate>

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
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor redColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIFont fontWithName:@"AmericanTypewriter" size:20.0f], UITextAttributeFont,
                                                       [UIColor yellowColor], UITextAttributeTextColor,
                                                       /*[UIColor grayColor], UITextAttributeTextShadowColor,*/
                                                       [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)], UITextAttributeTextShadowOffset,
                                                       nil] forState:UIControlStateSelected];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor redColor]];
    self.tabBar.hidden = YES;
    UITabBarItem *favorites = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0];
	UITabBarItem *topRated = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:1];
	UITabBarItem *featured = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:2];
	UITabBarItem *recents = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:3];
	UITabBarItem *contacts = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:4];
	UITabBarItem *history = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:5];
	UITabBarItem *bookmarks = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:6];
    
    
    self.infinityTabBar = [[InfiniTabBar alloc]initWithItems:[NSArray arrayWithObjects:favorites,
                                                             topRated,
                                                             featured,
                                                             recents,
                                                             contacts,
                                                             history,
                                                             bookmarks, nil]];
    self.infinityTabBar.showsHorizontalScrollIndicator = NO;
	self.infinityTabBar.infiniTabBarDelegate = self;
	self.infinityTabBar.bounces = NO;
	self.infinityTabBar.frame = self.tabBar.frame;
    [[self.tabBarController.view.subviews objectAtIndex:0] setFrame:self.window.frame];
	[self.view addSubview:self.infinityTabBar];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)infiniTabBar:(InfiniTabBar *)tabBar didScrollToTabBarWithTag:(int)tag{
    
}

-(void)infiniTabBar:(InfiniTabBar *)tabBar didSelectItemWithTag:(int)tag{
    UIViewController *vc = self.viewControllers[tag];
    if(tag>3){
        vc.navigationController.navigationBar.hidden = YES;
    }
    [self setSelectedViewController:vc];
}

@end
