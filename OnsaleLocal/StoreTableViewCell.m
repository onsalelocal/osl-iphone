//
//  StoreTableViewCell.m
//  OnsaleLocal
//
//  Created by Jon on 6/12/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "StoreTableViewCell.h"
#import "OnsaleLocalConstants.h"
#import "Container.h"
#import "MKMapView+ZoomLevel.h"

@implementation StoreTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setDealDict:(NSDictionary *)dealDict{
    if(_dealDict != dealDict){
        _dealDict = dealDict;
        self.storeName.text = dealDict[DEAL_STORE];
        self.storeAddress.text = dealDict[DEAL_ADDRESS];
        self.cityAndState.text = [NSString stringWithFormat:@"%@, %@", dealDict[DEAL_CITY], dealDict[DEAL_STATE]];
        if([dealDict[DEAL_LAT]doubleValue] &&[dealDict[DEAL_LONG]doubleValue] && [[Container theContainer]location]){
            CLLocation* location = [[CLLocation alloc]initWithLatitude:[dealDict[DEAL_LAT]doubleValue] longitude:[dealDict[DEAL_LONG]doubleValue]];
            CGFloat d = [location distanceFromLocation:[[Container theContainer]location]];
            self.distance.text = [NSString stringWithFormat:@"%.2f Miles",d * 0.000621371]; //meters to miles
        }else{
            self.phone.frame = self.distance.frame;
            self.distance = nil;
        }
        if(dealDict[DEAL_PHONE]){
            self.phone.hidden = NO;
            NSString *phone = [NSString stringWithFormat:@"%@", dealDict[DEAL_PHONE]];
            if ([[phone substringToIndex:1] isEqualToString:@"1"]) {
                phone = [phone substringFromIndex:1];
            }
            phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
            phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
            phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
            phone = [phone stringByReplacingOccurrencesOfString:@"." withString:@""];
            NSRange mid = NSMakeRange(3, 3);
            self.phone.text = [NSString stringWithFormat:@"(%@) %@-%@",[phone substringToIndex:3],[phone substringWithRange:mid],[phone substringFromIndex:6]];
        }
        else{
            self.phone.hidden = YES;
        }
        [self.mapView setScrollEnabled:NO];
        //[self.mapView setCenterCoordinate:loc2D animated:NO];
        //NSLog(@"%d",[self.mapView getZoomLevel]);
        MKPointAnnotation* annotation = [[MKPointAnnotation alloc]init];
        annotation.coordinate = CLLocationCoordinate2DMake([dealDict[DEAL_LAT]doubleValue],  [dealDict[DEAL_LONG] doubleValue]);
        [self.mapView addAnnotation:annotation];
        

        
    }
}

- (void) layoutSubviews{
    [super layoutSubviews];
    CLLocationCoordinate2D loc2D = CLLocationCoordinate2DMake([self.dealDict[DEAL_LAT]doubleValue], [self.dealDict[DEAL_LONG]doubleValue]);
    [self.mapView setCenterCoordinate:loc2D zoomLevel:7 animated:NO];
}

@end
