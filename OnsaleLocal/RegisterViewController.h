//
//  RegisterViewController.h
//  OnsaleLocal
//
//  Created by Admin on 6/22/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface RegisterViewController : UIViewController
@property (strong, nonatomic) id<Login> loginDelegate;
@end
