//
//  InviteFriendsViewController.h
//  OnsaleLocal
//
//  Created by Admin on 1/29/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "UnderRightViewController.h"

@interface InviteFriendsViewController : UITableViewController

@property (assign, nonatomic) BOOL like;
@property (strong, nonatomic) NSString* itemLikeDescription;

@end
