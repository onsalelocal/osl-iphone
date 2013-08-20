//
//  FirstDetailCell.h
//  OnsaleLocal
//
//  Created by Jon on 6/12/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface FirstDetailCell : UITableViewCell

@property (strong, nonatomic) NSDictionary* dealDict;
@property (strong, nonatomic) id<cellMethods> cellMethodsDelegate;

@end
