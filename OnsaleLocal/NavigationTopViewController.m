//
//  NavigationTopViewController.m
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 2/13/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import "NavigationTopViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface NavigationTopViewController()

@property (strong, nonatomic) UIBarButtonItem* menuButton;

@end

@implementation NavigationTopViewController

@synthesize menuButton = _menuButton;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    //[UIColor colorWithRed:176/255.0f green:28/255.0f blue:23/255.0f alpha:1]
    //[self.navigationBar setTintColor:[UIColor colorWithRed:183/255.0 green:19/255.0 blue:28/255.0 alpha:1.0]];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarBackground.png"] forBarMetrics:UIBarMetricsDefault];
    self.slidingViewController.shouldAddPanGestureRecognizerToTopViewSnapshot = YES;
    [self.navigationBar setTintColor:[UIColor colorWithRed:176/255.0 green:27/255.0f blue:23/255.0f alpha:1]];
    //[self.backBarButtonItem setTintColor:[UIColor colorWithRed:176/255.0 green:27/255.0f blue:23/255.0f alpha:1]];
    
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    if (![self.slidingViewController.underRightViewController isKindOfClass:[UnderRightViewController class]]) {
        self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UnderRight"];
        NSLog(@"%@", self.slidingViewController.underRightViewController);
    }
    
    if(self.slidingViewController && ![self.childViewControllers[0] isKindOfClass:[UnderRightViewController class]]){
        
        [self.view addGestureRecognizer:self.slidingViewController.panGesture];
        self.slidingViewController.shouldAddPanGestureRecognizerToTopViewSnapshot = YES;
        //self.slidingViewController.shouldAllowUserInteractionsWhenAnchored = YES;
    }
}

@end
