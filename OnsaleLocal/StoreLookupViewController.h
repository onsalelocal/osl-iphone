//
//  StoreLookupViewController.h
//  OnsaleLocal
//
//  Created by Jon on 7/10/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultsTableViewController.h"
#import "PassBack.h"

@interface StoreLookupViewController : ResultsTableViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) id <PassBack> passBackDelegate;


@end
