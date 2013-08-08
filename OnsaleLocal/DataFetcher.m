//
//  DataFetcher.m
//  OnsaleLocal
//
//  Created by Admin on 1/28/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "DataFetcher.h"
#import "MyEGOCache.h"
#import "OnsaleLocalConstants.h"

static NSMutableDictionary* d;

@implementation DataFetcher

+ (NSDictionary *)executeDataFetch:(NSString *)query
{
    if(!d){
        d = [[NSMutableDictionary alloc]init];
    }
    NSError *error1 = nil;
    EGOCache* cache = [EGOCache globalCache];
    
    NSURL* url = [NSURL URLWithString:query];
    NSData* testData = [cache dataForKey:query];
    //URL encoded using ASCII
    NSString* contents = (NSString*)[cache objectForKey:[NSString stringWithString:query]];
    //NSLog(@"1 %@",cache);
    //NSLog(@"2 %@",query);
    //NSLog(@"3 %@ ------ %@", contents, d[query]);
    if(!testData){
        contents = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error1];
        testData = [contents dataUsingEncoding:NSUTF8StringEncoding];
        [cache setString:contents forKey:query withTimeoutInterval:CACHE_TIMEOUT];
        [cache setData:testData forKey:query withTimeoutInterval:CACHE_TIMEOUT];
        [d setObject:contents forKey:query];
        //NSLog(@"%@", testData);
    }
    //jsonData encoded using UTF8
    NSData *jsonData = testData;
    //NSLog(@"%@",jsonData);
    if (error1){
        NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error1.localizedDescription);
    }
    
    NSError *error = nil;
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    // NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), results);
    //NSLog(@"%@",jsonData);
    //NSLog(@"%@",results);
    return results;
}

+(NSArray*) fetchFromRequest: (NSString*) request{
    NSDictionary* dict = [self executeDataFetch:request];
    return [dict valueForKey:@"items"];
}

+(NSArray*) genericFetchMax250{
    NSString *request = [NSString stringWithFormat:@"http://onsalelocal.com/osl/ws/offer/search?lat=37.774&lng=-122.419&radius=20&format=json"];
    //return [[self executeDataFetch:request] valueForKeyPath:@"photos.photo"];
    NSDictionary* dict = [self executeDataFetch:request];
    //NSLog(@"%@",[dict valueForKey:@"items"]);
    return [dict valueForKey:@"items"];
}

+ (NSData *)executeDataFetch1:(NSString *)query
{
    
    //NSLog(@"%@",query);
    NSError *error1 = nil;
    NSMutableURLRequest* url = [NSURL URLWithString:query];
    
    //URL encoded using ASCII
    
    NSString* contents = [NSString stringWithContentsOfURL:[url copy] encoding:NSASCIIStringEncoding error:&error1];
    NSData* testData = [contents dataUsingEncoding:NSUTF8StringEncoding];
    
    //jsonData encoded using UTF8
    NSData *jsonData = testData;
    return jsonData;
}

+(NSData*) fetchFromRequest1: (NSString*) request{
     return  [self executeDataFetch1:request];
   
}

+(NSArray*) genericFetchMax2501{
    NSString *request = [NSString stringWithFormat:@"http://onsalelocal.com/osl/ws/offer/search?lat=37.774&lng=-122.419&radius=20&format=json"];
    //return [[self executeDataFetch:request] valueForKeyPath:@"photos.photo"];
    NSDictionary* dict = [self executeDataFetch:request];
    //NSLog(@"%@",[dict valueForKey:@"items"]);
    return [dict valueForKey:@"items"];
}


@end
