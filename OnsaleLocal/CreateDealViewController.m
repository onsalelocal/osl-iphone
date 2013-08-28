//
//  CreateDealViewController.m
//  OnsaleLocal
//
//  Created by Jon on 6/17/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "CreateDealViewController.h"
#import "BSKeyboardControls.h"
#import "OnsaleLocalConstants.h"
#import "Container.h"
#import "AFHTTPClient.h"
//#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "AFURLConnectionOperation.h"
#import "StoreLookupViewController.h"

#ifdef __APPLE__
#include "TargetConditionals.h"
#endif

@interface CreateDealViewController () <BSKeyboardControlsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PassBack>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) BSKeyboardControls* keyboardControls;
@property (assign, nonatomic) BOOL first;
@property (strong, nonatomic) NSArray* fields;
@property (strong, nonatomic) NSDictionary* selectedStore;

@end

@implementation CreateDealViewController

- (void) setSelectedStore:(NSDictionary *)selectedStore{
    if(_selectedStore != selectedStore){
        _selectedStore = selectedStore;
        self.storeName.text = selectedStore[STORE_LOOKUP_NAME];
        self.storeAddress.text = selectedStore[STORE_ADDRESS];
        self.city.text = selectedStore[STORE_CITY];
        self.state.text = selectedStore[STORE_STATE];
        self.phoneNumber.text = selectedStore[STORE_PHONE];
    }
}

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
    self.fields = @[self.originalPrice, self.discount, self.dealTitle, self.descriptionField, self.storeName, self.storeAddress, self.city, self.state, self.phoneNumber];
    
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:self.fields]];
    [self.keyboardControls setDelegate:self];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls

{
    int keyboardOffset = 220;
    
    CGSize size = self.scrollView.contentSize;
    size.height -= keyboardOffset;
    self.scrollView.contentSize = size;
    self.first = NO;
     
    [keyboardControls.activeField resignFirstResponder];
}

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    int keyboardOffset = 220;
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}



- (IBAction)camaraButtonPressed:(id)sender {
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];

#if (TARGET_IPHONE_SIMULATOR)
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
#else
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
#endif
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:^{}];
}

- (IBAction)cancelPressed:(id)sender {
    for(UITextField* field in self.fields){
        field.text = nil;
    }
    self.pictureDirectionsLabel.hidden = NO;
    self.imageView.image = nil;
}

- (IBAction)submitPressed:(id)sender {
    
    NSMutableDictionary* _params = [@{DEAL_TITLE:self.dealTitle.text,
                                    DEAL_DESCRIPTION:self.descriptionField.text,
                                    DEAL_PRICE:self.originalPrice.text,
                                    DEAL_DISCOUNT:self.discount.text,
                                    STORE_NAME:self.storeName.text,
                                    STORE_ADDRESS:self.storeAddress.text,
                                    STORE_CITY:self.city.text,
                                    STORE_STATE:self.state.text,
                                    STORE_PHONE:self.phoneNumber.text,
                                    @"country":@"us",
                                    @"tags":@"none"} mutableCopy];
    /*
     NSMutableDictionary* __block _params = [@{DEAL_TITLE:@"title",
     DEAL_DESCRIPTION:@"description",
     DEAL_PRICE:@"$15",
     DEAL_DISCOUNT:@"10%",
                              STORE_NAME:@"SomeName",
                              STORE_ADDRESS:@"1400 page mill rd",
                              STORE_CITY:@"palo alto",
                              STORE_STATE:@"ca",
                              STORE_PHONE:@"987654321",
                              @"tags":@"electronics",
                              @"latitude":@"0.0",
                              @"longitude":@"0.0",
                              @"country":@"us"} mutableCopy];
      */
#if (TARGET_IPHONE_SIMULATOR)
    _params[@"longitude"] = [NSString stringWithFormat:@"%f", -121.924000];
    _params[@"latitude"] = [NSString stringWithFormat:@"%f", 37.370300];
    [self submitHelper:_params];
#else

    CLGeocoder* coder = [[CLGeocoder alloc]init];
    NSString* s = [NSString stringWithFormat:@"%@ %@ %@ %@", _params[STORE_ADDRESS], _params[STORE_CITY],_params[STORE_STATE], _params[@"country"] ];
    [coder geocodeAddressString:s completionHandler:^(NSArray* placemarks, NSError *error){
        CLPlacemark* p = placemarks.count > 0 ? placemarks[0] : nil;
        _params[@"latitude"] = [NSString stringWithFormat:@"%f", p.location.coordinate.latitude];
        _params[@"longitude"] = [NSString stringWithFormat:@"%f", p.location.coordinate.longitude];
        
        [self submitHelper:_params];
    }];
#endif
    
}

- (void) submitHelper: (NSDictionary*) _params{
    NSLog(@"%@",_params);
    NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
    
    // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
    NSString* FileParamConstant = @"image";
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:
                              [cookieJar cookies]];
    [request setAllHTTPHeaderFields:headers];
    
    NSUUID* uuid = [[UIDevice currentDevice]identifierForVendor];
    
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString* userID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_EMAIL];//[[NSUserDefaults standardUserDefaults]objectForKey:USER_EMAIL];
    long ms = (long)(CFAbsoluteTimeGetCurrent () * 1000);
    NSString *header = [NSString stringWithFormat:@"ios;%@;%@;%@;%f;%f;%ld",[uuid UUIDString], version, userID,[Container theContainer].location.coordinate.latitude, [Container theContainer].location.coordinate.longitude, (long)[[NSDate date]timeIntervalSince1970]];
    [request addValue:header forHTTPHeaderField:@"Reqid"];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    //[request setHTTPShouldHandleCookies:NO];
    [request setHTTPShouldHandleCookies:YES];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    //NSString* cookie = [[NSUserDefaults standardUserDefaults] valueForKey:@"cookie"];
    //[request setValue:cookie forHTTPHeaderField:@"Cookie"];
    
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in _params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    // add image data
    NSData *imageData = UIImagePNGRepresentation(self.imageView.image);
    NSLog(@"%lu",(unsigned long)[imageData length]);
    NSLog(@"%@", self.imageView.image);
    
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.png\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    NSURL *requestURL = [[NSURL alloc]initWithString:@"http://onsalelocal.com/osl2/ws/v2/offer"];
    [request setURL:requestURL];
    NSData* d = [request HTTPBody];
    NSString* t = [[NSString alloc]initWithData:d encoding:NSUTF8StringEncoding];
    NSLog(@"%@", request);
    NSLog(@"%@", request.allHTTPHeaderFields);
    [[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSLog(@"%@", obj);
    }];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    self.activityIndicator.hidden = NO;
}

#pragma mark - UIImagePickerControllerDelegate


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{}];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //self.imageView.image = image;
    int x = (image.size.width-2208)/2;
    int y = (image.size.height-2208)/2;
    if(image.imageOrientation == UIImageOrientationLeft || image.imageOrientation == UIImageOrientationRight){
        int temp = x;
        x = y;
        y = temp;
    }
    CGRect rect = CGRectMake( x, y, 2208, 2208);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    self.imageView.image = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    self.pictureDirectionsLabel.hidden = YES;
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Connection Failed with Error: %@", error.localizedDescription);
    self.activityIndicator.hidden = YES;
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"%@",((NSHTTPURLResponse*)response).allHeaderFields);
    self.responseData = [[NSMutableData alloc]init];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.responseData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
    self.activityIndicator.hidden = YES;
    NSString* txt = [[NSString alloc]initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", txt);
    /*
    [[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSLog(@"%@", obj);
    }];
     */
    //NSLog(@"%@",)
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    StoreLookupViewController* vc = (StoreLookupViewController*) segue.destinationViewController;
    vc.passBackDelegate = self;
}

- (void) passBack:(id)object{
    [self.navigationController popViewControllerAnimated:YES];
    self.selectedStore = object;
    
}


@end
