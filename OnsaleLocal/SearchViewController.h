//
//  SearchViewController.h
//  OnsaleLocal
//
//  Created by Admin on 3/3/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "ResultsTableViewController.h"
#import "TopViewController.h"

@interface SearchViewController :TopViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CLLocation* location;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
//@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)searchPressed:(id)sender;



@end
