//
//  ResultsTableViewController.h
//  OnsaleLocal
//
//  Created by Admin on 1/29/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TopViewController.h"

@protocol RootDelegate <NSObject>

- (void) didSelectItem: (id) item andIdentifier:(NSString*)identifier;

@end

@interface ResultsTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSString* currentQuery;
@property (strong, nonatomic) NSData* jsonDataFromQuery;
@property (strong, nonatomic) NSArray* resultsArrayOfDictionaries;
@property (strong, nonatomic) CLLocation* location;
@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (assign, nonatomic) int radius;
@property (strong, nonatomic) NSString* nextQuery;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) id<RootDelegate> rootDelegate;

//only use if not fetching data from the server.  Must set self.resultsArrayOfDictionaries manually
@property (assign, nonatomic) int shouldRefresh;
//return negative if should not refresh, possitive if should refresh and 0 is uninitialized;

- (IBAction) refresh: (id)sender;
- (void) eliminateCahcedURL;

@end
