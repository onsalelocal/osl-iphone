//
//  StoreProfileCommentsViewController.m
//  OnsaleLocal
//
//  Created by Jon on 6/19/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//


#import "StoreProfileCommentsViewController.h"
#import "OnsaleLocalConstants.h"
#import "RootViewController.h"
#import "ModelController.h"
#import "DownloadObject.h"
#import "StoreCommentViewController.h"

@interface StoreProfileCommentsViewController ()

@property (strong, nonatomic) NSArray* commentDictionaries;

@end


@implementation StoreProfileCommentsViewController

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
    self.info = self.info;//resets labels
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firstDownloadDone:) name:DATA_OBJECT_ONE_DONE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(secondDownloadDone:) name:DATA_OBJECT_TWO_DONE object:nil];
    self.storeLogoImageView.hidden = YES;
}

- (void) setCommentDictionaries:(NSArray *)commentDictionaries{
    if(_commentDictionaries != commentDictionaries){
        _commentDictionaries = commentDictionaries;
        [self.tableView reloadData];
    }
}

-(void) firstDownloadDone: (NSNotification*) notification{
    NSLog(@"%@", notification.userInfo[@"key"]);
}

-(void) secondDownloadDone: (NSNotification*) notification{
    self.commentDictionaries = notification.userInfo[@"key"][@"items"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
-(void)setCommentObjects:(NSArray *)commentObjects{
    if(_commentObjects != commentObjects){
        _commentObjects = commentObjects;
        [self.tableView reloadData];
    }
}
*/
- (IBAction)likePressed:(id)sender {
    NSString* urlString = [NSString stringWithFormat:@"http://onsalelocal.com/osl2/ws/v2/store/like/%@", self.info[STORE_ID] ];
    NSLog(@"%@",urlString);
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:
                              [cookieJar cookies]];
    [request setAllHTTPHeaderFields:headers];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSLog(@"%@",[request allHTTPHeaderFields]);
    DownloadObject* d = [[DownloadObject alloc]init];
    [d beginConnectionWithRequest:request];
    
}

-(void) setInfo:(id)info{
    _info = info;
    [self.storeLogoImageView setImageWithURL:[NSURL URLWithString:info[STORE_IMAGE_URL]] placeholderImage:[UIImage imageNamed:@"downloading80.jpeg"]];
    self.followersCountLabel.text = [NSString stringWithFormat:@"%@\n%@", info[STORE_FOLLOWER_COUNT], [info[STORE_FOLLOWER_COUNT]intValue] == 1 ?@"Follower" : @"Followers" ];
    self.storeNameLabel.text = info[STORE_NAME];
    self.storeAddressLabel.text = info[STORE_ADDRESS];
    self.cityAndStateLabel.text = [NSString stringWithFormat:@"%@, %@", info[STORE_CITY], info[STORE_STATE]];
    if(info[STORE_PHONE]){
        self.phoneLabel.hidden = NO;
        NSString *phone = [NSString stringWithFormat:@"%@", info[STORE_PHONE]];
        if ([[phone substringToIndex:1] isEqualToString:@"1"]) {
            phone = [phone substringFromIndex:1];
        }
        phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@"." withString:@""];
        NSRange mid = NSMakeRange(3, 3);
        //self.phoneLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.phoneLabel.text = [NSString stringWithFormat:@"(%@) %@-%@",[phone substringToIndex:3],[phone substringWithRange:mid],[phone substringFromIndex:6]];
    }
    else{
        self.phoneLabel.hidden = YES;
    }
    MKPointAnnotation* ann = [[MKPointAnnotation alloc]init];
    ann.coordinate = CLLocationCoordinate2DMake([self.info[STORE_LAT] doubleValue], [self.info[STORE_LONG]doubleValue]);
    [self.mapView addAnnotation:ann];
    self.mapView.centerCoordinate = ann.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(.005, .005);
    self.mapView.region = MKCoordinateRegionMake(ann.coordinate, span);
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKPinAnnotationView* pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"storePin"];
    pin.pinColor = MKPinAnnotationColorRed;
    return pin;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentDictionaries.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 66;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"StoreCommentsCell" forIndexPath:indexPath];
    
    return cell;
}

- (IBAction)dealButtonPressed:(id)sender {
    RootViewController* root = (RootViewController*)self.parentViewController.parentViewController;
    UIViewController* vc = [root.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
    NSArray* arr = @[vc];
    [root.pageViewController setViewControllers:arr direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

- (IBAction)commentsButtonPressed:(id)sender {
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showComment"]){
        StoreCommentViewController* scvc = (StoreCommentViewController*)segue.destinationViewController;
        int row = [self.tableView indexPathForSelectedRow].row;
        NSMutableDictionary* dict = [self.commentDictionaries[row] mutableCopy];
        [dict addEntriesFromDictionary:@{STORE_NAME:self.info[STORE_NAME]}];
        scvc.infoDict = dict;
    }
}

@end
