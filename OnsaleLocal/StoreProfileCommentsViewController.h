//
//  StoreProfileCommentsViewController.h
//  OnsaleLocal
//
//  Created by Jon on 6/19/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import <MapKit/MapKit.h>

@interface StoreProfileCommentsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDataDelegate, NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *commentsButton;
@property (weak, nonatomic) IBOutlet UIButton *dealsButton;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityAndStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *storeLogoImageView;
@property (strong, nonatomic) id info;
@property (strong, nonatomic) NSURLConnection* connection;
@property (strong, nonatomic) NSMutableData* data;
//@property (strong, nonatomic) NSArray* commentObjects;
@property (strong, nonatomic) id dataObject;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)dealButtonPressed:(id)sender;
- (IBAction)commentsButtonPressed:(id)sender;
@end
