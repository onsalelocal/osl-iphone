//
//  DetailViewAnnotation.m
//  OnsaleLocal
//
//  Created by Jon on 6/13/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "DetailViewAnnotation.h"
#import "OnsaleLocalConstants.h"

@implementation DetailViewAnnotation

-(NSString*) title{
    return self.dealDict[DEAL_TITLE];
}

-(CLLocationCoordinate2D) coordinate{
    CLLocationCoordinate2D coordinate1 = CLLocationCoordinate2DMake([self.dealDict[DEAL_LAT]doubleValue], [self.dealDict[DEAL_LONG]doubleValue]);
    return coordinate1;
}

@end
