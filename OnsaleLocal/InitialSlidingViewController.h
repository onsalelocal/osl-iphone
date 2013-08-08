//
//  InitialSlidingViewController.h
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/25/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import "ECSlidingViewController.h"
#import <CoreLocation/CoreLocation.h>

@protocol LocationUpdate <NSObject>

- (void) locationUpdate: (CLLocation*) location;

@end

@interface InitialSlidingViewController : ECSlidingViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) CLLocation* location;
@property (readonly, nonatomic) CLLocation* deviceLocation;
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) id<LocationUpdate> delegate;


@end
