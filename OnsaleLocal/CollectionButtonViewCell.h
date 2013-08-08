//
//  CollectionButtonViewCell.h
//  OnsaleLocal
//
//  Created by Jon on 6/13/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionButtonViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIView *greyView;
@property (weak, nonatomic) IBOutlet UIButton *storeButton;
@property (weak, nonatomic) IBOutlet UIImageView* imageView;

- (void) setup;
@end
