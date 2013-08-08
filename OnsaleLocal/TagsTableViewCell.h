//
//  TagsTableViewCell.h
//  OnsaleLocal
//
//  Created by Jon on 6/12/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagCellProtocal <NSObject>

@optional

- (void) tagPressed:(NSArray*) selectedItems;

@end


@interface TagsTableViewCell : UITableViewCell
@property (strong, nonatomic) NSArray* tags;
@property (assign, nonatomic) int yOffset;
@property (strong, nonatomic) NSMutableArray* tagLabels;
@property (strong, nonatomic) id <TagCellProtocal> delegate;
@property (assign, nonatomic) BOOL canSelectTags;


@end
