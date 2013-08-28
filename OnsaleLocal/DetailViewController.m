//
//  DetailViewController.m
//  OnsaleLocal
//
//  Created by Admin on 2/4/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailCell.h"
#import "MapViewController.h"
#import "DealAnnotation.h"
#import "OnsaleLocalConstants.h"
#import "UIImageView+WebCache.h"
#import "FirstTopViewController.h"
#import "GTMNSString+URLArguments.h"
#import "WebViewController.h"
#import "Container.h"
#import "MarqueeLabel.h"
#import "TTTAttributedLabel.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "InviteFriendsViewController.h"
#import "FirstDetailCell.h"
#import "SecondDetailCell.h"
#import "TagsTableViewCell.h"
#import "StoreTableViewCell.h"
#import "EGOCache.h"
#import "MKMapView+ZoomLevel.h"
#import "ReviewView.h"
#import "ReviewsCell.h"
#import "SizeObject.h"
#import "DealCommentViewController.h"


#define DEAL_NAME_FONT              [UIFont fontWithName:@"Helvetica-Bold" size:14]
#define DEAL_PRICE_FONT             [UIFont fontWithName:@"Helvetica" size:14]
#define FIRST_CELL_MIN_HEIGHT       100
#define TAG_ARRAY                   @[@"Kids",@"Store",@"qwertyqwertyqwerty",@"Some",@"Thing",@"Blahblahblah"]




@interface DetailViewController ()<MapViewControllerDelegate,TTTAttributedLabelDelegate, MapPressed, UITableViewDataSource, UITableViewDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate, MKMapViewDelegate,cellMethods>



@property (weak, nonatomic) IBOutlet UIToolbar *bottomBar;
@property (strong, nonatomic) NSArray* subCategories;
@property (strong, nonatomic) NSArray* bookmarkArray;

@property (assign, nonatomic) BOOL isBookmarked;
@property (strong, nonatomic) NSString* query;
@property (strong, nonatomic) NSDictionary* dealDict;
@property (strong, nonatomic) NSDictionary* userLikeDealDict;
@property (strong, nonatomic) NSDictionary* commentsDealDict;

@property (strong, nonatomic) NSURLConnection* offerDetailsConnection;
@property (strong, nonatomic) NSMutableData* offerDetailsResponseData;
@property (strong, nonatomic) NSURLConnection* userLikeConnection;
@property (strong, nonatomic) NSMutableData* userLikeData;
@property (strong, nonatomic) NSURLConnection* commentsConnection;
@property (strong, nonatomic) NSMutableData* commentsData;
@property (strong, nonatomic) NSMutableDictionary* masterDealDict;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (strong, nonatomic) NSMutableArray* listOfReviewViews;
@property (strong, nonatomic) NSArray* fakeReviews;

//
//@property (strong, nonatomic) id<cellMethods> cellMethodsDelegate;


- (IBAction)callPhone:(id)sender;
- (IBAction)bookMarkPressed:(id)sender;

@end

@implementation DetailViewController

@synthesize dealDict = _dealDict;
@synthesize subCategories = _subCategories;
@synthesize currentLocation = _currentLocation;
@synthesize bookmarkArray = _bookmarkArray;

@synthesize isBookmarked = _isBookmarked;

- (NSMutableArray*)listOfReviewViews{
    if(!_listOfReviewViews){
        _listOfReviewViews = [[NSMutableArray alloc]init];
    }
    return _listOfReviewViews;
}

- (void) setIsBookmarked:(BOOL)isBookmarked{
    _isBookmarked = isBookmarked;
    [self.tableView reloadData];
    
}

- (void)setCommentsDealDict:(NSDictionary *)commentsDealDict{
    //if(commentsDealDict != _commentsDealDict){
        _commentsDealDict = commentsDealDict;
    [self.listOfReviewViews removeAllObjects];
    for(NSDictionary* d in self.commentsDealDict[@"items"]){//commentsDealDict[@"items"]){
            ReviewView* rv = [[ReviewView alloc]initWithInfoDict:d];
            [self.listOfReviewViews addObject:rv];
        }
    //}
}



- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        
    }
    return  self;
}


- (IBAction)callPhone:(id)sender {
    NSLog(@"%@", self.dealDict[DEAL_PHONE]);
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",self.dealDict[DEAL_PHONE]]];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)bookMarkPressed:(id)sender {
 
    NSMutableArray* bookmarks;
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath
                          stringByAppendingPathComponent:BOOKMARK_FILE_NAME];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        bookmarks = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        NSMutableSet *set = [NSMutableSet setWithArray:bookmarks];
        
        if([self set:set containesDictionaryWithKey:DEAL_ID thatMatchesValue:self.dealDict[DEAL_ID]]){
            set = (NSMutableSet*)[self removeDictionaryWithKey:DEAL_ID value:self.dealDict[DEAL_ID] fromSet:set];
            [self setIsBookmarked:NO];
        }
        else{
            [set addObject:self.dealDict];
            [self setIsBookmarked:YES];
        }
        bookmarks = (NSMutableArray*)[set allObjects];

    }
    else{
        bookmarks = [NSMutableArray arrayWithObject:self.dealDict];
    }
    //if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
    if ([bookmarks writeToFile:filePath atomically:YES]) {
        NSLog(@"Created");
        //  }
    } else {
        NSLog(@"Is not created");
        NSLog(@"Path %@",filePath);
        
    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(containerFinishedUpdating:) name:CONTAINER_UPDATED_NOTIFICATION object:nil];
    [self.bottomBar setBackgroundImage:[UIImage imageNamed:@"navBarBackground.png"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    self.currentLocation = [Container theContainer].location;
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapButtonPressed)];
    self.fakeReviews = @[@{USER_FIRST_NAME:USER_FIRST_NAME,USER_LAST_NAME:USER_LAST_NAME,@"content":@"This is my first review, This is my first review"},
                         @{USER_FIRST_NAME:USER_FIRST_NAME,USER_LAST_NAME:USER_LAST_NAME,@"content":@"This is my second review, This is my second review 123456789 0123456789 012345 6789 01234567890"},
                         @{USER_FIRST_NAME:USER_FIRST_NAME,USER_LAST_NAME:USER_LAST_NAME,@"content":@"This is my third review, This is my third review 1234567 89012345678901234567890 12345678901234567890123456 78901234567890"}];

}

- (void) loadView{
    [super loadView];
    [[EGOCache globalCache] clearCache];
    if([[EGOCache globalCache] hasCacheForKey:self.offerID]){
        self.masterDealDict = (NSMutableDictionary*)[[EGOCache globalCache] objectForKey:self.offerID];
    
    }else{
        self.query = [NSString stringWithFormat:@"http://onsalelocal.com/osl2/ws/v2/offer/details?format=json&offerId=%@", self.offerID];
        NSLog(@"%@", self.query);
        NSURL* url = [NSURL URLWithString:self.query];
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
        NSUUID* uuid = [[UIDevice currentDevice]identifierForVendor];
        if(!uuid){//below ios 6.0
            uuid = [[NSUUID alloc]initWithUUIDString:[[UIDevice currentDevice]uniqueIdentifier]];
        }
        NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        NSString* userID = [[NSUserDefaults standardUserDefaults]objectForKey:USER_EMAIL];
        long ms = (long)(CFAbsoluteTimeGetCurrent () * 1000);
        NSString *header = [NSString stringWithFormat:@"ios;%@;%@;%@;%f;%f;%ld",[uuid UUIDString], version, userID,[Container theContainer].location.coordinate.latitude, [Container theContainer].location.coordinate.longitude, ms];
        [request addValue:header forHTTPHeaderField:@"Reqid"];
        NSLog(@"%@", self.query);
        self.offerDetailsConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        
        self.query = [NSString stringWithFormat:@"http://onsalelocal.com/osl2/ws/v2/offer/like/users?format=json&offerId=%@", self.offerID];
        NSLog(@"%@", self.query);
        url = [NSURL URLWithString:self.query];
        [request setURL:url];
        self.userLikeConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        /*
        self.query = [NSString stringWithFormat:@"http://onsalelocal.com/osl2/ws/v2/offer/comments?format=json&offerId=%@", self.offerID];
        NSLog(@"%@", self.query);
        url = [NSURL URLWithString:self.query];
        [request setURL:url];
        self.commentsConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
         */
    }
}

- (void) awakeFromNib{
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSURL* url = [NSURL URLWithString:self.query];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    NSUUID* uuid = [[UIDevice currentDevice]identifierForVendor];
    if(!uuid){//below ios 6.0
        uuid = [[NSUUID alloc]initWithUUIDString:[[UIDevice currentDevice]uniqueIdentifier]];
    }
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString* userID = [[NSUserDefaults standardUserDefaults]objectForKey:USER_EMAIL];
    long ms = (long)(CFAbsoluteTimeGetCurrent () * 1000);
    NSString *header = [NSString stringWithFormat:@"ios;%@;%@;%@;%f;%f;%ld",[uuid UUIDString], version, userID,[Container theContainer].location.coordinate.latitude, [Container theContainer].location.coordinate.longitude, ms];
    [request addValue:header forHTTPHeaderField:@"Reqid"];
    self.query = [NSString stringWithFormat:@"http://onsalelocal.com/osl2/ws/v2/offer/comments?format=json&offerId=%@", self.offerID];
    //[[EGOCache globalCache]removeCacheForKey:[self.query md5]];
    NSLog(@"%@", self.query);
    url = [NSURL URLWithString:self.query];
    [request setURL:url];
    self.commentsConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    
    //self.spinner.frame = CGRectMake(0, self.view.frame.size.height-72, self.view.frame.size.width, 72);
    /*
    [self.navigationItem.backBarButtonItem setTintColor:[UIColor colorWithRed:176/255.0 green:27/255.0f blue:23/255.0f alpha:1]];
    NSMutableArray* bookmarks;
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath
                          stringByAppendingPathComponent:BOOKMARK_FILE_NAME];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        bookmarks = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        NSMutableSet *set = [NSMutableSet setWithArray:bookmarks];
        
        self.isBookmarked = [self set:set containesDictionaryWithKey:DEAL_ID thatMatchesValue:self.dealDict[DEAL_ID]];
        
    }
     */
/*
    Container* container = [Container theContainer];
    if(container && !container.isUpdating){
        self.autoScrollLabel.text = [NSString stringWithFormat:@"Location: %@, %@ %@, Search Radius: %d miles", container.cityString, container.stateString, container.countryString, container.radius];
    }
 */
}

-(void)containerFinishedUpdating:(NSNotification*) notification{
    Container* container = [Container theContainer];
    NSLog(@"%@",[NSString stringWithFormat:@"Location: %@, %@ %@; Search Radius: %d miles;", container.cityString, container.stateString, container.countryString, container.radius]);
   // self.autoScrollLabel.textColor = [UIColor blackColor];
    //self.autoScrollLabel.text = text;
}
 
- (CGFloat) heightForString: (NSString*) string withFont: (UIFont*) font{
        return [string sizeWithFont:font constrainedToSize:CGSizeMake(302, 999) lineBreakMode:NSLineBreakByWordWrapping].height;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.listOfReviewViews.count)
        return 5;
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        CGFloat height = [self heightForString:self.dealDict[DEAL_TITLE] withFont:DEAL_NAME_FONT];
        height += 10 + [self heightForString:self.dealDict[DEAL_PRICE] withFont:DEAL_PRICE_FONT];
        CGSize size;
        if (self.dealDict[DEAL_IMAGE_HEIGHT]) {
            size = CGSizeMake([self.dealDict[DEAL_IMAGE_WIDTH] floatValue], [self.dealDict[DEAL_IMAGE_HEIGHT] floatValue]);
            
        }
        else{
            size = CGSizeMake(300, 300);
        }
        SizeObject* ob = [[SizeObject alloc]init];
        [ob setImageSize:size withMaxWidth:300];
        return height + ob.imageSize.height + 60 +23;
    }
    else if(indexPath.row == 1){//shared by
        return 110;
    }
    else if(indexPath.row == 2){//tag
        if(self.dealDict[@"tags"]){
            NSLog(@"%f", [self heightForTags]);
            return [self heightForTags];
        }
        return 100;
    }
    else if(indexPath.row == 3){//store
        if(self.dealDict[STORE_URL]){
            return 180;
        }
        else{
            return 180-42;
        }

    }
    else if(indexPath.row == 4){//reviews
        int offset = 37;
        for(ReviewView* view in self.listOfReviewViews){
            
            //view.frame = CGRectMake(20, offset, view.frame.size.width, view.frame.size.height);
            //[cell addSubview:view];
            offset += view.frame.size.height + 8 ;
        }
        return offset;

    }
    
    return 200;
}

- (CGFloat) heightForTags{
    int startX = 8;
    int startY = 29;
    
    NSArray * tags = [self.dealDict[@"tags"] componentsSeparatedByString:@","];
    NSMutableArray* tagLabels = [NSMutableArray arrayWithCapacity:tags.count];
    if(tags.count){
        CGSize size = [tags[0] sizeWithFont:TAG_FONT];
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(startX, startY, size.width+4, LABEL_HEIGHT)];
        label.font = TAG_FONT;
        label.text = tags[0];
        [tagLabels addObject: label];
        
    }
    for(int i=1; i <tags.count; i++){
        startX += LABEL_SPACING + ((UILabel*)tagLabels[i-1]).frame.size.width;
        CGSize size = [tags[i] sizeWithFont:TAG_FONT];
        if(startX + size.width > self.view.bounds.size.width - 8){
            startX = 8;
            startY = startY + LABEL_HEIGHT + LABEL_SPACING;
        }
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(startX, startY, size.width+4, LABEL_HEIGHT)];
        label.font = TAG_FONT;
        label.text = tags[i];
        [tagLabels addObject: label];
        
    }
    
    CGFloat height = ((UILabel*)[tagLabels lastObject]).frame.origin.y + ((UILabel*)[tagLabels lastObject]).frame.size.height+20;

    
    return height;
}
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) cell.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    if(indexPath.row == 3){
        NSDictionary* dealDict = self.masterDealDict ? self.masterDealDict :self.dealDict;
        CLLocationCoordinate2D loc2D = CLLocationCoordinate2DMake([dealDict[DEAL_LAT]doubleValue], [dealDict[DEAL_LONG]doubleValue]);
        [((StoreTableViewCell*)cell).mapView setCenterCoordinate:loc2D zoomLevel:7 animated:NO];
        NSLog(@"%d",[((StoreTableViewCell*)cell).mapView getZoomLevel]);
        [cell setNeedsLayout];
    }
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell;
    if(indexPath.row == 0){
        
        static NSString* s = @"FirstDetailCell";
        cell = (FirstDetailCell*)[self.tableView dequeueReusableCellWithIdentifier:s];
        if(!cell){
            cell = [[FirstDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:s];
        }
        ((FirstDetailCell*)cell).cellMethodsDelegate = self;
        NSDictionary* d = self.masterDealDict ? self.masterDealDict : self.dealDict;
        ((FirstDetailCell*) cell).dealDict = d;


    }else if (indexPath.row == 1){
        static NSString* ss = @"SecondDetailCell";
        //NSLog(@"%@",self.subCategories[0]);
        cell = (SecondDetailCell*)[self.tableView dequeueReusableCellWithIdentifier:ss];
        NSLog(@"%@", cell);
        if(!cell){
            cell = [[SecondDetailCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ss];
        }
        ((SecondDetailCell*)cell).dealDict = self.dealDict;
        /*
        if(((NSString*)self.dealDict[DEAL_SHARED_BY]).length){
            //((SecondDetailCell*)cell).
        }
        else{
            
        }
         */
        
    }
    else if (indexPath.row == 2){
        static NSString* ss = @"TagCell";
        //NSLog(@"%@",self.subCategories[0]);
        cell = (TagsTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:ss];
        NSLog(@"%@", cell);
        if(!cell){
            cell = [[TagsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ss];
        }
        if(self.dealDict[@"tags"]){
            ((TagsTableViewCell*)cell).tags = [self.dealDict[@"tags"] componentsSeparatedByString:@","];
        }
        //((TagsTableViewCell*)cell).tags = TAG_ARRAY;
    }
    else if (indexPath.row == 3){
        static NSString* ss = @"StoreTableViewCell";
        //NSLog(@"%@",self.subCategories[0]);
        cell = (StoreTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:ss];
        NSLog(@"%@", cell);
        if(!cell){
            cell = [[StoreTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ss];
        }
        [((StoreTableViewCell*)cell).mapView addGestureRecognizer:self.tap];
        NSDictionary* dealDict = self.masterDealDict ? self.masterDealDict :self.dealDict;
        ((StoreTableViewCell*)cell).dealDict = dealDict;
        CLLocationCoordinate2D loc2D = CLLocationCoordinate2DMake([dealDict[DEAL_LAT]doubleValue], [dealDict[DEAL_LONG]doubleValue]);
        [((StoreTableViewCell*)cell).mapView setCenterCoordinate:loc2D zoomLevel:7 animated:NO];
        //[((StoreTableViewCell*)cell).mapView setCenterCoordinate:loc2D];
        NSLog(@"%d",[((StoreTableViewCell*)cell).mapView getZoomLevel]);

    }
    else if (indexPath.row == 4){
        static NSString* ss = @"reviewsCell";
        cell = (ReviewsCell*)[tableView dequeueReusableCellWithIdentifier:ss forIndexPath:indexPath];
        int indexOffset = 37;
        for(ReviewView* view in self.listOfReviewViews){
            view.frame = CGRectMake(20, indexOffset, view.frame.size.width, view.frame.size.height);
            [cell addSubview:view];
            indexOffset += view.frame.size.height + 8 ;
        }
    }
    NSLog(@"%@", cell);
    return cell;
}

- (NSArray*) makeAnnotations{

    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:CURRENT_LOCATION_ANNOTATION,DEAL_TITLE, [NSNumber numberWithDouble:self.currentLocation.coordinate.latitude], DEAL_LAT, [NSNumber numberWithDouble:self.currentLocation.coordinate.longitude], DEAL_LONG, nil];
    return  [NSArray arrayWithObjects:[DealAnnotation annotationForDeal:dict], [DealAnnotation annotationForDeal:self.dealDict],nil];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"map"]){
        MapViewController *mvc = (MapViewController*)segue.destinationViewController;
        mvc.annotations = [self makeAnnotations];
        mvc.pinLocation = [[CLLocation alloc]initWithLatitude:[[mvc.annotations[1] dealDict][DEAL_LAT]doubleValue] longitude:[[mvc.annotations[0] dealDict][DEAL_LONG] doubleValue]];
        mvc.currentLocation = self.currentLocation;
    }
    if([segue.identifier isEqualToString:@"tofirsttop"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        FirstTopViewController* ftvc = (FirstTopViewController*)segue.destinationViewController;
        NSString* query = [NSString stringWithFormat:@"http://onsalelocal.com/osl2/ws/offer/search?format=json&merchant=%@",[(NSString*)self.dealDict[DEAL_STORE] gtm_stringByEscapingForURLArgument]];
        
        
        
        if(indexPath.row>1){
            query = [query stringByAppendingFormat:@"&subcategory=%@", [(NSString*)self.subCategories[indexPath.row-2] gtm_stringByEscapingForURLArgument]];
        }
        NSLog(@"%@", query);
        ftvc.nextQuery = query;
        ftvc.useBackButton = YES;
    }
    if([segue.identifier isEqualToString:@"goToGoogle"]){
        CLLocationCoordinate2D location = self.currentLocation.coordinate;
        double currentLat = location.latitude;
        double currentLong = location.longitude;
        
        NSString *googleUrl = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f", currentLat, currentLong, [self.dealDict[DEAL_LAT] doubleValue], [self.dealDict[DEAL_LONG] doubleValue]];
        //if(DEBUG) NSLog(@"%@", googleUrl);
        WebViewController* wvc = (WebViewController*) segue.destinationViewController;
        wvc.url = [NSURL URLWithString: googleUrl];
        
    }
    if([segue.identifier isEqualToString:@"goToSourceWebsite"]){
        
        
        NSString *sourceURLString = self.dealDict[DEAL_FROM_URL];
        //if(DEBUG) NSLog(@"%@", sourceURLString);
        WebViewController* wvc = (WebViewController*) segue.destinationViewController;
        wvc.url = [NSURL URLWithString: sourceURLString];
        
    }
    if([segue.identifier isEqualToString:@"dealComment"]){
        DealCommentViewController* dcvc = (DealCommentViewController*)segue.destinationViewController;
        dcvc.dealDict = self.dealDict;
    }
}

- (UIImageView *)mapViewController:(MapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation
{
    DealAnnotation *fpa = (DealAnnotation *)annotation;
    NSURL *url = [NSURL URLWithString:fpa.dealDict[DEAL_IMAGE_URL]];
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"downloading80.jpeg"]];
    return imageView ;
}



- (void) attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url{
    //NSString *sourceURLString = self.dealDict[DEAL_FROM_URL];
    //if(DEBUG) NSLog(@"%@", sourceURLString);
    WebViewController* wvc = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    wvc.url = url;
    [self.navigationController pushViewController:wvc animated:YES];
}

- (void) mapButtonPressed{
    /*
    MapViewController *mvc = [self.storyboard instantiateViewControllerWithIdentifier:@"mapView"];
    mvc.annotations = [self makeAnnotations];
    mvc.pinLocation = [[CLLocation alloc]initWithLatitude:[[mvc.annotations[1] dealDict][DEAL_LAT]doubleValue] longitude:[[mvc.annotations[0] dealDict][DEAL_LONG] doubleValue]];
    mvc.currentLocation = self.currentLocation;
    [self presentViewController:mvc animated:YES completion:nil];
     */
    CLLocationCoordinate2D location = self.currentLocation.coordinate;
    double currentLat = location.latitude;
    double currentLong = location.longitude;
    
    NSString *googleUrl = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f", currentLat, currentLong, [self.dealDict[DEAL_LAT] doubleValue], [self.dealDict[DEAL_LONG] doubleValue]];
    //if(DEBUG) NSLog(@"%@", googleUrl);
    WebViewController* wvc = (WebViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    wvc.url = [NSURL URLWithString: googleUrl];
    [self.navigationController pushViewController:wvc animated:YES];
}

- (void) bookMarkPressed{
    [self bookMarkPressed:self];
}

- (void) callPressed{
    [self callPhone:self];
}

#warning Fix what is put into the item like description
-(void)sharePressed{
    InviteFriendsViewController* ivc = [self.storyboard instantiateViewControllerWithIdentifier:@"invite"];
    ivc.like = YES;
    ivc.itemLikeDescription = self.dealDict[DEAL_TITLE];
    
    [self.navigationController pushViewController:ivc animated:YES];
    
    
}

-(void)commentPressed{
    [self performSegueWithIdentifier:@"dealComment" sender:self];
}

- (BOOL) set: (NSSet*) set containesDictionaryWithKey: (NSString*) key thatMatchesValue:(NSString*) value{
    for(NSDictionary* dict in set){
        if ([dict[key] isEqualToString:value]) {
            return YES;
        }
    }
    return NO;
}

- (NSSet*) removeDictionaryWithKey: (NSString*) key value: (NSString*) value fromSet:(NSSet*) set{
    NSMutableArray* arr = [[set allObjects]mutableCopy];
    for(int i=0; i<arr.count;i++){
        NSDictionary* dict = arr[i];
        if ([dict[key] isEqualToString:value]) {
            [arr removeObjectAtIndex:i];
            break;
        }
    }
    return [NSSet setWithArray:arr];
}

#pragma mark - NSURLConnection Delegates

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if(connection == self.offerDetailsConnection){
        self.offerDetailsResponseData = [[NSMutableData alloc] init];
    }
    if(connection == self.userLikeConnection){
        self.userLikeData = [[NSMutableData alloc]init];
    }
    if(connection == self.commentsConnection){
        self.commentsData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if(connection == self.offerDetailsConnection){
        [self.offerDetailsResponseData appendData:data];
    }
    if(connection == self.userLikeConnection){
        [self.userLikeData appendData:data];
    }
    if(connection == self.commentsConnection){
        [self.commentsData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if(connection == self.offerDetailsConnection){
        NSLog(@"Failed to fetch data");
        //[textView setString:@"Unable to fetch data"];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(connection == self.offerDetailsConnection){
        NSLog(@"Succeeded! Received %d bytes of data",[self.offerDetailsResponseData
                                                       length]);
        NSString *txt = [[NSString alloc] initWithData:self.offerDetailsResponseData encoding: NSASCIIStringEncoding];
        NSLog(@"%@", txt);
        NSError* error = nil;
        NSData* d = [txt dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:d options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments error:&error];
        if(error)NSLog(@"%@",error.localizedDescription);
        self.dealDict = result;
    }
    if(connection == self.userLikeConnection){
        NSLog(@"Succeeded! Received %d bytes of data",[self.userLikeData
                                                       length]);
        NSString *txt = [[NSString alloc] initWithData:self.userLikeData encoding: NSASCIIStringEncoding];
        NSLog(@"%@", txt);
        NSError* error = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:self.userLikeData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
        self.userLikeDealDict = result;
        NSLog(@"%@",self.userLikeDealDict);
    }
    if(connection == self.commentsConnection){
        NSLog(@"Succeeded! Received %d bytes of data",[self.commentsData
                                                       length]);
        NSString *txt = [[NSString alloc] initWithData:self.commentsData encoding: NSASCIIStringEncoding];
        NSLog(@"%@", txt);
        NSError* error = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:self.commentsData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
        self.commentsDealDict = result;
        NSLog(@"%@",self.commentsDealDict);
    }
    
    if(self.dealDict && self.userLikeDealDict && self.commentsDealDict){
        /*
        self.masterDealDict = [[NSMutableDictionary alloc]init];
       
        [self.masterDealDict addEntriesFromDictionary:self.dealDict];
        [self.masterDealDict addEntriesFromDictionary:self.userLikeDealDict];
        [self.masterDealDict addEntriesFromDictionary:self.commentsDealDict];
        */
        
        //[[EGOCache globalCache] setObject:self.masterDealDict forKey:self.masterDealDict[DEAL_ID] withTimeoutInterval:10400];
        
    }
    
    [self.tableView reloadData];
    
}

- (MKAnnotationView*) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"ONE"];
    NSDictionary* dealDict = self.masterDealDict;
    CLLocationCoordinate2D loc2D = CLLocationCoordinate2DMake([dealDict[DEAL_LAT]doubleValue], [dealDict[DEAL_LONG]doubleValue]);
    [mapView setCenterCoordinate:loc2D zoomLevel:7 animated:NO];
    return nil;
}

- (IBAction)followButtonPressed:(id)sender {
}

/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    ScrollDirection scrollDirection;
    if (self.lastContentOffset > scrollView.contentOffset.y)
        scrollDirection = ScrollDirectionUp;
    else if (self.lastContentOffset < scrollView.contentOffset.y)
        scrollDirection = ScrollDirectionDown;
    else
        scrollDirection = ScrollDirectionNone;
    
    self.lastContentOffset = scrollView.contentOffset.y;
    
    // do whatever you need to with scrollDirection here.
    if(scrollDirection == ScrollDirectionDown){
        [UIView animateWithDuration:.4 animations:^{
            UIView* bottonBar = self.tabBarController.tabBar;
            CGRect frame = bottonBar.frame;
            frame.origin.y = self.view.frame.size.height;
        
        }];
    }
    else{
        
    }
}
 */
@end
