//
//  SecondDetailCell.m
//  OnsaleLocal
//
//  Created by Jon on 6/12/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "SecondDetailCell.h"
#import "OnsaleLocalConstants.h"
#import "UIImageView+WebCache.h"

@interface SecondDetailCell()

@property (strong, nonatomic) NSURLConnection* connection;
@property (strong, nonatomic) NSMutableData* responseData;

@end

@implementation SecondDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setDealDict:(NSDictionary *)dealDict{
    _dealDict = dealDict;
    [self.imageView setImageWithURL:[NSURL URLWithString:self.dealDict[DEAL_SHARED_BY][@"img"]] completed:nil];
    self.fromWhoLabel.text = [NSString stringWithFormat:@"%@ %@",self.dealDict[DEAL_SHARED_BY][USER_FIRST_NAME],self.dealDict[DEAL_SHARED_BY][USER_LAST_NAME]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)followButtonPressed:(id)sender {
    NSString* userId = self.dealDict[DEAL_SHARED_BY][USER_ID];
    NSLog(@"%@",self.dealDict);
    if(userId){
        NSString* url = [NSString stringWithFormat:@"http://www.onsalelocal.com/osl2/ws/v2/user/follow/%@",userId];
        
        //NSDictionary* _params = @{@"userId":userId,
        //                          @"offerId":offerId,
        //                          @"content":content};
        
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:
                                  [cookieJar cookies]];
        [request setAllHTTPHeaderFields:headers];
        NSUUID* uuid = [[UIDevice currentDevice]identifierForVendor];
        NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        NSString* userID = [[NSUserDefaults standardUserDefaults] objectForKey:USER_EMAIL];
        NSString *header = [NSString stringWithFormat:@"ios;%@;%@;%@;%f;%f;%ld",[uuid UUIDString], version, userID,0.0, 0.0, (long)[[NSDate date]timeIntervalSince1970]];
        //NSError* error;
        //NSData* jsonData = [NSJSONSerialization dataWithJSONObject:_params options:kNilOptions error:&error];
        
        [request setHTTPMethod:@"POST"];
        //[request setHTTPBody: jsonData];
        [request setValue:header forHTTPHeaderField:@"Reqid"];
        //[request setValue:@"text/plain"/*@"application/x-www-form-urlencoded"*/ forHTTPHeaderField:@"content-type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPShouldHandleCookies:YES];
        
        //NSString *msgLength = [NSString stringWithFormat:@"%d", [jsonData length]];
        //[request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
        
        self.connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error Communicating with Server" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
}



- (void)layoutSubviews {
    
    
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(8,37,48,48);
    CGPoint center = self.imageView.center;
    center.y = self.frame.size.height / 2;
    self.imageView.center = center;
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
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Follow Successful" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            
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

@end
