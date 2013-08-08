//
//  InitialSlidingViewController.m
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/25/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import "InitialSlidingViewController.h"
#import "EGOCache.h"
#import "OnsaleLocalConstants.h"
#import "Container.h"
#import "Reachability.h"
@interface InitialSlidingViewController()<UIAlertViewDelegate>

@property (readonly) BOOL hasLocation;
@property (strong, nonatomic) Reachability* internetReachableFoo;

@end

@implementation InitialSlidingViewController
@synthesize locationManager = _locationManager;
@synthesize location = _location;
@synthesize deviceLocation =  _deviceLocation;
@synthesize internetReachableFoo = _internetReachableFoo;
@synthesize delegate;

- (CLLocation*) location{
    //NSLog(@"%@", _location);
    return _location;
    
}

- (void) setLocation:(CLLocation *)location{
    [self.delegate locationUpdate:location];
    _location = location;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    //[[NSUserDefaults standardUserDefaults] setBool:NO forKey:AFTER_FIRST_TIME_USER];
    //[[EGOCache globalCache] clearCache];
    //self.location = [[CLLocation alloc]initWithLatitude:37.663157 longitude:-121.718281];
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager setDesiredAccuracy: kCLLocationAccuracyKilometer];
    [self.locationManager startMonitoringSignificantLocationChanges];

    
    //[self.slidingViewController setAnchorLeftPeekAmount:40.0f];
    //self.slidingViewController.anchorRightPeekAmount = 100.0f;
    /*
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
    }
     */
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self testInternetConnection];
}
- (void) dealloc{
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void) awakeFromNib{
    }

#pragma mark - Location Manager
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if(error.code == kCLErrorDenied) {
        [self.locationManager stopUpdatingLocation];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Enable Location Use by OnsaleLocal"
                                                        message:[error description]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else if(error.code == kCLErrorLocationUnknown) {
        NSLog(@"I SUCK AS A SIMULATOR!");
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Location"
                                                        message:[error description]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [self.locationManager stopUpdatingLocation];
    
    self.location = [locations lastObject];
    _deviceLocation = [locations lastObject];
    [Container startUpdatingWithLocation:self.location];
    NSLog(@"%@", self.location);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Location Update"
                                                        object:self
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.location, @"location", nil]];
    
    [self.locationManager startMonitoringSignificantLocationChanges];
}
- (void) setupViewController{
    
}
- (void)testInternetConnection
{
    self.internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    __block InitialSlidingViewController* wself = self;
    // Internet is reachable
    self.internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if([[NSUserDefaults standardUserDefaults] boolForKey:AFTER_FIRST_TIME_USER]){
                wself.topViewController = [wself.storyboard instantiateViewControllerWithIdentifier:@"OffersOrDealsNavigation"];
            }else{
                wself.topViewController = [wself.storyboard instantiateViewControllerWithIdentifier:@"regestration"];
            }
        });
    };
    
    // Internet is not reachable
    self.internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.imageView setImage:[UIImage imageNamed:@"Default.png"]];
            NSLog(@"Someone broke the internet :(");
            UIAlertView* popup = [[UIAlertView alloc]initWithTitle:@"No Internet Detected" message:@"Please turn on an internet connection and restart  OnsaleLocal" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [popup show];
        });
    };
    
    [self.internetReachableFoo startNotifier];
}
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}


@end
