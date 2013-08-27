

//
//  DetailViewController.h
//  OnsaleLocal
//
//  Created by Admin on 2/4/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "ResultsTableViewController.h"
#import "Deal.h"

@protocol cellMethods <NSObject>

-(void)commentPressed;
-(void)sharePressed;

@end

@interface DetailViewController : UIViewController


@property (strong, nonatomic) CLLocation* currentLocation;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString* offerID;

@end
