//
//  StoresViewController.m
//  OnsaleLocal
//
//  Created by Admin on 1/29/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "StoresViewController.h"
#import "ECSlidingViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "InitialSlidingViewController.h"
#import "DataFetcher.h"
#import "EGOCache.h"
#import "OnsaleLocalConstants.h"
#import "NSString+MD5.h"
#import "NSArray+Create2DSortedStringArray.h"
#import "FirstTopViewController.h"
#import <UIKit/UIKit.h>
#import "GTMNSString+URLArguments.h"
#import "SubCategoryViewController.h"
#import "CatagoriesTableViewController.h"
#import "Container.h"
#import "NavigationTopViewController.h"


#define STORE_NAME @"name"
#define STORE_DEAL_COUNT @"updated"


@interface StoresViewController ()
@property (strong, nonatomic) IBOutlet UITableView* tableView;

@property (strong, nonatomic) CLLocation* location;
@property (strong, nonatomic) NSString* locationString;
//@property (strong, nonatomic) NSData* currentData;
//@property (strong, nonatomic) NSString* currentQuery;
@property (strong, nonatomic) NSArray* stores;
@property (strong, nonatomic) NSArray* stores2DStrings;
@property (strong, nonatomic) NSArray* stores2DDictionaries;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sortButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *radiusButton;
@property (assign, nonatomic) BOOL sortByNumberOfDeals;


@end

@implementation StoresViewController

@synthesize location = _location;
@synthesize locationString = _locationString;
@synthesize tableView = _tableView;
//@synthesize currentData = _currentData;
//@synthesize currentQuery = currentQuery;
@synthesize stores = _stores;
@synthesize stores2DStrings = _stores2DStrings;
@synthesize stores2DDictionaries = _stores2DDictionaries;
@synthesize sortButton = _sortButton;
@synthesize radiusButton = _radiusButton;
@synthesize sortByNumberOfDeals = _sortByNumberOfDeals;


- (IBAction)sortPressed:(id)sender {
    if([self.sortButton.title isEqualToString:@"Sort by Number of Deals"]){
        self.sortButton.title = @"Sort by Store Name";
        self.sortByNumberOfDeals = YES;
        
    }else{
        self.sortButton.title = @"Sort by Number of Deals";
        self.sortByNumberOfDeals = NO;
    }
}

-(void)setJsonDataFromQuery:(NSData *)jsonDataFromQuery{
    [super setJsonDataFromQuery:jsonDataFromQuery];
    self.stores = self.resultsArrayOfDictionaries;
}

-(void)setSortByNumberOfDeals:(BOOL)sortByNumberOfDeals{
    _stores = [self.stores sortedArrayUsingComparator:^NSComparisonResult(NSDictionary* d1, NSDictionary* d2){
        NSNumber* n1 = d1[STORE_DEAL_COUNT];
        NSNumber* n2 = d2[STORE_DEAL_COUNT];
        return [n2 compare:n1];
    }];
    _sortByNumberOfDeals = sortByNumberOfDeals;
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 20, 20) animated:NO];
    [self.tableView reloadData];
}


- (IBAction)radiusPressed:(id)sender {
    
}
/*
- (void)setCurrentData:(NSData *)currentData{
    if(_currentData != currentData && currentData != nil){
        _currentData = currentData;
        NSString* codedString = [self.currentQuery md5];
        [[EGOCache globalCache]setData:currentData forKey:codedString withTimeoutInterval:CACHE_TIMEOUT];
        NSError *error = nil;
        NSDictionary *results = _currentData ? [NSJSONSerialization JSONObjectWithData:_currentData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
        if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
        self.stores = results[@"items"];
        //NSLog(@"%@",self.stores);
    }
}
 */

- (void)setStores:(NSArray *)stores{
    if(stores == nil){
        //int i = [stores count];
        _stores = nil;
        _stores2DDictionaries = nil;
        _stores2DStrings = nil;
        [self.tableView reloadData];
        return;
    }
    if(_stores != stores){
        _stores  = stores;
        NSLog(@"%d",stores.count);
        NSMutableArray* arrayWithStringStoreNames = [[NSMutableArray alloc]initWithCapacity:_stores.count];
        for (NSDictionary* dict in _stores){
            [arrayWithStringStoreNames addObject: dict[STORE_NAME]];
        }
        self.stores2DStrings = [arrayWithStringStoreNames create2DSortedStringArray];
        //NSLog(@"%@", self.stores2DStrings);
        self.stores2DDictionaries = [_stores create2DSortedDictionaryArraybyKey:STORE_NAME];
        NSLog(@"%@", self.stores2DStrings);
        NSLog(@"%@", self.stores2DDictionaries);
        if(self.view.window){
            [self.tableView reloadData];
        }
    }
}


- (CLLocation*) location{
    if(!_location){
        //NSLog(@"self.slidingViewController: %@", self.slidingViewController);
        self.location = ((InitialSlidingViewController*)self.slidingViewController).location;
        //NSLog(@"location in [%@ %@ %@] : %@",[self class],NSStringFromSelector(_cmd), [self.slidingViewController class], ((InitialSlidingViewController*)self.slidingViewController).location);
    }
    return _location;
}

- (void) setLocation:(CLLocation *)location{
    if(_location != location){
        _location = location;
        //self.locationString = [NSString stringWithFormat:@"%f, %f",self.location.coordinate.longitude, self.location.coordinate.latitude];
        [self refresh:self];
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.locationString = @"Not Found Debug";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLocation:)
                                                 name:@"Location Update"
                                               object:nil];
    
    
}
- (void) viewDidLoad{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(containerFinishedUpdating:) name:CONTAINER_UPDATED_NOTIFICATION object:nil];
    self.sortByNumberOfDeals = NO;
    self.currentQuery = [NSString stringWithFormat:@"http://onsalelocal.com/osl/ws/offer/nearby-stores?&format=json&ls=false"];
    
    //NSLog(@"%@",self.slidingViewController);
    [self refresh:self];//for debug only as it is currently set up
    //NSLog(@"%d",self.tableView.scrollEnabled);
}


- (void) updateLocation:(NSNotification*) notification{
    //CLLocationDistance meters = [self.location distanceFromLocation: [notification.userInfo  objectForKey:@"location"]];
    //if(meters && meters > 1000){
    self.location = [notification.userInfo objectForKey:@"location"];
    //}
    [self.bottomBar setBackgroundImage:[UIImage imageNamed:@"navBarBackground.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    if (![self.slidingViewController.underRightViewController isKindOfClass:[UnderRightViewController class]]) {
        self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UnderRight"];
        NSLog(@"%@", self.slidingViewController.underRightViewController);
    }
    
    //[self.view addGestureRecognizer:self.slidingViewController.panGesture];
   

    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)revealUnderRight:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECLeft];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if(self.sortByNumberOfDeals) return 1;
    return self.stores2DDictionaries.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(self.sortByNumberOfDeals) return self.stores.count;
    return [self.stores2DDictionaries[section] count];
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if(self.stores.count < 25){
        return nil;
    }
    BOOL b = self.sortByNumberOfDeals;
    //NSLog(@"%d", b);
    if(b) return nil;
    NSMutableArray* sectionIntexTitles = [[NSMutableArray alloc]initWithCapacity:self.stores2DDictionaries.count];
    for(NSArray* arr in self.stores2DStrings){
        if(arr.count>0){
            [sectionIntexTitles addObject:[((NSString*)arr[0]) substringToIndex:1]];
        }
    }
    //NSLog(@"%@", self.stores2DStrings);
    if(sectionIntexTitles.count > 0 && [sectionIntexTitles[0] intValue]){
        sectionIntexTitles[0] = @"#";
    }
    
    return sectionIntexTitles;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(self.stores.count < 25){
        return nil;
    }
    
    BOOL b = self.sortByNumberOfDeals;
    if(b) return nil;
    NSArray* arr = self.stores2DStrings[section];
    if(arr.count == 0) return nil; // parsing error
    if([[arr[0] substringToIndex:1] intValue]){
        return @"#";
    }
    return [((NSString*)arr[0]) substringToIndex:1];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.spinner stopAnimating];
    static NSString *CellIdentifier = @"StoreCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(self.sortByNumberOfDeals){
        cell.textLabel.text = self.stores[indexPath.row][STORE_NAME];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.stores[indexPath.row][STORE_DEAL_COUNT]];
    }
    else{
        cell.textLabel.text = self.stores2DDictionaries[indexPath.section][indexPath.row][STORE_NAME];
        cell.detailTextLabel.text =  [NSString stringWithFormat:@"(%@)", self.stores2DDictionaries[indexPath.section][indexPath.row][STORE_DEAL_COUNT] ] ;
        //cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@)",[self.stores[indexPath.row] objectForKey:CATEGORY_OFFER_COUNT]];
    }
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"%@", self.nextQuery);
    //NSLog(@"%@", self.currentQuery);
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString* storeName;
    int dealCount;
    if(self.sortByNumberOfDeals){
        dealCount = [self.stores[indexPath.row][STORE_DEAL_COUNT] intValue];
        storeName = self.stores[indexPath.row][STORE_NAME];
    }
    else{
        dealCount = [self.stores2DDictionaries[indexPath.section][indexPath.row][@"updated"] intValue];
        storeName = self.stores2DDictionaries[indexPath.section][indexPath.row][STORE_NAME];
    }
    NSLog(@"%@", storeName);
    NSLog(@"%d", dealCount);
    if(dealCount < 10){
        FirstTopViewController *fvc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeTop"];
        fvc.nextQuery = [NSString stringWithFormat:@"http://onsalelocal.com/osl/ws/offer/search?format=json&merchant=%@&ls=false", [cell.textLabel.text gtm_stringByEscapingForURLArgument]];
        fvc.useBackButton = YES;
        //fvc.navigationController.navigationItem.hidesBackButton = NO;
        //fvc.navigationItem.hidesBackButton = NO;
        [self.navigationController pushViewController:fvc animated:YES];
    }
    else{
        CatagoriesTableViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"CatagoriesTop"];
        cvc.ls = LS_WEEKLY_DEALS_STORES;
        cvc.currentStore = cell.textLabel.text;
        cvc.nextQuery = [NSString stringWithFormat:@"http://onsalelocal.com/osl/ws/category/nearby?format=json&merchant=%@&ls=false",[cell.textLabel.text gtm_stringByEscapingForURLArgument]];
        //cvc.navigationController.navigationItem.hidesBackButton = NO;
        //cvc.navigationItem.hidesBackButton = NO;
        //cvc.menuButton = cvc.navigationItem.backBarButtonItem;
        cvc.useBackButton = YES;
        [self.navigationController pushViewController:cvc animated:YES];
    }
}


@end
