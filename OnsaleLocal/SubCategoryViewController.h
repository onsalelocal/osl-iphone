//
//  SubCategoryViewController.h
//  OnsaleLocal
//
//  Created by Admin on 2/12/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SubCategoryViewController : UIViewController

@property (strong, nonatomic) NSArray* items;
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) NSString* currentCategory;
@property (strong, nonatomic) NSString* currentStore;
@property (strong, nonatomic) IBOutlet UIView* placeholderView;
@property (assign, nonatomic) int ls;

- (IBAction)revealMenu:(id)sender;

- (IBAction)revealUnderRight:(id)sender;

@end
