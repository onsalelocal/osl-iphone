//
//  SearchObject.h
//  OnsaleLocal
//
//  Created by Jon on 6/17/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchObject : NSObject

@property (strong, nonatomic) NSArray* storeNamesArray;
@property (strong, nonatomic) NSString* keyWords;
@property (assign, nonatomic) int radius;
@property (strong, nonatomic) NSArray* tagStringsArray;



@end
