//
//  DetailViewAnnotation.h
//  OnsaleLocal
//
//  Created by Jon on 6/13/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface DetailViewAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic) NSDictionary* dealDict;

@end
