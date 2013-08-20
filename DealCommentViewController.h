//
//  DealCommentViewController.h
//  OnsaleLocal
//
//  Created by Jon on 8/20/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealCommentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NSDictionary* dealDict;
@property (weak, nonatomic) IBOutlet UILabel *charCountLabel;

- (IBAction)postDealCommentPressed:(id)sender;
@end
