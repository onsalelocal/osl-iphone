//
//  StoreObject.m
//  OnsaleLocal
//
//  Created by Jon on 7/1/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "StoreObject.h"

@implementation StoreObject

- (NSString*) formatForRequest{
    NSString* s = [NSString stringWithFormat:@"merchant=%@&address=%@&city=%@&state=%@&country=%@&latitude=%f&longitude=%f&phone=%@",
                    self.name,
                    self.address,
                    self.city,
                    self.state,
                    self.country,
                    self.location.coordinate.latitude,
                    self.location.coordinate.longitude,
                   self.phone];
    return s;
}


@end
