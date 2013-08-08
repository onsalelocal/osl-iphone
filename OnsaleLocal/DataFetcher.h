//
//  DataFetcher.h
//  OnsaleLocal
//
//  Created by Admin on 1/28/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataFetcher : NSObject

+ (NSArray*) genericFetchMax250;

+(NSArray*) fetchFromRequest: (NSString*) request;
+(NSData*) fetchFromRequest1: (NSString*) request;

@end
