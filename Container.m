//
//  Container.m
//  OnsaleLocal
//
//  Created by Admin on 2/20/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "Container.h"


@interface Container()




@end

@implementation Container

static Container* _theContainer = nil;
static CLGeocoder* _geocoder = nil;

@synthesize cityString = _cityString;
@synthesize stateString = _stateString;
@synthesize location = _location;
@synthesize radius = _radius;
@synthesize countryString = _countryString;
@synthesize isUpdating = _isUpdating;

+ (CLGeocoder*) currentGeocoder{
    if(!_geocoder){
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}

+ (Container*) theContainer{
    return _theContainer;
}

+ (void) startUpdatingWithLocation:(CLLocation *)location{
    Container* isValidCheck = [Container theContainer];
    if(isValidCheck){
        isValidCheck.isUpdating = YES;
    }
    [[self currentGeocoder] reverseGeocodeLocation:location completionHandler:^(NSArray* placemarks, NSError *error){
        _theContainer = [[Container alloc]initWithLocation:location andPlacemark:placemarks[0]];
        NSLog(@"%@",error.localizedDescription);
        [[NSNotificationCenter defaultCenter]postNotificationName:CONTAINER_UPDATED_NOTIFICATION object:_theContainer];
        _theContainer.isUpdating = NO;
    }];
}

- (id) initWithLocation:(CLLocation*) location andPlacemark:(CLPlacemark*)placemark{
    self = [self init];
    if(self){
        self.location = location;
        self.cityString = placemark.locality;
        self.stateString = placemark.administrativeArea;
        self.countryString = placemark.ISOcountryCode;
        self.radius = 5;
        
    }
    return self;
}

- (int) radius{
    return self.searchObject.radius ? self.searchObject.radius : _radius;
}


@end
