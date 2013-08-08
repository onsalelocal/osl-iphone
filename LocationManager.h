//
//  LocationManager.h
//  OnsaleLocal
//
//  Created by Jon on 6/4/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager* manager;
@property (strong, nonatomic) CLLocation* location;

+ (LocationManager*) instance;
- (void) startUpdating;
- (void) stopUpdating;

@end
