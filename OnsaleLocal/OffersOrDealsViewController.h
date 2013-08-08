//
//  OffersOrDealsViewController.h
//  OnsaleLocal
//
//  Created by Admin on 3/25/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OffersOrDealsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *localOfferButton;
@property (weak, nonatomic) IBOutlet UIButton *weeklyDealButton;


- (IBAction)revealMenu:(id)sender;
- (IBAction)revealUnderRight:(id)sender;
@end
