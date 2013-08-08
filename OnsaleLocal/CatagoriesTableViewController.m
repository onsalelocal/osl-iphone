//
//  CatagoriesTableViewController.m
//  OnsaleLocal
//
//  Created by Admin on 1/29/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "CatagoriesTableViewController.h"
#import "ECSlidingViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "InitialSlidingViewController.h"
#import "DataFetcher.h"
#import "EGOCache.h"
#import "OnsaleLocalConstants.h"
#import "NSString+MD5.h"
#import "FirstTopViewController.h"
#import "GTMNSString+URLArguments.h"
#import "SubCategoryViewController.h"
#import "Container.h"



@interface CatagoriesTableViewController ()<CLLocationManagerDelegate>

//@property (strong, nonatomic) NSArray* categories;
//@property (strong, nonatomic) CLLocation* location;
@property (strong, nonatomic) NSString* locationString;
//@property (strong, nonatomic) NSData* currentData;
//@property (strong, nonatomic) NSString* currentQuery;
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) UIActivityIndicatorView *spinner1;
@property (assign, nonatomic) BOOL isSortByCount;

- (IBAction)sortButtonPressed:(id)sender;
@end

@implementation CatagoriesTableViewController

//@synthesize categories = _categories;
//@synthesize location = _location;
@synthesize locationString = _locationString;
//@synthesize tableView = _tableView;
//@synthesize currentData = _currentData;
//@synthesize currentQuery = currentQuery;
@synthesize locationManager = _locationManager;
@synthesize spinner1 = _spinner1;
@synthesize menuButton = _menuButton;
@synthesize useBackButton = _useBackButton;
@synthesize isSortByCount = _isSortByCount;

- (IBAction)revealMenu:(id)sender{
    //[super revealMenu:sender];
}
- (IBAction)revealUnderRight:(id)sender{
    //[super revealUnderRight:sender];
}


- (void) viewDidLoad{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(containerFinishedUpdating:) name:CONTAINER_UPDATED_NOTIFICATION object:nil];
    self.currentQuery = [NSString stringWithFormat:@"http://onsalelocal.com/osl/ws/category/nearby?format=json&ls=true"];
    [self.bottomBar setBackgroundImage:[UIImage imageNamed:@"navBarBackground.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    if(!self.ls){
        self.ls = LS_LOCAL_OFFERS_CATEGORIES;
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view addSubview:self.spinner1];
    if(!self.useBackButton){
        self.menuButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu21.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(revealMenu:)];
        self.navigationItem.leftBarButtonItem = self.menuButton;
    }

    [self.spinner1 startAnimating];
    
    //NSData* data = self.jsonDataFromQuery;
}

- (void) awakeFromNib{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager setDesiredAccuracy: kCLLocationAccuracyKilometer];
    [self.locationManager startMonitoringSignificantLocationChanges];
    
    self.spinner1 = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner1.center = self.view.center;
    [self.spinner1.layer setBackgroundColor:[[UIColor colorWithWhite:0.0 alpha:.3] CGColor]];
    self.spinner1.frame = CGRectMake(self.view.center.x-70, self.view.center.y-100, 140, 100);
    self.spinner1.hidesWhenStopped = YES;
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.locationManager stopMonitoringSignificantLocationChanges];
    [self.locationManager stopUpdatingLocation];
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
        // retry
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
    
    //NSLog(@"%@", self.location);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Location Update"
                                                        object:self
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.location, @"location", nil]];
    
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void) dealloc{
    [self.locationManager stopMonitoringSignificantLocationChanges];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"%@", self.resultsArrayOfDictionaries);
    return self.resultsArrayOfDictionaries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.spinner1 stopAnimating];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.textLabel.frame = CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.y, 100,cell.textLabel.frame.size.height );
    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    //NSLog(@"%@",[self.categories[indexPath.row]objectForKey:CATEGORY_NAME]);
    cell.textLabel.text = [self.resultsArrayOfDictionaries[indexPath.row]objectForKey:CATEGORY_NAME];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@)",[self.resultsArrayOfDictionaries[indexPath.row] objectForKey:CATEGORY_OFFER_COUNT]];
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@", self.nextQuery);
    NSLog(@"%@", self.currentQuery);
    if([self.resultsArrayOfDictionaries[indexPath.row][@"offerCount"] intValue] < 4 ||
       [self.resultsArrayOfDictionaries[indexPath.row][@"items"] count] < 10 ){
        NSString* ls = @"";
        if(self.ls == LS_LOCAL_OFFERS_CATEGORIES){
            ls = @"true";
        }
        else if(self.ls == LS_WEEKLY_DEALS_STORES){
            ls = @"false";
        }
        FirstTopViewController *ftvc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeTop"];
        NSString* query = [NSString stringWithFormat:@"http://onsalelocal.com/osl/ws/offer/search?format=json&category=%@&ls=%@", [cell.textLabel.text gtm_stringByEscapingForURLArgument], ls];
        if(self.currentStore){
            query = [query stringByAppendingFormat:@"merchant=%@",self.currentStore];
        }
        //query = [query stringByReplacingOccurrencesOfString:@"+&+" withString:@"+"];
        
        ftvc.nextQuery =  query;
        //ftvc.navigationItem.leftItemsSupplementBackButton = YES;
        ftvc.useBackButton = YES;
        [self.navigationController pushViewController:ftvc animated:YES];
    }
    else{
        SubCategoryViewController *scvc = [self.storyboard instantiateViewControllerWithIdentifier:@"subCategory"];
        scvc.currentStore = self.currentStore;
        scvc.items = self.resultsArrayOfDictionaries[indexPath.row][@"items"];
        scvc.currentCategory = self.resultsArrayOfDictionaries[indexPath.row][CATEGORY_NAME];
        scvc.ls = self.ls;
        //scvc.useBackButton = YES;
        [self.navigationController pushViewController:scvc animated:YES];
    }
}



- (IBAction)sortButtonPressed:(id)sender {
    if(self.isSortByCount){
        self.isSortByCount = NO;
        NSString* text = @"Sort by Name";
        ((UIBarButtonItem*)sender).title = text;
        self.resultsArrayOfDictionaries = [self.resultsArrayOfDictionaries sortedArrayUsingComparator:^(NSDictionary* dict1, NSDictionary* dict2) {
            return [dict2[CATEGORY_OFFER_COUNT] compare:dict1[CATEGORY_OFFER_COUNT]];
        }];
    }
    else{
        self.isSortByCount = YES;
        NSString* text = @"Sort by Count";
        ((UIBarButtonItem*)sender).title = text;
        self.resultsArrayOfDictionaries = [self.resultsArrayOfDictionaries sortedArrayUsingComparator:^(NSDictionary* dict1, NSDictionary* dict2) {
            return [dict1[CATEGORY_NAME] caseInsensitiveCompare:dict2[CATEGORY_NAME]];
        }];
    }
}
@end
