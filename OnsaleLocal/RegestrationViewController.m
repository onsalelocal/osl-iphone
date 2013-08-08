//
//  RegestrationViewController.m
//  OnsaleLocal
//
//  Created by Admin on 2/17/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "RegestrationViewController.h"
#import "ECSlidingViewController.h"
#import "OnsaleLocalConstants.h"

@interface RegestrationViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) NSString* emailString;
@property (strong, nonatomic) NSString* zipString;
@property (strong, nonatomic) UIAlertView* alert;
//@property (assign, nonatomic) BOOL zipOK, emailOK;

- (IBAction)buttonPressed:(id)sender;
@end

@implementation RegestrationViewController

@synthesize emailTextField = _emailTextField;
@synthesize zipTextField = _zipTextField;
@synthesize emailString = _emailString;
@synthesize zipString = _zipString;
@synthesize alert = _alert;
//@synthesize zipOK = _zipOK, emailOK = _emailOK;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender {
    [self.emailTextField resignFirstResponder];
    [self.zipTextField resignFirstResponder];
    [self checkEmailAndZipAndDisplayAlert];
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    if(textField == self.emailTextField){
        self.emailString = textField.text;
    }
    else if (textField == self.zipTextField){
        self.zipString = textField.text;
    }
}

- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

#warning Not doing anything with zip code at the momenet
- (void)checkEmailAndZipAndDisplayAlert {
    BOOL emailOK = [self validateEmail:[self.emailTextField text]];
    BOOL zipOK = [self isValidZip];
    if (emailOK && zipOK) {
        [[NSUserDefaults standardUserDefaults] setObject:[self.emailTextField text] forKey:USER_EMAIL];
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeNavigationTop"];
        return;
    }
    NSString* message;
    if(!(emailOK || zipOK)){
        message = @"Please enter a valid email address and five digit zip code.";
    }
    else if (!emailOK){
        message = @"Please enter a valid email address.";
    }
    else if (!zipOK){
        message = @"Please enter a valid five digit zip code";
    }
    // user entered invalid email address
    self.alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [self.alert show];
    
}

- (BOOL) isValidZip{
    return (([self.zipTextField.text intValue] < 100000) &&
            ([self.zipTextField.text length] == 5) &&
            ([self.zipTextField.text intValue] > 500));
    
}


@end
