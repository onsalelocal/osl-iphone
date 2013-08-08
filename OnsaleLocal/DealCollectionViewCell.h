//
//  DealCollectionViewCell.h
//  OnsaleLocal
//
//  Created by Jon on 6/4/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (strong, nonatomic) IBOutlet UILabel *dealName;
@property (strong, nonatomic) IBOutlet UILabel *dealShortDescription;
@property (strong, nonatomic) IBOutlet UILabel *storeName;
@property (strong, nonatomic) IBOutlet UILabel *distanceToLocation;

@end
