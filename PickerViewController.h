//
//  PickerViewController.h
//  OnsaleLocal
//
//  Created by Admin on 2/7/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALPickerView.h"
#import "ALPickerViewCell.h"
@protocol PassBack <NSObject>

- (void) passBack: (id)object;//should be array

@end

@interface PickerViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) id<PassBack> delegate;
@property (strong, nonatomic) NSArray* items;
//@property (assign, nonatomic) BOOL canSelectMultipleItems;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end
