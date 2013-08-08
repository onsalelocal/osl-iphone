//
//  DealAnnotation.h
//  OnsaleLocal
//
//  Created by Admin on 2/5/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface DealAnnotation : NSObject <MKAnnotation>

+ (DealAnnotation *)annotationForDeal:(NSDictionary *)dealDict; // Flickr photo dictionary

@property (nonatomic, strong) NSDictionary *dealDict;


@end
