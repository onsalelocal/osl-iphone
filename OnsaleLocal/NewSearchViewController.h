//
//  NewSearchViewController.h
//  OnsaleLocal
//
//  Created by Jon on 6/13/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataViewController.h"

@interface NewSearchViewController : DataViewController <UICollectionViewDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
