//
//  RegisterViewController.m
//  OnsaleLocal
//
//  Created by Admin on 6/22/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "RegisterViewController.h"
#import "BSKeyboardControls.h"
#import "OnsaleLocalConstants.h"
#import "Container.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

@interface RegisterViewController ()<UITextFieldDelegate, BSKeyboardControlsDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate, UITextViewDelegate>

@property (strong, nonatomic) BSKeyboardControls *keyboardControls;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *reEnterPassword;
@property (weak, nonatomic) IBOutlet UITextField *zipcode;
@property (strong, nonatomic) NSArray* fields;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (assign, nonatomic) BOOL first;
@property (strong, nonatomic) NSMutableData* responseData;

- (IBAction)enterPressed:(id)sender;
@end

@implementation RegisterViewController

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
    self.fields = @[self.firstName,self.lastName,self.email,self.password,self.reEnterPassword,self.zipcode];
    for(UITextField* field in self.fields){
        field.userInteractionEnabled = YES;
    }
    self.keyboardControls = [[BSKeyboardControls alloc]initWithFields:self.fields];
    self.keyboardControls.delegate = self;
    self.first = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls

{
    [UIView animateWithDuration:.3 animations:^{
        int keyboardOffset = 290;
        CGSize size = self.scrollView.contentSize;
        size.height -= keyboardOffset;
        self.scrollView.contentSize = size;
    }];
    self.first = NO;
    
    [keyboardControls.activeField resignFirstResponder];
}

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    int keyboardOffset = 290;
    if(!self.first){
        CGSize size = self.scrollView.contentSize;
        size.height += keyboardOffset;
        self.scrollView.contentSize = size;
        self.first = YES;
    }
    
    CGRect rect = field.frame;
    rect.origin.y = rect.origin.y + keyboardOffset;
    
    [self.scrollView scrollRectToVisible:rect animated:YES];
}

#pragma mark- TextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.keyboardControls setActiveField:textField];
    [self keyboardControls:self.keyboardControls selectedField:textField inDirection:nil];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

- (IBAction)enterPressed:(id)sender {
    /*
     NSDictionary* _params = @{@"firstName":self.firstName.text,
     @"lastName":self.lastName.text,
     @"login":self.email.text,
     @"password":self.password.text,
     @"zipcode":self.zipcode.text,
     @"deviceId":[[[UIDevice currentDevice]identifierForVendor] UUIDString]};
     */
#warning encrypt password
    NSDictionary* d = @{@"firstName":@"firstName",
                        @"lastName":@"lastName",
                        @"password":@"password",
                        @"login":@"email@email.com",
                        @"zipcode":@"12345"};
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://onsalelocal.com/osl2/ws/user/register"]];
    NSUUID* uuid = [[UIDevice currentDevice]identifierForVendor];
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString* userID = d[@"email"];//[[NSUserDefaults standardUserDefaults]objectForKey:d[@"email"]];
    NSString *header = [NSString stringWithFormat:@"ios;%@;%@;%@;%f;%f;%ld",[uuid UUIDString], version, userID,0.0, 0.0, (long)[[NSDate date]timeIntervalSince1970]];
    NSString* s = @"firstName=firstName&lastName=lastName&password=password&login=email@email.com&zipcode=12345";
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [s dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:header forHTTPHeaderField:@"Reqid"];
    //[request setValue:@"text/plain"/*@"application/x-www-form-urlencoded"*/ forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPShouldHandleCookies:YES];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [[s dataUsingEncoding:NSUTF8StringEncoding] length]];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    
    NSURLConnection *c = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    [[NSUserDefaults standardUserDefaults] setValue:self.email.text forKey:USER_EMAIL];
    [[NSUserDefaults standardUserDefaults] setValue:d[USER_PASSWORD] forKey:USER_PASSWORD];
    [[NSUserDefaults standardUserDefaults] setValue:d[USER_FIRST_NAME] forKey:USER_FIRST_NAME];
    [[NSUserDefaults standardUserDefaults] setValue:d[USER_LAST_NAME] forKey:USER_LAST_NAME];
    
    

}
- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:USER_LOGGED_IN];
    NSError* error;
    NSDictionary* d = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
    if(error)
        NSLog(@"%@",error.localizedDescription);
    else
        [[NSUserDefaults standardUserDefaults] setValue:d[USER_ID] forKey:USER_ID];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.loginDelegate didFinishLoggingIn:self.parentViewController];
    //NSLog(@"%@",)
    
    
}

#pragma mark - NSURLConnection delegates

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSDictionary* d = [((NSHTTPURLResponse*)response) allHeaderFields];
    NSLog(@"%@",d);
    NSString* s = [d[@"Set-Cookie"] componentsSeparatedByString:@";"][0];
    [[NSUserDefaults standardUserDefaults] setValue:s forKey:@"cookie"];
    self.responseData = [[NSMutableData alloc] init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Failed to fetch data");
    //[textView setString:@"Unable to fetch data"];
    
}
@end
