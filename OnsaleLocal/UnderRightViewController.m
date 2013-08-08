//
//  UnderRightViewController.m
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import "UnderRightViewController.h"
#import "PickerViewController.h"
#import "MultiSelectionPickerViewController.h"
#import "EGOCache.h"
#import "NSString+MD5.h"
#import "OnsaleLocalConstants.h"
#import "InitialSlidingViewController.h"
#import "NavigationTopViewController.h"
#import "SearchResultsCell.h"
#import "Deal.h"
#import "UIImageView+WebCache.h"
#import "FirstTopViewController.h"
#import "GTMNSString+URLArguments.h"
#import "SelectFromListViewController.h"
#import "Container.h"
#import "TopViewController.h"
#import "MarqueeLabel.h"

#define WEEKLY_ADS 0 
#define LOCAL_OFFERS 1
#define BOTH_ADS_AND_OFFERS 2

@interface UnderRightViewController()<PassBack, NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (nonatomic, assign) CGFloat peekLeftAmount;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIButton *radiusButton;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UIButton *storesButton;
@property (weak, nonatomic) IBOutlet UIButton *sortingButton;
@property (strong, nonatomic) UIButton* currentButton;
@property (strong, nonatomic) NSArray* radiusArray;
@property (strong, nonatomic) NSArray* sortingArray;
@property (strong, nonatomic) NSArray* categoryArray;
@property (strong, nonatomic) NSArray* storesArray;
@property (strong, nonatomic) NSURLConnection* connection;
@property (strong, nonatomic) NSURLConnection* connection2;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) NSMutableData *storeResponseData;
@property (strong, nonatomic) NSMutableData *categoryResponseData;
@property (strong, nonatomic) NSString* storeQuery;
@property (strong, nonatomic) NSString* categoryQuery;
@property (strong, nonatomic) NSString *radiusAddOn, *storeAddOn, *categoryAddOn, *sortAddOn;

//@property (strong, nonatomic) NSArray* resultsFromQuery;
//@property (strong, nonatomic) NSURLConnection* queryConnection;
//@property (strong, nonatomic) NSMutableData* queryData;
//@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) NSString* searchQuery;
@property (assign, nonatomic) BOOL searchSelected;
//@property (strong, nonatomic) UIBarButtonItem* menuButton;
@property (assign, nonatomic) int radius;
//@property (weak, nonatomic) IBOutlet AutoScrollLabel *autoScrollLabel;
//@property (strong, nonatomic) MarqueeLabel* marqueeLabel;


- (IBAction)cancelButtonPressed:(id)sender;

@end

@implementation UnderRightViewController
@synthesize peekLeftAmount;

@synthesize radiusButton = _radiusButton;
@synthesize categoryButton = _categoryButton;
@synthesize storesButton = _storesButton;
@synthesize sortingButton = _sortingButton;
@synthesize radiusArray = _radiusArray;
@synthesize sortingArray = _sortingArray;
@synthesize categoryArray = _categoryArray;
@synthesize storesArray = _storesArray;
@synthesize connection = _connection;
@synthesize connection2 = _connection2;
@synthesize spinner = _spinner;
@synthesize location = _location;
@synthesize storeQuery = _storeQuery;
@synthesize categoryResponseData = _categoryResponseData;
@synthesize storeResponseData = _storeResponseData;
@synthesize categoryQuery = _categoryQuery;
@synthesize radiusAddOn = _radiusAddOn;
@synthesize storeAddOn = _storeAddOn;
@synthesize categoryAddOn = _categoryAddOn;
@synthesize sortAddOn = _sortAddOn;
//@synthesize resultsFromQuery = _resultsFromQuery;
//@synthesize queryConnection = _queryConnection;
//@synthesize queryData = _queryData;
//@synthesize tableView = _tableView;
@synthesize searchQuery = _searchQuery;
@synthesize searchSelected = _searchSelected;
//@synthesize menuButton = _menuButton;
@synthesize radius = _radius;
//@synthesize autoScrollLabel = _autoScrollLabel;
//@synthesize marqueeLabel = _marqueeLabel;

-(IBAction)revealUnderRight:(id)sender{
    
}
- (IBAction)searchPressed:(id)sender {
    [self searchBarSearchButtonClicked:self.searchBar];
}



- (void) passBack:(id)object{
    Container* container = [Container theContainer];
    NSLog(@"%@" ,[object class]);
    if ([object isKindOfClass:[NSArray class]]) {
        NSArray* tempArr = (NSArray*) object;
        if(tempArr.count > 1){
            NSLog(@"%@",self.currentButton.titleLabel.text);
            [self.currentButton setTitle:@"Multiple Selections" forState:UIControlStateNormal];
        }
        else if (tempArr.count == 1){
            [self.currentButton setTitle:(NSString*)tempArr[0] forState:UIControlStateNormal];
        }
        else{
            [self.currentButton setTitle:@"No Selections" forState:UIControlStateNormal];
        }
        if(self.currentButton == self.storesButton){
            self.storeAddOn = @"";
            if(tempArr.count == 0) self.storeAddOn = nil;
            else{
                for(NSString* string in tempArr){
                    self.storeAddOn = [self.storeAddOn stringByAppendingString:[NSString  stringWithFormat:@";%@",string]];
                }
                self.storeAddOn = [self.storeAddOn substringFromIndex:1];
            }
        }
        else if( self.currentButton == self.categoryButton){
            NSString* categoryAddOn = @"";
            if(tempArr.count == 0)categoryAddOn = nil;
            else{
                for(NSString* string in tempArr){
                    categoryAddOn = [categoryAddOn stringByAppendingString:[NSString  stringWithFormat:@";%@",string]];
                }
                categoryAddOn = [categoryAddOn substringFromIndex:1];
                
            }
            self.categoryAddOn = categoryAddOn;
        }
    }
    else if ([object isKindOfClass:[NSString class]]){
        
        if(self.currentButton == self.radiusButton){
            
            self.radiusAddOn = (NSString*) object;
            container.radius = [self.radiusAddOn intValue];
            [self.currentButton setTitle:[NSString stringWithFormat:@"%@ Mile Radius",object] forState:UIControlStateNormal] ;
        }
        else if (self.currentButton == self.sortingButton){
            self.sortAddOn = (NSString*)object;
            
            [self.currentButton setTitle:(NSString*)object forState:UIControlStateNormal];
        }
        else if (self.currentButton == self.categoryButton){
            self.categoryAddOn = (NSString*)object;
            [self.currentButton setTitle:(NSString*)object forState:UIControlStateNormal];
        }else if (self.currentButton == self.storesButton){
            self.storeAddOn = (NSString*)object;
            [self.currentButton setTitle:(NSString*)object forState:UIControlStateNormal];
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void) setStoresArray:(NSArray *)storesArray{
    if(storesArray != _storesArray){
        _storesArray = storesArray;
        if(self.categoryArray){
            [self.spinner stopAnimating];
        }
    }
}

- (void) setCategoryArray:(NSArray *)categoryArray{
    if (_categoryArray != categoryArray) {
        _categoryArray = categoryArray;
        if(self.storesArray){
            [self.spinner stopAnimating];
        }
    }
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.slidingViewController.topViewController.view addGestureRecognizer:self.slidingViewController.panGesture];
    
}



- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    Container* container = [Container theContainer];
    //NSLog(@"%f,%f,%f,%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
    self.searchSelected = NO;
        //[self.spinner startAnimating];
    
    
    NSLog(@"%@", container);
    self.radiusButton.titleLabel.text = [NSString stringWithFormat:@"%d Mile Radius", container.radius];
    [self.radiusButton setTitle:[NSString stringWithFormat:@"%d Mile Radius", container.radius] forState:UIControlStateNormal];
    [self performSelectorInBackground:@selector(setupDataOnSeparateThreadIfNeeded) withObject:nil];
    
    self.spinner.center = self.view.center;
    CGRect frame = self.view.frame;
    frame.origin.x = 0.0f;
    self.spinner.frame = frame;
    
}
- (void) setupDataOnSeparateThreadIfNeeded{
    Container* container = [Container theContainer];
    [self.spinner startAnimating];
    if(self.storesArray && self.categoryArray){
        [self.spinner stopAnimating];
    }
    float lat = container.location.coordinate.latitude;
    float lon = container.location.coordinate.longitude;
    lat = container.location.coordinate.latitude;
    lon = container.location.coordinate.longitude;
    self.storeQuery = [NSString stringWithFormat:@"http://onsalelocal.com/osl/ws/offer/nearby-stores?lat=%f&lng=%f&radius=%d&format=json", lat, lon, container.radius];
    NSString* encodedString = [self.storeQuery md5];
    NSURL* url = [NSURL URLWithString:self.storeQuery];
    
    NSData* jsonData = [[EGOCache globalCache]dataForKey:encodedString];
    if(jsonData){
        self.storesArray = [self dataToNameArray:jsonData];
    }else{
        
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:60.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        });
    }
    
    self.categoryQuery = [NSString stringWithFormat:@"http://onsalelocal.com/osl/ws/category/nearby?lat=%f&lng=%f&radius=%d&format=json", lat, lon,container.radius];
    
    encodedString = [self.categoryQuery md5];
    
    NSData* jsonData2 = nil;//[[EGOCache globalCache]dataForKey:encodedString];
    if(jsonData2){
        self.categoryArray = [self dataToNameArray:jsonData2];
    }else{
        
        NSURL* url2 = [NSURL URLWithString:self.categoryQuery];
        NSMutableURLRequest* request2 = [[NSMutableURLRequest alloc]initWithURL:url2 cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:60.0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.connection2 = [[NSURLConnection alloc] initWithRequest:request2 delegate:self];
        });
    }

}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
   
}
 

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.peekLeftAmount = 40.0f;
    self.slidingViewController.shouldAddPanGestureRecognizerToTopViewSnapshot = YES;
    [self.slidingViewController setAnchorLeftPeekAmount:self.peekLeftAmount];
    self.slidingViewController.underRightWidthLayout = ECVariableRevealWidth;
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.searchBar.selectedScopeButtonIndex = BOTH_ADS_AND_OFFERS;
    
    
    
    self.radiusArray = [NSArray arrayWithObjects:@"1",@"2",@"5",@"10",@"20",@"50", nil];
    self.sortingArray = [NSArray arrayWithObjects:@"Default", @"Distance", @"Time", @"Relevancy", nil];
    
    
    self.spinner = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.spinner.layer setBackgroundColor:[[UIColor colorWithWhite:0.0 alpha:.3] CGColor]];
    //CGRectMake(self.view.center.x-70, self.view.center.y-100, 140, 100);
    self.spinner.hidesWhenStopped = YES;
    
    //self.tableView.hidden = YES;
    [self.view addSubview:self.spinner];
    
    [self.bottomBar setBackgroundImage:[UIImage imageNamed:@"navBarBackground.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [self.searchBar setBackgroundImage:[UIImage imageNamed:@"navBarBackground.png"]];
    [self.searchBar setScopeBarBackgroundImage:[UIImage imageNamed:@"navBarBackground.png"]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(containerFinishedUpdating:) name:CONTAINER_UPDATED_NOTIFICATION object:nil];
    
        
}
 

-(void)containerFinishedUpdating:(NSNotification*) notification{
    Container* container = [Container theContainer];
    
    [self.radiusButton setTitle:[NSString stringWithFormat:@"%d Mile Radius", container.radius] forState:UIControlStateNormal];
}



- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    /*
    [self.slidingViewController anchorTopViewOffScreenTo:ECLeft animations:^{
        CGRect frame = self.view.frame;
        frame.origin.x = 0.0f;
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            frame.size.width = [UIScreen mainScreen].bounds.size.height;
        } else if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
            frame.size.width = [UIScreen mainScreen].bounds.size.width;
        }
        self.view.frame = frame;
    } onComplete:nil];
     */
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    /*
    if(self.searchSelected){
        self.searchSelected = NO;
    }else{
        [self.slidingViewController anchorTopViewTo:ECLeft animations:^{
            CGRect frame = self.view.frame;
            frame.origin.x = self.peekLeftAmount;
            if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
                frame.size.width = [UIScreen mainScreen].bounds.size.height - self.peekLeftAmount;
            } else if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
                frame.size.width = [UIScreen mainScreen].bounds.size.width - self.peekLeftAmount;
            }
            self.view.frame = frame;
        } onComplete:^{
        }];
     
    }
     */
    [searchBar resignFirstResponder];

}



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([sender isKindOfClass:[UIButton class]]){
        self.currentButton = (UIButton*)sender;
        if([segue.destinationViewController isKindOfClass:[PickerViewController class]]){
            PickerViewController* pvc = (PickerViewController*)segue.destinationViewController;
            pvc.delegate = self;
            if([segue.identifier isEqualToString:@"radius"]){
                pvc.items = self.radiusArray;
                NSLog(@"%@",pvc.items);
            }else if([segue.identifier isEqualToString:@"sorting"]){
                pvc.items = self.sortingArray;
            }
        }
        else if( [segue.destinationViewController isKindOfClass:[SelectFromListViewController   class]]){
            SelectFromListViewController* mspvc = (SelectFromListViewController *) segue.destinationViewController;
            mspvc.delegate = self;
            if([segue.identifier isEqualToString:@"category"]){
                mspvc.items = self.categoryArray;
            }
            else if ([segue.identifier isEqualToString:@"stores"]){
                mspvc.items = self.storesArray;
            }
        }
    }
}
 

#pragma mark - NSURLConnection delegates

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if(connection == self.connection){
        self.storeResponseData = [[NSMutableData alloc] init];
        
    }
    if(connection == self.connection2){
        self.categoryResponseData = [[NSMutableData alloc] init];
    }
   
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if(connection == self.connection){
        [self.storeResponseData appendData:data];
    }
    else if (connection == self.connection2){
        [self.categoryResponseData appendData:data];
    }

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if(connection == self.connection){
        NSLog(@"Failed to fetch store data");
        //[textView setString:@"Unable to fetch data"];
    }
    else if(connection == self.connection2){
        NSLog(@"Failed to fetch category data");
        //[textView setString:@"Unable to fetch data"];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(connection == self.connection){
        NSLog(@"Succeeded! Received %d bytes of data",[self.storeResponseData length]);
        NSString *txt = [[NSString alloc] initWithData:self.storeResponseData encoding: NSASCIIStringEncoding];
        //NSLog(@"%@", txt);
        NSData* jsonData = [txt dataUsingEncoding:NSUTF8StringEncoding];
        NSString* encodedString = [self.storeQuery md5];
        [[EGOCache globalCache]setData:jsonData forKey:encodedString withTimeoutInterval:CACHE_TIMEOUT];
        self.storesArray = [self dataToNameArray:jsonData];
    }
    else if (connection == self.connection2){
        NSLog(@"Succeeded! Received %d bytes of data",[self.categoryResponseData length]);
        NSString *txt = [[NSString alloc] initWithData:self.categoryResponseData encoding: NSASCIIStringEncoding];
        //NSLog(@"%@", txt);
        NSData* jsonData = [txt dataUsingEncoding:NSUTF8StringEncoding];
        NSString* encodedString = [self.categoryQuery md5];
        [[EGOCache globalCache]setData:jsonData forKey:encodedString withTimeoutInterval:CACHE_TIMEOUT];
        self.categoryArray = [self dataToNameArray:jsonData];
    }
  
    
}

-(NSArray*) dataToNameArray : (NSData*) jsonData{
    
    NSError *error = nil;
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    //NSLog(@"%@",results);
    if (error)
        NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    NSArray* items = results[@"items"];
    NSMutableSet* set = [[NSMutableSet alloc]init];
    for(NSDictionary* dict in items){
        [set addObject:dict[@"name"]];
    }
    return [[set allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];

}

#pragma mark - Search Bar Delegate

- (void) searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
    //[self.searchDisplayController.searchResultsTableView reloadData];
    self.searchSelected = YES;
    //[self.spinner startAnimating];

    
    /////////////Must fix - this is not the search query
    self.searchQuery = [NSString stringWithFormat:@"http://onsalelocal.com/osl/ws/offer/search?format=json"];
    

     
    if(self.categoryAddOn){
        NSString* tempString = [self.categoryAddOn gtm_stringByEscapingForURLArgument];

        self.searchQuery = [self.searchQuery stringByAppendingFormat:@"&category=%@",tempString];
    }
    if(self.storeAddOn){
        
    
        NSString* tempString = [self.storeAddOn gtm_stringByEscapingForURLArgument];

        self.searchQuery = [self.searchQuery stringByAppendingFormat:@"&merchant=%@",tempString];
    }
    if(self.sortAddOn){
        // please use order=DistanceAsc. for sorting by updated time, please use order=UpdatedDesc,
        //@"Default", @"Distance", @"Time", @"Relevancy",
        if([self.sortAddOn isEqualToString:@"Distance"]){
            //do nothing
        }else{
            if([self.sortAddOn isEqualToString:@"Distance"]){
                self.sortAddOn = @"DistanceAsc";
            }
            else if([self.sortAddOn isEqualToString:@"Time"]){
                self.sortAddOn = @"UpdatedDesc";
            }
            //otherwise keep sortAddOn as relevance
            self.searchQuery = [self.searchQuery stringByAppendingFormat:@"&order=%@", self.sortAddOn];
        }
    }
    if([searchBar.text length]>0){
        NSString* keywords = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@";"];
        self.searchQuery = [self.searchQuery stringByAppendingFormat:@"&keywords=%@",[keywords gtm_stringByEscapingForURLArgument]];

    }
    if(searchBar.selectedScopeButtonIndex == WEEKLY_ADS){
        self.searchQuery = [self.searchQuery stringByAppendingString:@"&ls=false"];
    }
    else if (searchBar.selectedScopeButtonIndex == LOCAL_OFFERS){
        self.searchQuery = [self.searchQuery stringByAppendingString:@"&ls=true"];
    }
    else{
        //this is for both... do nothing
    }
    NSLog(@"%@",self.searchQuery);
    
    NavigationTopViewController* nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeNavigationTop"];
    [nextVC.childViewControllers[0] setNextQuery:self.searchQuery];
    
    if(!self.slidingViewController.underRightShowing){//got to search from menu
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        frame.origin.x = 0.0f;
        self.slidingViewController.topViewController = nextVC;
        self.slidingViewController.topViewController.view.frame = frame;
      
        [self.slidingViewController resetTopView];
  
    }
     
    else{//got to search by sliding top view left to show "underRightVC"
        [self.slidingViewController anchorTopViewOffScreenTo:ECLeft animations:nil onComplete:^{
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            self.slidingViewController.topViewController = nextVC;
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
        }];
    }

}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self searchBarTextDidEndEditing:searchBar];
    
    searchBar.text = @"";


}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchBarResultsListButtonClicked:searchBar];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self searchBarCancelButtonClicked:self.searchBar];
}

@end
