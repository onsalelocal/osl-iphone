//
//  SearchResultsCell.m
//  OnsaleLocal
//
//  Created by Admin on 1/27/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "SearchResultsCell.h"
#import "Deal.h"
#import "MyEGOCache.h"

@interface SearchResultsCell()



@end

@implementation SearchResultsCell


@synthesize resultDataDict = _resultDataDict;

@synthesize nameLabel = _nameLabel;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize storeName = _storeName;
@synthesize thumbnail = _thumbnail;
@synthesize cityAndDistance = _cityAndDistance;
@synthesize description = _description;

-(void) setResultDataDict:(NSDictionary *)resultDataDict{
    if(_resultDataDict != resultDataDict){
        //use the Dict to populate the cell IBOutlets
    }
}

- (void)layoutSubviews {
    
    
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(5,12,80,80);
    CGPoint center = self.imageView.center;
    center.y = self.frame.size.height / 2;
    self.imageView.center = center;
    float limgW =  self.imageView.image.size.width;
    if(limgW > 0) {
        self.textLabel.frame = CGRectMake(55,self.textLabel.frame.origin.y,self.textLabel.frame.size.width,self.textLabel.frame.size.height);
        self.detailTextLabel.frame = CGRectMake(55,self.detailTextLabel.frame.origin.y,self.detailTextLabel.frame.size.width,self.detailTextLabel.frame.size.height);
    }

}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
    }
    return self;
            
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
