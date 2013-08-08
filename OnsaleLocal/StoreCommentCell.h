//
//  StoreCommentCell.h
//  OnsaleLocal
//
//  Created by Jon on 7/25/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *whenLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) NSDictionary* infoDict;
@end
