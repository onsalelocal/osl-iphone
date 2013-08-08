//
//  StoreCollectionCell.m
//  OnsaleLocal
//
//  Created by Jon on 6/5/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "StoreCollectionCell.h"

@implementation StoreCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)hideImage:(BOOL)hideImage{
    self.imageView.hidden = hideImage;
    self.nameLabel.hidden = !hideImage;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
