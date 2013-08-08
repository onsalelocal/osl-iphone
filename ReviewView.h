//
//  ReviewView.h
//  OnsaleLocal
//
//  Created by Jon on 7/23/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewView : UIView

@property (strong, nonatomic) UILabel* nameLabel;
@property (strong, nonatomic) UILabel* timeLabel;
@property (strong, nonatomic) UILabel* textLabel;
@property (strong, nonatomic) NSDictionary* infoDict;

- (id) initWithInfoDict:(NSDictionary*) infoDict;

@end
