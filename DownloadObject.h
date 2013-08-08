//
//  DownloadObject.h
//  OnsaleLocal
//
//  Created by Jon on 7/17/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DATA_OBJECT_ONE_DONE @"DATA_OBJECT_ONE_DONE"
#define DATA_OBJECT_TWO_DONE @"DATA_OBJECT_TWO_DONE"

@interface DownloadObject : NSObject<NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (strong, nonatomic) NSURLConnection* connection;
@property (strong, nonatomic) NSURLConnection* connection2;
@property (strong, nonatomic) NSMutableData* data;
@property (strong, nonatomic) NSMutableData* data2;
@property (strong, nonatomic) id dataObject;
@property (strong, nonatomic) id dataObject2;
//@property (strong, nonatomic) id delegate;
//@property (strong, nonatomic) id delegate2;

- (void) beginConnectionWithURL:(NSString*)urlString;
- (void) beginConnectionWithRequest:(NSURLRequest*)request;


@end
