//
//  FollowingTableViewCell.m
//  OnsaleLocal
//
//  Created by Jon on 7/23/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "FollowingTableViewCell.h"
#import "OnsaleLocalConstants.h"

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
        dispatch_async(dispatch_get_main_queue(), ^{
            self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",details[USER_FIRST_NAME], details[USER_LAST_NAME]];
        });
        //self.locationLabel.text = [NSString stringWithFormat:details[USER_]]
    }
}

@end
