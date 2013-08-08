//
//  DetailCell.h
//  OnsaleLocal
//
//  Created by Admin on 2/4/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TTTAttributedLabel.h"

@protocol MapPressed <NSObject>

- (void) mapButtonPressed;
- (void) bookMarkPressed;
- (void) callPressed;
- (void) sharePressed;

@end

@interface DetailCell : UITableViewCell

//@property (strong, nonatomic) IBOutlet UIImageView* imageView1;
@property (strong, nonatomic) IBOutlet UILabel* productName;
@property (strong, nonatomic) IBOutlet UILabel* cost;
@property (strong, nonatomic) IBOutlet UILabel* deal;
@property (strong, nonatomic) IBOutlet UILabel* from;
@property (strong, nonatomic) IBOutlet UIButton* shareButton;
@property (strong, nonatomic) IBOutlet UIButton* bookmarkButton;
@property (strong, nonatomic) IBOutlet UIButton* callButton;
@property (strong, nonatomic) IBOutlet UILabel* storeName;
@property (strong, nonatomic) IBOutlet UILabel* address;
@property (strong, nonatomic) IBOutlet UILabel* distance;
@property (strong, nonatomic) IBOutlet UIButton* mapButton;
@property (strong, nonatomic) NSDictionary* dealDict;
@property (strong, nonatomic) IBOutlet MKMapView* mapView;
@property (strong, nonatomic) IBOutlet UILabel* phone;
@property (strong, nonatomic) IBOutlet TTTAttributedLabel* detailLabel;
@property (strong, nonatomic) id<MapPressed> delegate;
@property (assign, nonatomic) BOOL isBookmarked;


//- (void) resizeHeights;
- (void) setupCell;

@end
