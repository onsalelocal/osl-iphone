
//
//  ResultsTableViewController.m
//  OnsaleLocal
//
//  Created by Admin on 1/29/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "ResultsTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "UnderRightViewController.h"
#import "NSString+MD5.h"
#import "EGOCache.h"
#import "OnsaleLocalConstants.h"
#import "InitialSlidingViewController.h"
#import "DataFetcher.h"
#import "Container.h"



@interface ResultsTableViewController ()<NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (strong, nonatomic) NSURLConnection* connection;
@property (strong, nonatomic) NSMutableData* responseData;
@property (assign, nonatomic) BOOL expectingList;


@end

@implementation ResultsTableViewController

@synthesize tableView = _tableView;
@synthesize location = _location;
@synthesize currentQuery = _currentQuery;
@synthesize jsonDataFromQuery = _jsonDataFromQuery;
@synthesize resultsArrayOfDictionaries = _resultsArrayOfDictionaries;
@synthesize radius = _radius;
@synthesize connection = _connection;
@synthesize responseData = _responseData;
@synthesize nextQuery = _nextQuery;
@synthesize spinner = _spinner;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        
    }
    return self;
}
/*
- (NSString*) currentQuery{
    return _nextQuery ? _nextQuery : _currentQuery;
}
 */

- (void) setNextQuery:(NSString *)nextQuery{
    if(_nextQuery != nextQuery){
        _nextQuery = nextQuery;
    }
}

- (void) setRadius:(int)radius{
    if(_radius != radius){
        _radius = radius;
        [self refresh:self];
    }
}

-(void) eliminateCahcedURL{
    //NSLog(@"%@ - %@",self.currentQuery, [self.currentQuery md5]);
    [[EGOCache globalCache] removeCacheForKey:[self.currentQuery md5]];
    self.resultsArrayOfDictionaries = nil;
    //[self.spinner startAnimating];
    [self refresh:self];
}

- (void)setJsonDataFromQuery:(NSData *)jsonDataFromQuery{
    if(_jsonDataFromQuery != jsonDataFromQuery && jsonDataFromQuery != nil){
        _jsonDataFromQuery = jsonDataFromQuery;
        NSString* encodedString = [self.currentQuery md5];
        [[EGOCache globalCache]setData:jsonDataFromQuery forKey:encodedString withTimeoutInterval:CACHE_TIMEOUT];
        NSError *error = nil;
        NSDictionary *results = _jsonDataFromQuery ? [NSJSONSerialization JSONObjectWithData:_jsonDataFromQuery options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments error:&error] : nil;
        
        //NSLog(@"%@",results);
        if (error){
            NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
            NSLog(@"%@",self.currentQuery);
            NSLog(@"%@",self.nextQuery);
            //NSData *jsonData = ...
            const unsigned char *ptr = [jsonDataFromQuery bytes];
            
            for(int i=0; i<[jsonDataFromQuery length]; ++i) {
                unsigned char c = *ptr++;
                NSLog(@"char=%c hex=%x", c, c);
            }
        }
        
        NSArray* items = results[@"items"];
        //NSLog(@"%@", items);
        self.resultsArrayOfDictionaries = items;
        [self.spinner stopAnimating];
        //NSLog(@"%@",self.resultsArrayOfDictionaries);
    }else if(jsonDataFromQuery == nil){
        _jsonDataFromQuery = jsonDataFromQuery;
    
    }
}
- (void)setResultsArrayOfDictionaries:(NSArray *)resultsArrayOfDictionaries{
    if(_resultsArrayOfDictionaries != resultsArrayOfDictionaries){
        _resultsArrayOfDictionaries = resultsArrayOfDictionaries;
        /*
        if(_resultsArrayOfDictionaries && [_resultsArrayOfDictionaries count] == 0){
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"No Matches" message:@"Please refine search" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
         */
        //if(self.view.window){
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_COLLECTION_VIEW object:self];
        //}
    }
}

- (void)setCurrentQuery:(NSString *)currentQuery{
    if(_currentQuery != currentQuery){
        _currentQuery = currentQuery;
        //[self refresh:self];
    }
}


- (CLLocation*) location{
    if(!_location){
        self.location = ((InitialSlidingViewController*)self.slidingViewController).location;
        //NSLog(@"location in [%@ %@] : %@",[self class],NSStringFromSelector(_cmd), _location);
    }
    return _location;
}

- (void) setLocation:(CLLocation *)location{
    if(_location != location){
        _location = location;
        [self refresh:self];
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.spinner = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.center = self.view.center;
    [self.spinner.layer setBackgroundColor:[[UIColor colorWithWhite:0.0 alpha:.3] CGColor]];
    self.spinner.frame = CGRectMake(self.view.center.x-70, self.view.center.y-100, 140, 100);
    self.spinner.hidesWhenStopped = YES;
    //[self.view addSubview:self.view];


    
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void) updateLocation:(NSNotification*) notification{
    //CLLocationDistance meters = [self.location distanceFromLocation: [notification.userInfo  objectForKey:@"location"]];
    //if(meters && meters > 1000){
        self.location = [notification.userInfo objectForKey:@"location"];
    NSLog(@"%@",self.location);
    [self refresh:self];
    //}
}


/////////Need to finish
- (IBAction)refresh:(id)sender
{
    // might want to use introspection to be sure sender is UIBarButtonItem
    // (if not, it can skip the spinner)
    // that way this method can be a little more generic
    //NSString* tempQuery = self.currentQuery;
    NSString* fullQuery;
    Container* container = [Container theContainer];
    [self.spinner startAnimating];
    if(container.location){
        //int tempRadius = (container && !container.isUpdating) ? container.radius : 5;
        //if(container && !container.isUpdating){
        
        NSLog(@"%@",self.currentQuery);
        NSString* encodedString = [self.currentQuery md5];
        if([sender isKindOfClass:[MenuViewController class]]){
            [[EGOCache globalCache]removeCacheForKey:encodedString];
        }
        [[EGOCache globalCache]clearCache];
        NSData* tempD = [[EGOCache globalCache]dataForKey:encodedString];
        self.jsonDataFromQuery = tempD;
        NSLog(@"%d", self.jsonDataFromQuery.length);
        
        if(container.location && !self.jsonDataFromQuery && self.currentQuery){
            
            
            NSURL* url = [NSURL URLWithString:self.currentQuery];
            NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
            NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:
                                      [cookieJar cookies]];
            [request setAllHTTPHeaderFields:headers];
            NSUUID* uuid = [[UIDevice currentDevice]identifierForVendor];
            if(!uuid){//below ios 6.0
                uuid = [[NSUUID alloc]initWithUUIDString:[[UIDevice currentDevice]uniqueIdentifier]];
            }
            NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
            NSString* userID = [[NSUserDefaults standardUserDefaults]objectForKey:USER_EMAIL];
            long ms = (long)(CFAbsoluteTimeGetCurrent () * 1000);
            NSString *header = [NSString stringWithFormat:@"ios;%@;%@;%@;%f;%f;%ld",[uuid UUIDString], version, userID,self.location.coordinate.latitude, self.location.coordinate.longitude, ms];
            [request addValue:header forHTTPHeaderField:@"Reqid"];
            NSLog(@"%@", self.currentQuery);
            
            
            
            self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            
        }else{
            //NSLog(@"self.location: %@", self.location);
            //NSLog(@"self.jsonDataFromQuery size: %d", [self.jsonDataFromQuery length]);
            //NSLog(@"self.currentQuery: %@", self.currentQuery);
        }
        //}
    }
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self refresh:self];
    

}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLocation:)
                                                 name:CONTAINER_UPDATED_NOTIFICATION
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - NSURLConnection delegates

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if(connection == self.connection){
        self.responseData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if(connection == self.connection){
        [self.responseData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if(connection == self.connection){
        NSLog(@"Failed to fetch data");
        //[textView setString:@"Unable to fetch data"];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(connection == self.connection){
        [self.spinner stopAnimating];
        NSLog(@"Succeeded! Received %d bytes of data",[self.responseData
                                                       length]);
        NSString *txt = [[NSString alloc] initWithData:self.responseData encoding: NSASCIIStringEncoding];
        NSLog(@"%@",txt);
        
        //NSLog(@"%@", txt);
        self.jsonDataFromQuery = [txt dataUsingEncoding:NSUTF8StringEncoding];
    }
    
}

@end
