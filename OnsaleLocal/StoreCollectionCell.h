//
//  StoreCollectionCell.h
//  OnsaleLocal
//
//  Created by Jon on 6/5/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
-(void)hideImage:(BOOL)hideImage;
@end
