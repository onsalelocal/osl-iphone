//
//  StoreCommentCell.m
//  OnsaleLocal
//
//  Created by Jon on 7/25/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "StoreCommentCell.h"
#import "OnsaleLocalConstants.h"

@implementation StoreCommentCell

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

-(void) setInfoDict:(NSDictionary *)infoDict{
    if(_infoDict != infoDict){
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",infoDict[USER_FIRST_NAME], infoDict[USER_LAST_NAME]];
        self.whenLabel.text = @"when";
        self.dealNameLabel.text = @"Deal Name";
        self.commentLabel.text = infoDict[@"content"];
        
    }
}

@end
