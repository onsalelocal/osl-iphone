//
//  LoginViewController.h
//  OnsaleLocal
//
//  Created by Jon on 6/11/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Login <NSObject>

- (void)didFinishLoggingIn: (id)loginViewController;

@end

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) id<Login> loginDelegate;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;


- (IBAction)loginPressed:(id)sender;
- (IBAction)registerNowPressed:(id)sender;
- (IBAction)forgotYourPasswordPressed:(id)sender;
- (IBAction)facebookSignInPressed:(id)sender;

@end
