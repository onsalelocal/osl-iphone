//
//  SettingsViewController.m
//  OnsaleLocal
//
//  Created by Jon on 6/21/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "SettingsViewController.h"
#import "BSKeyboardControls.h"
#import "PersonalInfoObject.h"
#import "OnsaleLocalConstants.h"

@interface SettingsViewController ()<UITextFieldDelegate, UITextViewDelegate, BSKeyboardControlsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (strong, nonatomic) BSKeyboardControls* keyboardControls;
@property (strong, nonatomic) NSArray* fields;
@property (assign, nonatomic) BOOL first;
@property (strong, nonatomic) NSURLConnection* connection;
@property (strong, nonatomic) NSMutableData* data;
@property (strong, nonatomic) NSURLConnection* avatarConnection;
@property (strong, nonatomic) NSMutableData* avatarData;

@end

@implementation SettingsViewController

@synthesize  infoObject = _infoObject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
/*
-(NSMutableDictionary*)infoObject{
    
    return _infoObject;
}
*/

-(NSMutableDictionary*) infoObject{
    if(!_infoObject){
        _infoObject = [[NSMutableDictionary alloc]init];
    }
    return _infoObject;
}
- (void)setInfoObject:(NSMutableDictionary *)infoObject{
    if(infoObject!=_infoObject){
        _infoObject = infoObject;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.fields = [NSArray arrayWithObjects:self.emailTextField, self.passwordTextField, self.confirmPasswordTextField,
                   self.firstName, self.lastName, self.zipcode, nil];
    self.keyboardControls = [[BSKeyboardControls alloc]initWithFields:self.fields];
    [self.keyboardControls setDelegate:self];
    self.first = NO;
    if(!self.infoObject){
        self.infoObject = [[NSUserDefaults standardUserDefaults] objectForKey:PERSONAL_INFO_OBJECT];
    }
    if(self.infoObject){
        [self setupView];
    }else{
#warning send outurl request
        //NSString* stringURL =
        
    }
    
}

- (void) setupView{
    self.emailTextField.text = self.infoObject[USER_EMAIL];
    self.firstName.text = self.infoObject[USER_FIRST_NAME];
    self.lastName.text = self.infoObject[USER_LAST_NAME];
    self.zipcode.text = self.infoObject[USER_ZIP_CODE];
    self.imageView.image = [UIImage imageWithData:self.infoObject[@"avatarImageData"]];
    if(self.infoObject[@"isMale"]){
        [self.maleFemaleSegmentedControl setSelectedSegmentIndex:0];
    }else{
        [self.maleFemaleSegmentedControl setSelectedSegmentIndex:1];
    }
    [self.notificationsSwitch setOn:self.infoObject[@"sendNotificationsOK"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeButtonPressed:(id)sender {
    UIImagePickerController* picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
}

- (IBAction)saveButtonPressed:(id)sender {
#warning send to server also
    [[NSUserDefaults standardUserDefaults] setObject:self.infoObject forKey:PERSONAL_INFO_OBJECT];
}

- (IBAction)cancelButtonPressed:(id)sender {
    for(UITextField* field in self.fields){
        field.text = nil;
    }
}



- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls

{
    int keyboardOffset = 270;
    
    CGSize size = self.scrollView.contentSize;
    size.height -= keyboardOffset;
    self.scrollView.contentSize = size;
    self.first = NO;
    
    [keyboardControls.activeField resignFirstResponder];
}

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    int keyboardOffset = 270;
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


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.imageView.image = [UIImage imageWithData:info[UIImagePickerControllerOriginalImage]];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - NSURLConnection Delegates
#warning need to implement this
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    if(connection == self.connection){
        self.data = [NSMutableData data];
    }
    else if(connection == self.avatarConnection){
        self.avatarData = [NSMutableData data];
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if(connection == self.connection){
        [self.data appendData:data];
    }
    else if(connection == self.avatarConnection){
        [self.avatarData appendData:data];
    }
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSError* error;
    if(connection == self.connection){
        
        [self.infoObject addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error]];
        
    }
    else if(connection == self.avatarConnection){
        self.infoObject[@"avatarImageData"] = self.avatarData;
    }
    [[NSUserDefaults standardUserDefaults] setValue:self.infoObject forKey:PERSONAL_INFO_OBJECT];
    [self setupView];
}

@end
