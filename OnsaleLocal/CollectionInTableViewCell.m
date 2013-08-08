//
//  CollectionInTableViewCell.m
//  OnsaleLocal
//
//  Created by Jon on 6/13/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "CollectionInTableViewCell.h"

@implementation CollectionInTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //self.greyView.hidden = YES;
        //self.greyView.backgroundColor = [UIColor colorWithWhite:.2 alpha:.2];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setStores:(NSArray *)stores{
    if(_stores != stores)
        _stores = stores;
    
    
    [self.collectionView reloadData];
}

@end
