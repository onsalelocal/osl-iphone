//
//  MyEGOCache.m
//  OnsaleLocal
//
//  Created by Admin on 1/28/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "MyEGOCache.h"

@implementation MyEGOCache

@synthesize keys = _keys;
//@synthesize count = _count;

-(int) count{
    return [self.keys count];
}


- (instancetype)initWithCacheDirectory:(NSString *)cacheDirectory{
    self = [super initWithCacheDirectory:cacheDirectory];
    if (self){
        _keys = [[NSMutableArray alloc]init];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self){
        _keys = [[NSMutableArray alloc]init];
    }
    return self;
}

- (NSMutableArray*) keys{
    for(NSString* key in _keys){
        [self objectForKey:key];
    }
    return _keys;
}

- (id<NSCoding>)objectForKey:(NSString*)key{
    id<NSCoding> obj = [super objectForKey:key];
    if(!obj){
        [_keys removeObject:key];
    }
    return obj;
}
- (void)setObject:(id<NSCoding>)anObject forKey:(NSString*)key{
    [super setObject:anObject forKey:key];
    [_keys addObject:key];
}
- (void)setObject:(id<NSCoding>)anObject forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval{
    [super setObject:anObject forKey:key withTimeoutInterval:timeoutInterval];
    [_keys addObject:key];
    
}


@end
