//
//  PersonalInfoObject.h
//  OnsaleLocal
//
//  Created by Jon on 6/21/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalInfoObject : NSObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSString* email;
@property (strong, nonatomic) NSString* password;
@property (assign, nonatomic) BOOL sendNotificationsOK;
@property (assign, nonatomic) BOOL isMale;
@property (strong, nonatomic) NSString* zipcode;
@property (strong, nonatomic) NSData* avatarImageData;

@end
