//
//  CreateDealViewController.h
//  OnsaleLocal
//
//  Created by Jon on 6/17/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateDealViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *dealTitle;
@property (weak, nonatomic) IBOutlet UITextField *originalPrice;
@property (weak, nonatomic) IBOutlet UITextField *discount;
@property (weak, nonatomic) IBOutlet UITextField *storeName;
@property (weak, nonatomic) IBOutlet UITextField *storeAddress;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (weak, nonatomic) IBOutlet UILabel *pictureDirectionsLabel;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *state;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSMutableData* responseData;

- (IBAction)camaraButtonPressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;
- (IBAction)submitPressed:(id)sender;
@end
