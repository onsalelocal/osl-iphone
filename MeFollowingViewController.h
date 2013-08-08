//
//  MeFollowingViewController.h
//  OnsaleLocal
//
//  Created by Admin on 6/21/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeViewController.h"

@interface MeFollowingViewController : MeViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)likePressed:(id)sender;
@end
