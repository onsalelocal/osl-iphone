//
//  Deal.h
//  OnsaleLocal
//
//  Created by Admin on 1/29/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Deal : NSObject

@property (readonly) NSString* name;
@property (readonly) NSString* deal;
@property (readonly) NSString* store;
@property (readonly) NSString* imageURL;
@property (readonly) NSString* largeImageURL;
@property (readonly) NSString* cityAndDistanceString;
@property (readonly) NSString* dealID;

-(id)initWithContentsOfDictionary:(NSDictionary*) dealDict;


@end
