//
//  StoreCommentViewController.h
//  OnsaleLocal
//
//  Created by Jon on 7/25/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreCommentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *dealName;
@property (weak, nonatomic) IBOutlet UILabel *whenLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic) NSDictionary* infoDict;

@end
