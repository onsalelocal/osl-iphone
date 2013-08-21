//
//  SecondDetailCell.h
//  OnsaleLocal
//
//  Created by Jon on 6/12/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondDetailCell : UITableViewCell <NSURLConnectionDataDelegate, NSURLConnectionDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *fromWhoLabel;
@property (weak, nonatomic) IBOutlet UILabel *howLongAgoLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (strong, nonatomic) NSDictionary* dealDict;

- (IBAction)followButtonPressed:(id)sender;
@end
