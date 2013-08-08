//
//  TopViewController.h
//  OnsaleLocal
//
//  Created by Admin on 1/31/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InitialSlidingViewController.h"

#import "MarqueeLabel.h"

@interface TopViewController : UIViewController

//@property (strong, nonatomic) IBOutlet UIBarButtonItem* menuButton;
@property (assign, nonatomic) BOOL hasMoreThenMenu;
@property (assign, nonatomic) int radius;
@property (strong, nonatomic) MarqueeLabel* marqueeLabel;
@property (strong, nonatomic) IBOutlet UIView* placeholderView;

- (IBAction)revealMenu:(id)sender;

- (IBAction)revealUnderRight:(id)sender;

-(void)containerFinishedUpdating:(NSNotification*) notification;

@end
