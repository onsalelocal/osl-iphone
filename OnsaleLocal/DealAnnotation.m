//
//  DealAnnotation.m
//  OnsaleLocal
//
//  Created by Admin on 2/5/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "DealAnnotation.h"
#import "OnsaleLocalConstants.h"

@implementation DealAnnotation

@synthesize dealDict = _dealDict;

+ (DealAnnotation *)annotationForDeal:(NSDictionary *)dealDict
{
    DealAnnotation *annotation = [[DealAnnotation alloc] init];
    annotation.dealDict = dealDict;
    return annotation;
}

#pragma mark - MKAnnotation

- (NSString *)title
{
    return [self.dealDict objectForKey:DEAL_TITLE];
}

- (NSString *)subtitle
{
    return [NSString stringWithFormat:@"%@",[self.dealDict valueForKeyPath:DEAL_PRICE]];
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.dealDict objectForKey:DEAL_LAT] doubleValue];
    coordinate.longitude = [[self.dealDict objectForKey:DEAL_LONG] doubleValue];
    return coordinate;
}

@end
