//
//  StoreProfileDealsViewController.m
//  OnsaleLocal
//
//  Created by Jon on 6/20/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "StoreProfileDealsViewController.h"
#import "OnsaleLocalConstants.h"
#import "UIImageView+WebCache.h"
#import "DealCollectionViewCell.h"
#import "Deal.h"
#import "RootViewController.h"
#import "ModelController.h"
#import "DownloadObject.h"

@interface StoreProfileDealsViewController ()

- (IBAction)likePressed:(id)sender;
@end

@implementation StoreProfileDealsViewController

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
#warning  need to set store-deal query
    //self.currentQuery = [NSString stringWithFormat:@""];
    //[self refresh:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadComplete:) name:DATA_OBJECT_ONE_DONE object:nil];
    self.storeLogoImageView.hidden = YES;
    
}
-(void)downloadComplete:(NSNotification*)notification{
    NSDictionary* d = notification.userInfo[@"key"];
    NSLog(@"%@",d);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDealObjects:(NSArray *)dealObjects{
    if(_dealObjects != dealObjects){
        _dealObjects = dealObjects;
        [self.collectionView reloadData];
    }
}

-(void) setInfo:(id)info{
    _info = info;
    [self.storeLogoImageView setImageWithURL:[NSURL URLWithString:info[STORE_IMAGE_URL]] placeholderImage:[UIImage imageNamed:@"downloading80.jpeg"]];
    self.followersCountLabel.text = [NSString stringWithFormat:@"%@\n%@", info[STORE_FOLLOWER_COUNT], [info[STORE_FOLLOWER_COUNT]intValue] == 1 ?@"Follower" : @"Followers" ];
    self.storeNameLabel.text = info[STORE_LOOKUP_NAME];
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
#warning  need to set store-deal query
    NSLog(@"%@", info);
    NSString* query = [NSString stringWithFormat:@"http://onsalelocal.com/osl2/ws/v2/store/offers?format=json&storeId=%@",info[STORE_ID]];
    self.nextQuery = query;
    MKPointAnnotation* ann = [[MKPointAnnotation alloc]init];
    ann.coordinate = CLLocationCoordinate2DMake([self.info[STORE_LAT] doubleValue], [self.info[STORE_LONG]doubleValue]);
    [self.mapView addAnnotation:ann];
    self.mapView.centerCoordinate = ann.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(.005, .005);
    self.mapView.region = MKCoordinateRegionMake(ann.coordinate, span);
    [self refresh:self];
}

- (IBAction)commentsButtonPressed:(id)sender{
    NSLog(@"%@\n%@",NSStringFromClass([self.parentViewController class]), NSStringFromClass([self.parentViewController.parentViewController class]));
// NSLog(@"%@", self.parentViewController.parentViewController.view.gestureRecognizers);
    RootViewController* root = (RootViewController*)self.parentViewController.parentViewController;
    UIViewController* vc = [root.modelController viewControllerAtIndex:1 storyboard:self.storyboard];
    NSArray* arr = @[vc];
    [root.pageViewController setViewControllers:arr direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKPinAnnotationView* pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"storePin"];
    pin.pinColor = MKPinAnnotationColorRed;
    return pin;
}
/*
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
    return self.dealObjects.count;
}

-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DealCollectionViewCell* cell = nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StoreDealCell" forIndexPath:indexPath];
     
    if(!cell){
        
    }
    Deal* d = [[Deal alloc]initWithContentsOfDictionary:self.resultsArrayOfDictionaries[indexPath.row]];
    NSDictionary* dealDict = self.resultsArrayOfDictionaries[indexPath.row];
    cell.dealName.text = d.name;
    if([dealDict[DEAL_PRICE] floatValue]){
        NSString* tempString = [NSString stringWithFormat:@"$%.2f",[dealDict[DEAL_PRICE]floatValue]];
        cell.dealShortDescription.text = [NSString stringWithFormat:@"%@",tempString];
        
    }else{
        cell.dealShortDescription.text = dealDict[DEAL_PRICE];
    }
    if(d.store){
        cell.storeName.text = d.store;
    }
    if(dealDict[DEAL_DISTANCE]){
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.roundingIncrement = [NSNumber numberWithDouble:0.01];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        cell.distanceToLocation.text = [NSString stringWithFormat: @"%@ Mi",[formatter stringFromNumber:[NSNumber numberWithFloat:[dealDict[DEAL_DISTANCE] floatValue]]]];
    }
    __weak DealCollectionViewCell *cellCopy = cell;
    [cell.pictureImageView setImageWithURL:[NSURL URLWithString: d.imageURL] placeholderImage:[UIImage imageNamed:@"downloading80.jpeg"] completed:^(UIImage* image, NSError* error, SDImageCacheType cacheType){
        
        if([self isBlankImage:image]){
            [cellCopy.pictureImageView setImage:[UIImage imageNamed:@"place_holder_red_tag.jpg"]];
        }
        
    }];
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
 
 */

- (BOOL)isBlankImage: (UIImage*) myImage{
    
    //The pixel format depends on what sort of image you're expecting. If it's RGBA, this should work
    typedef struct
    {
        uint8_t red;
        uint8_t green;
        uint8_t blue;
        uint8_t alpha;
    } MyPixel_T;
    
    NSData* pngData = UIImagePNGRepresentation(myImage);
    UIImage* image = [UIImage imageWithData:pngData];
    
    CGImageRef myCGImage = [image CGImage];
    
    //Get a bitmap context for the image
    CGContextRef bitmapContext =
    CGBitmapContextCreate(NULL, CGImageGetWidth(myCGImage), CGImageGetHeight(myCGImage),
                          CGImageGetBitsPerComponent(myCGImage), CGImageGetBytesPerRow(myCGImage),
                          CGImageGetColorSpace(myCGImage), CGImageGetBitmapInfo(myCGImage));
    
    //Draw the image into the context
    CGContextDrawImage(bitmapContext, CGRectMake(0, 0, CGImageGetWidth(myCGImage), CGImageGetHeight(myCGImage)), myCGImage);
    
    //Get pixel data for the image
    MyPixel_T *pixels = CGBitmapContextGetData(bitmapContext);
    size_t pixelCount = CGImageGetWidth(myCGImage) * CGImageGetHeight(myCGImage);
    
    for(size_t i = 0; i < pixelCount; i++)
    {
        MyPixel_T p = pixels[i];
        //Your definition of what's blank may differ from mine
        if(p.red > 0.02 && p.green > 0.02 && p.blue > 0.02 && p.alpha > 0.02)
            return NO;
    }
    
    return YES;
}

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
@end
