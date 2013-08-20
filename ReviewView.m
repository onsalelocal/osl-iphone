//
//  ReviewView.m
//  OnsaleLocal
//
//  Created by Jon on 7/23/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "ReviewView.h"
#import "OnsaleLocalConstants.h"

@implementation ReviewView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithInfoDict:(NSDictionary*) infoDict{
    self = [self initWithFrame:CGRectZero];
    if (self){
        self.backgroundColor = [UIColor whiteColor];
        self.infoDict = infoDict;
    }
    return self;
}

- (void) setInfoDict:(NSDictionary *)infoDict{
    if(infoDict!=_infoDict){
        _infoDict = infoDict;
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, 149, 21)];
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",infoDict[@"user"][USER_FIRST_NAME], infoDict[@"user"][USER_LAST_NAME]];
        self.nameLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        [self addSubview:self.nameLabel];
#warning fix this label's text
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(165, 0, 107, 21)];
        self.timeLabel.text = [NSString stringWithFormat:@"about an hour ago"];
        self.timeLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        [self addSubview:self.timeLabel];
        
        NSString *text = infoDict[@"content"];
        CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13] constrainedToSize:CGSizeMake(270, 999) lineBreakMode:NSLineBreakByWordWrapping];
        self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 24, size.width, size.height)];
        self.textLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.numberOfLines = 0;
        self.textLabel.text = text;
        [self addSubview:self.textLabel];
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 280, CGRectGetMaxY(self.textLabel.frame) + 10);
    }
}

@end
