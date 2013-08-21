//
//  FollowingTableViewCell.m
//  OnsaleLocal
//
//  Created by Jon on 7/23/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "FollowingTableViewCell.h"
#import "OnsaleLocalConstants.h"
#import "UIImageView+WebCache.h"

@implementation FollowingTableViewCell

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

-(void)setDetails:(NSDictionary *)details{
    if(_details != details){
        _details = details;
        NSLog(@"%@",details);
        /*
        dispatch_async(dispatch_get_main_queue(), ^{
            self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",details[USER_FIRST_NAME], details[USER_LAST_NAME]];
        });
         */
        //self.locationLabel.text = [NSString stringWithFormat:details[USER_]]
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",details[USER][USER_FIRST_NAME],details[USER][USER_LAST_NAME]];
        NSLog(@"%@",self.nameLabel.text);
        [self.imageView1 setImageWithURL:[NSURL URLWithString:details[USER][@"img"]] completed:nil];
        self.imageView1.backgroundColor = [UIColor redColor];
    }
}

-(void)layoutSubviews{
    self.imageView1.frame = CGRectMake(6, 13, 75, 75);
    self.nameLabel.frame = CGRectMake(89, 20, 134, 21);
}
@end
