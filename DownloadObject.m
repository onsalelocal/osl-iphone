//
//  DownloadObject.m
//  OnsaleLocal
//
//  Created by Jon on 7/17/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "DownloadObject.h"

@implementation DownloadObject

- (void) beginConnectionWithURL:(NSString*)urlString{
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
- (void) beginConnectionWithRequest:(NSURLRequest*)request{
    //NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void) beginConnection2WithURL:(NSString*)urlString{
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    self.connection2 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
- (void) beginConnection2WithRequest:(NSURLRequest*)request{
    //NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    self.connection2 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"%@", error.localizedDescription);
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    if(connection == self.connection){
        self.data = [[NSMutableData alloc]init];
    }
    if(connection == self.connection2){
        self.data2 = [[NSMutableData alloc]init];
    }
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if(connection == self.connection){
        [self.data appendData:data];
    }
    if(connection == self.connection2){
        [self.data2 appendData:data];
    }
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSError* error;
    if(connection == self.connection){
        
        NSString* txt = [[NSString alloc]initWithData:self.data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",txt);
        NSDictionary* userDetails = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
        if(error)
            NSLog(@"%@",error.localizedDescription);
        self.dataObject = userDetails;
        [[NSNotificationCenter defaultCenter] postNotificationName:DATA_OBJECT_ONE_DONE object:self userInfo:@{@"key":self.dataObject}];
    }
    if(connection == self.connection2){
        NSDictionary* userDetails = [NSJSONSerialization JSONObjectWithData:self.data2 options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
        if(error)
            NSLog(@"%@",error.localizedDescription);
        self.dataObject2 = userDetails;
        [[NSNotificationCenter defaultCenter] postNotificationName:DATA_OBJECT_TWO_DONE object:self userInfo:@{@"key":self.dataObject2}];
    }
}


@end
