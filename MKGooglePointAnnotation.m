//
//  MKGooglePointAnnotation.m
//  OnsaleLocal
//
//  Created by Admin on 3/13/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "MKGooglePointAnnotation.h"
#import "JSONKit.h"
#import "AFJSONRequestOperation.h"
#import "OnsaleLocalConstants.h"

@interface MKGooglePointAnnotation()

@property (assign, nonatomic) BOOL isReady;

@end

@implementation MKGooglePointAnnotation

@synthesize isReady = _isReady;
@synthesize reference = _reference;

- (void) setReference:(NSString *)reference{
    if(_reference != reference){
        _reference = reference;
        self.isReady = NO;
        NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?&sensor=true&key=%@&reference=%@",GOOGLE_PLACES_KEY, reference];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSLog(@"%@",JSON);
            NSDictionary* result = [JSON objectForKey:@"result"];
            NSLog(@"%@",result);

            
            NSString* address = [result objectForKey:@"formatted_address"];
            
            NSNumber* lat = result[@"geometry"][@"location"][@"lat"];
            NSNumber* lon = result[@"geometry"][@"location"][@"lng"];
            
            
            self.title = address;
            CLLocationCoordinate2D c = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
            self.coordinate = c;
            self.isReady = YES;
            
            
        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id obj) {
            NSLog(@"failure %@", [error localizedDescription]);
        }];
        [AFHTTPRequestOperation addAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil]];
        [operation start];
    }
}

                                             

@end
