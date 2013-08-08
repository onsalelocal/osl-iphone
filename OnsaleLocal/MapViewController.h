//
//  MapViewController.h
//  Shutterbug
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class MapViewController;

@protocol MapViewControllerDelegate <NSObject>
- (UIImageView *)mapViewController:(MapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation;
@end

@interface MapViewController : UIViewController
@property (nonatomic, strong) NSArray *annotations; // of id <MKAnnotation>
@property (nonatomic, weak) id <MapViewControllerDelegate> delegate;
@property (strong, nonatomic) CLLocation* pinLocation;
@property (strong, nonatomic) CLLocation* currentLocation;
@end
