//
//  StorePointAnnotation.m
//  OnsaleLocal
//
//  Created by Jon on 7/31/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "StorePointAnnotation.h"
#import "OnsaleLocalConstants.h"

@implementation StorePointAnnotation

-(id)initWithStoreDictionary:(NSDictionary *)storeDict{
    self = [self init];
    if(self){
        self.storeDict = storeDict;
    }
    return self;
}

-(void) setStoreDict:(NSDictionary *)storeDict{
    if(_storeDict != storeDict){
        _storeDict = storeDict;
        self.coordinate = CLLocationCoordinate2DMake([_storeDict[STORE_LAT] doubleValue], [_storeDict[STORE_LONG] doubleValue]);
        self.storeName = _storeDict[STORE_LOOKUP_NAME];
        self.title = self.storeName;
        
    }
}

@end
