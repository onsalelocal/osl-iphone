//
//  RegestrationViewController.h
//  OnsaleLocal
//
//  Created by Admin on 2/17/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegestrationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *zipTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

- (IBAction)buttonPressed:(id)sender;
@end
