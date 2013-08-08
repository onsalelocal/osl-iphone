//
//  BookmarksTableViewController.h
//  OnsaleLocal
//
//  Created by Admin on 1/29/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "UnderRightViewController.h"
#import "ResultsTableViewController.h"

@interface BookmarksTableViewController : TopViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView* tableView;

- (IBAction)revealMenu:(id)sender;

//- (IBAction)revealUnderRight:(id)sender;

@end
