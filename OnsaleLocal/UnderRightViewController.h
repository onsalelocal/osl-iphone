//
//  UnderRightViewController.h
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "ResultsTableViewController.h"
#import "TopViewController.h"

@interface UnderRightViewController : UIViewController <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIView *placeholderView;
@property (strong, nonatomic) CLLocation* location;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
//@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)searchPressed:(id)sender;


@end
