//
//  SecondDetailCell.m
//  OnsaleLocal
//
//  Created by Jon on 6/12/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "SecondDetailCell.h"

@implementation SecondDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)followButtonPressed:(id)sender {
}

- (void)layoutSubviews {
    
    
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(8,37,48,48);
    CGPoint center = self.imageView.center;
    center.y = self.frame.size.height / 2;
    self.imageView.center = center;
}
@end
