//
//  MultiSelectionPickerViewController.h
//  OnsaleLocal
//
//  Created by Admin on 2/8/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALPickerView.h"
#import "PickerViewController.h"

@interface MultiSelectionPickerViewController : UIViewController<ALPickerViewDelegate>

@property (strong, nonatomic) ALPickerView* pickerView;
@property (strong, nonatomic) NSArray* items;
@property (strong, nonatomic) id<PassBack> delegate;

- (IBAction)donePressed:(id)sender;
- (IBAction)cancelPressed:(id)sender ;

@end
