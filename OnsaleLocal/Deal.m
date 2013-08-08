//
//  Deal.m
//  OnsaleLocal
//
//  Created by Admin on 1/29/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//


#import "OnsaleLocalConstants.h"
#import "Deal.h"
#import "MyEGOCache.h"

@implementation Deal

@synthesize name = _name;
@synthesize deal = _deal;
@synthesize store = _store;
@synthesize imageURL = _imageURL;
@synthesize cityAndDistanceString = _cityAndDistanceString;
@synthesize dealID = _dealID;

-(id) initWithContentsOfDictionary:(NSDictionary *)dealDict{
    self = [super init];
    if(self){
        _name = dealDict[DEAL_TITLE];
        _dealID = dealDict[DEAL_ID];
        //if(DEBUG) NSLog(@"%@", dealDict[DEAL_PRICE]);
        _deal =   dealDict[DEAL_PRICE];
        _store = dealDict[DEAL_STORE];
        _imageURL = dealDict[DEAL_IMAGE_URL];
        _largeImageURL = dealDict[DEAL_LARGE_IMAGE_URL];
        if(!_imageURL) _imageURL = _largeImageURL;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.roundingIncrement = [NSNumber numberWithDouble:0.01];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        _cityAndDistanceString = [NSString stringWithFormat:@"%@ : %@ Miles Away",dealDict[DEAL_CITY], [formatter stringFromNumber:[NSNumber numberWithFloat:[dealDict[DEAL_DISTANCE] floatValue]]]];
    }
    return self;
}

@end
