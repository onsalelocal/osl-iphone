//
//  LocationManager.m
//  OnsaleLocal
//
//  Created by Jon on 6/4/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "LocationManager.h"
#import "Container.h"

@implementation LocationManager

static LocationManager* _instance = nil;

+(LocationManager*) instance{
    if(!_instance){
        _instance = [[LocationManager alloc] init];
        _instance.manager = [[CLLocationManager alloc]init];
        [_instance startUpdating];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startUpdating) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopUpdating) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    
    return _instance;
}

- (void) startUpdating{
    NSLog(@"%@", self.manager);
    [self.manager startMonitoringSignificantLocationChanges];
    CLLocation* loc = [[CLLocation alloc] initWithLatitude:37.3703 longitude:-121.924];
    [Container startUpdatingWithLocation:loc];

}

+ (void) startUpdating{
    NSLog(@"%@", _instance.manager);
    [_instance.manager startMonitoringSignificantLocationChanges];
    CLLocation* loc = [[CLLocation alloc] initWithLatitude:37.3703 longitude:-121.924];
    [Container startUpdatingWithLocation:loc];
    
}


+ (void) stopUpdating{
    [_instance.manager stopMonitoringSignificantLocationChanges];
    
}

- (void) stopUpdating{
    [self.manager stopMonitoringSignificantLocationChanges];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.location = [locations lastObject];
    //CLLocation* loc = [[CLLocation alloc] initWithLatitude:37.3703 longitude:-121.924];
    [Container startUpdatingWithLocation:self.location];
}

@end
