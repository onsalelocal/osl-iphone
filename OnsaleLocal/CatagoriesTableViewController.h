//
//  CatagoriesTableViewController.h
//  OnsaleLocal
//
//  Created by Admin on 1/29/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "UnderRightViewController.h"
#import "ResultsTableViewController.h"

@interface CatagoriesTableViewController : ResultsTableViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (assign, nonatomic) BOOL useBackButton;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomBar;
@property (assign, nonatomic) int ls; //0=not defined, -1=false, 1=true
@property (strong, nonatomic) NSString* currentStore;
//@property (strong, nonatomic) IBOutlet UITableView* tableView;

- (IBAction)revealMenu:(id)sender;
- (IBAction)revealUnderRight:(id)sender;

@end
