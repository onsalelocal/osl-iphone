//
//  BookmarkCell.m
//  OnsaleLocal
//
//  Created by Admin on 2/15/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "BookmarkCell.h"

@implementation BookmarkCell

@synthesize textLabel1 = _textLabel1;
@synthesize detailTextLabel1 = _detailTextLabel1;
@synthesize imageView1 = _imageView1;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.imageView.frame = CGRectMake(5,12,80,80);
        self.textLabel.frame = CGRectMake(90,self.textLabel.frame.origin.y,self.frame.size.width-100,self.textLabel.frame.size.height);
        self.detailTextLabel.frame = CGRectMake(90,self.detailTextLabel.frame.origin.y,self.frame.size.width-100,self.detailTextLabel.frame.size.height);
        //self.autoresizesSubviews = NO;
        //self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        //[self.imageView setAutoresizingMask:UIViewAutoresizingNone];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) layoutSubviews{
    
    //[self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [super layoutSubviews];

    self.imageView.frame = CGRectMake(5,12,80,80);
    float limgW =  self.imageView.image.size.width;
    if(limgW > 0) {
        self.textLabel.frame = CGRectMake(90,self.textLabel.frame.origin.y,self.frame.size.width-100,self.textLabel.frame.size.height);
        self.detailTextLabel.frame = CGRectMake(90,self.detailTextLabel.frame.origin.y,self.frame.size.width-100,self.detailTextLabel.frame.size.height);

    }


}

@end
