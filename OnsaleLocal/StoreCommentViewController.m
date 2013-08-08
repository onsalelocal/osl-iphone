//
//  StoreCommentViewController.m
//  OnsaleLocal
//
//  Created by Jon on 7/25/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "StoreCommentViewController.h"
#import "OnsaleLocalConstants.h"

@interface StoreCommentViewController ()

@end

@implementation StoreCommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.infoDict = self.infoDict;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setInfoDict:(NSDictionary *)infoDict{
    
    self.userName.text = [NSString stringWithFormat:@"%@ %@",infoDict[USER_FIRST_NAME], infoDict[USER_LAST_NAME]];
    self.whenLabel.text = @"when";
    self.dealName.text = @"Deal Name";
    self.contentTextView.text = infoDict[@"content"];
    self.navigationController.title = infoDict[STORE_LOOKUP_NAME];
    
}

@end
