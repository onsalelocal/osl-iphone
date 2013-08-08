//
//  MePeopleViewController.h
//  OnsaleLocal
//
//  Created by Admin on 6/26/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "MeViewController.h"

@interface MePeopleViewController : MeViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
