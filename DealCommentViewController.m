//
//  DealCommentViewController.m
//  OnsaleLocal
//
//  Created by Jon on 8/20/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "DealCommentViewController.h"
#import "OnsaleLocalConstants.h"


@interface DealCommentViewController ()<UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData* responseData;

@end

@implementation DealCommentViewController

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

- (IBAction)postDealCommentPressed:(id)sender {
    NSString* userId = [[NSUserDefaults standardUserDefaults]stringForKey:USER_ID];
    NSString* offerId = self.dealDict[DEAL_ID];
    NSString* content = self.textView.text;
    if(userId){
        NSString* url = [NSString stringWithFormat:@"http://www.onsalelocal.com/osl2/ws/v2/offer/comment"];
        
        NSDictionary* _params = @{@"userId":userId,
                                  @"offerId":offerId,
                                  @"content":content};
        
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:
                                  [cookieJar cookies]];
        [request setAllHTTPHeaderFields:headers];
        NSUUID* uuid = [[UIDevice currentDevice]identifierForVendor];
        NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        NSString* userID = [[NSUserDefaults standardUserDefaults] objectForKey:USER_EMAIL];
        NSString *header = [NSString stringWithFormat:@"ios;%@;%@;%@;%f;%f;%ld",[uuid UUIDString], version, userID,0.0, 0.0, (long)[[NSDate date]timeIntervalSince1970]];
        NSError* error;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:_params options:kNilOptions error:&error];
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody: jsonData];
        [request setValue:header forHTTPHeaderField:@"Reqid"];
        //[request setValue:@"text/plain"/*@"application/x-www-form-urlencoded"*/ forHTTPHeaderField:@"content-type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPShouldHandleCookies:YES];
        
        NSString *msgLength = [NSString stringWithFormat:@"%d", [jsonData length]];
        [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
        
        self.connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error posting comment" message:@"Please re-sign in and try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }

}
- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSString* text = [[NSString alloc]initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", text);
    NSDictionary* d;
    NSError* error;
    d = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
    if(error){
        NSLog(@"%@", error.localizedDescription);
    }else{
        if(connection == self.connection){
            NSLog(@"%@",d);
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Post Successful" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [self.textView resignFirstResponder];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - NSURLConnection delegates

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSDictionary* d = [((NSHTTPURLResponse*)response) allHeaderFields];
    NSLog(@"%@",d);
    self.responseData = [[NSMutableData alloc] init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Failed to fetch data");
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error Posting Comment" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];

    
}

-(void)textViewDidChange:(UITextView *)textView{
    self.charCountLabel.hidden = NO;
    int countLeft = 140-textView.text.length;
    self.charCountLabel.text = [NSString stringWithFormat:@"%d characters left",countLeft];

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
       return YES;
}

@end
