//
//  SelectFromListViewController.h
//  OnsaleLocal
//
//  Created by Admin on 2/10/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnderRightViewController.h"
#import "PickerViewController.h"

@interface SelectFromListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray* items;
@property (strong, nonatomic) id<PassBack> delegate;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;


@end
