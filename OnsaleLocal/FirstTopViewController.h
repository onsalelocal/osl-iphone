//
//  FirstTopViewController.h
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "UnderRightViewController.h"
#import "ResultsTableViewController.h"
#import "TopViewController.h"
#import "AutoScrollLabel.h"


@interface FirstTopViewController : ResultsTableViewController

@property (strong, nonatomic) NSString* nextQuery;
@property (assign, nonatomic) BOOL useBackButton;
@property (weak, nonatomic) IBOutlet AutoScrollLabel *autoScrollLabel;
@property (strong, nonatomic) NSString* lsAddition;

@end
