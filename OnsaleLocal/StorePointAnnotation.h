//
//  StorePointAnnotation.h
//  OnsaleLocal
//
//  Created by Jon on 7/31/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface StorePointAnnotation : MKPointAnnotation

@property (strong, nonatomic) NSDictionary* storeDict;
@property (strong, nonatomic) NSString* storeName;

-(id)initWithStoreDictionary:(NSDictionary*) storeDict;


@end
