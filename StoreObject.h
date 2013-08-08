//
//  StoreObject.h
//  OnsaleLocal
//
//  Created by Jon on 7/1/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface StoreObject : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) CLLocation* location;
@property (strong, nonatomic) NSString* address;
@property (strong, nonatomic) NSString* city;
@property (strong, nonatomic) NSString* state;
@property (strong, nonatomic) NSString* country;
@property (strong, nonatomic) NSString* phone;

- (NSString*) formatForRequest;

@end
