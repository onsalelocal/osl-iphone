//
//  StoresViewController.h
//  OnsaleLocal
//
//  Created by Admin on 1/29/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "UnderRightViewController.h"
#import "ResultsTableViewController.h"

@interface StoresViewController : ResultsTableViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIToolbar *bottomBar;
- (IBAction)revealMenu:(id)sender;
- (IBAction)revealUnderRight:(id)sender;
@end
