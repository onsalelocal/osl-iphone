//
//  TopViewController.m
//  OnsaleLocal
//
//  Created by Admin on 1/31/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "TopViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "UnderRightViewController.h"
#import "Container.h"
#import "NavigationTopViewController.h"
//#import "MarqueeLabel.h"

@interface TopViewController ()



@end

@implementation TopViewController

//@synthesize menuButton = _menuButton;
@synthesize hasMoreThenMenu = _hasMoreThenMenu;
@synthesize radius = _radius;
@synthesize marqueeLabel = _marqueeLabel;
@synthesize placeholderView= _placeholderView;

-(void) viewDidLoad{
    [super viewDidLoad];
    //NSLog(@"self.slidingViewController: %@", self.slidingViewController);
    self.slidingViewController.shouldAddPanGestureRecognizerToTopViewSnapshot = YES;
    //self.slidingViewController.shouldAllowUserInteractionsWhenAnchored = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(containerFinishedUpdating:) name:CONTAINER_UPDATED_NOTIFICATION object:nil];
    self.marqueeLabel = [[MarqueeLabel alloc]initWithFrame:CGRectZero duration:8 andFadeLength:10.0f];
    [self.view addSubview:self.marqueeLabel];

}

-(void)containerFinishedUpdating:(NSNotification*) notification{
    Container* container = [Container theContainer];
    NSLog(@"%@",[NSString stringWithFormat:@"Location: %@, %@ %@; Search Radius: %d miles;", container.cityString, container.stateString, container.countryString, container.radius]);
    //self.autoScrollLabel.textColor = [UIColor blackColor];
    NSString* text = [NSString stringWithFormat:@"Location: %@, %@ %@; Search Radius: %d miles;", container.cityString, container.stateString, container.countryString, container.radius];
    self.marqueeLabel.text = text;
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];


    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    if (![self.slidingViewController.underRightViewController isKindOfClass:[UnderRightViewController class]]) {
        self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UnderRight"];
        NSLog(@"%@", self.slidingViewController.underRightViewController);
    }
    

    if(!self.slidingViewController.navigationController){
        NSLog(@"%@",self.slidingViewController);
        [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    }
    //[MarqueeLabel controllerViewAppearing:self];

}

- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    CGRect frame = self.placeholderView.frame;
    self.marqueeLabel.frame = frame;
    //NSLog(@"%f,%f,%f,%f", frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
    self.marqueeLabel.marqueeType = MLContinuous;
    //continuousLabel2.continuousMarqueeSeparator = @"  |SEPARATOR|  ";
    //self.marqueeLabel.animationCurve = UIViewAnimationOptionCurveLinear;
    //[self.marqueeLabel removeFromSuperview];
    self.marqueeLabel.numberOfLines = 1;
    self.marqueeLabel.opaque = NO;
    self.marqueeLabel.enabled = YES;
    self.marqueeLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    self.marqueeLabel.textAlignment = NSTextAlignmentLeft;
    self.marqueeLabel.textColor = [UIColor colorWithRed:0.234 green:0.234 blue:0.234 alpha:1.000];
    self.marqueeLabel.backgroundColor = [UIColor clearColor];
    self.marqueeLabel.font = [UIFont fontWithName:@"Helvetica" size:12.000];
    self.marqueeLabel.text = @"Waiting for location to update...";
    Container* container = [Container theContainer];
    if(container && !container.isUpdating){
        
        NSString* marqueeString = [NSString stringWithFormat:@"Location: %@, %@ %@, Search Radius: %d miles", container.cityString, container.stateString, container.countryString, container.radius];
        
        self.marqueeLabel.text = marqueeString;
    }
    //[self.marqueeLabel removeFromSuperview];
     
    /*
    if(![self.view.subviews containsObject:self.marqueeLabel]){
        [self.view addSubview:self.marqueeLabel];
    }
     */

}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)revealUnderRight:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECLeft];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

-(BOOL) shouldAutorotate{
    return NO;
}

- (NSUInteger) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}


@end
