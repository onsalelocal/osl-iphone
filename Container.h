//
//  Container.h
//  OnsaleLocal
//
//  Created by Admin on 2/20/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
//#import "SearchObject.h"

#define CONTAINER_UPDATED_NOTIFICATION @"containerUpdatedNotification"

#import "SearchObject.h"


@interface Container : NSObject

@property (assign, nonatomic) int radius;
@property (strong, nonatomic) NSString* cityString;
@property (strong, nonatomic) NSString* stateString;
@property (strong, nonatomic) NSString* countryString;
@property (strong, nonatomic) CLLocation* location;
@property (assign, nonatomic) BOOL isUpdating;
@property (strong, nonatomic) SearchObject* searchObject;

+ (void) startUpdatingWithLocation:(CLLocation *)location;

+ (Container*) theContainer;

- (id) initWithLocation:(CLLocation*) location andPlacemark:(CLPlacemark*)placemark;

@end
