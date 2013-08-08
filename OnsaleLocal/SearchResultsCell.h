//
//  SearchResultsCell.h
//  OnsaleLocal
//
//  Created by Admin on 1/27/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@class Deal;

@interface SearchResultsCell : UITableViewCell

@property (strong, nonatomic) UILabel* nameLabel;
@property (strong, nonatomic) TTTAttributedLabel* descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel* storeName;
@property (strong, nonatomic) IBOutlet UIImageView* thumbnail;
@property (strong, nonatomic) IBOutlet UILabel* cityAndDistance;
@property (strong, nonatomic) NSDictionary* resultDataDict;
@property (strong, nonatomic) NSString* description;

//- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier deal:(Deal*) deal;


@end
