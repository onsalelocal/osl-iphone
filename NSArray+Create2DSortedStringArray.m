//
//  NSArray+Create2DSortedStringArray.m
//  OnsaleLocal
//
//  Created by Admin on 1/31/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "NSArray+Create2DSortedStringArray.h"

@implementation NSArray (Create2DSortedStringArray)

-(NSArray*) create2DSortedStringArray{
    NSMutableArray* twoDArrayOfIndexValues = [[NSMutableArray alloc]init];
    NSArray* sortedAlphabatizedValues = [self sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    //if(DEBUG) NSLog(@"%@", sortedAlphabatizedValues);
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    if(sortedAlphabatizedValues.count > 0){
        [tempArr addObject:sortedAlphabatizedValues[0]];
    }
    for(int i = 1; i<sortedAlphabatizedValues.count; i++){
        NSString* first = [[sortedAlphabatizedValues[i-1] substringToIndex:1]lowercaseString] ;
        NSString* second = [[sortedAlphabatizedValues[i]substringToIndex:1]lowercaseString];
        if([first isEqualToString:second] || ([first intValue] && [second intValue])){
            [tempArr addObject:sortedAlphabatizedValues[i]];
            
        }
        
        else{
            //if(tempArr.count){
            [twoDArrayOfIndexValues addObject:[tempArr copy]];
            [tempArr removeAllObjects];
            [tempArr addObject:sortedAlphabatizedValues[i]];
            //}
        }
    }
    [twoDArrayOfIndexValues addObject:tempArr];
    return twoDArrayOfIndexValues;
}

-(NSArray*) create2DSortedDictionaryArraybyKey: (NSString*)key{
    NSMutableArray* twoDArrayOfIndexValues = [[NSMutableArray alloc]init];
    
    NSArray* sortedAlphabatizedValues = [self sortedArrayUsingComparator:^NSComparisonResult(NSDictionary* dict1, NSDictionary* dict2){
        return [dict1[key] caseInsensitiveCompare: dict2[key]];
    }] ;
    //if(DEBUG) NSLog(@"%@", sortedAlphabatizedValues);
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    [tempArr addObject:sortedAlphabatizedValues[0]];
    for(int i = 1; i<sortedAlphabatizedValues.count; i++){
        NSString* first = [[sortedAlphabatizedValues[i-1][key] substringToIndex:1]lowercaseString] ;
        NSString* second = [[sortedAlphabatizedValues[i][key]substringToIndex:1]lowercaseString];
        if([first isEqualToString:second] || ([first intValue] && [second intValue])){
            [tempArr addObject:sortedAlphabatizedValues[i]];
            
        }
        
        else{
            //if(tempArr.count){
            [twoDArrayOfIndexValues addObject:[tempArr copy]];
            [tempArr removeAllObjects];
            [tempArr addObject:sortedAlphabatizedValues[i]];
            //}
        }
    }
    [twoDArrayOfIndexValues addObject:tempArr];
    return twoDArrayOfIndexValues;
    
    
    
}

@end
