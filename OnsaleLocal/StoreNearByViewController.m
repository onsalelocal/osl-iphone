//
//  StoreNearByViewController.m
//  OnsaleLocal
//
//  Created by Jon on 6/5/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "StoreNearByViewController.h"
#import "StoreCollectionCell.h"
#import "OnsaleLocalConstants.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "Container.h"
#import "RootViewController.h"
#import "ModelController.h"
#import "StorePointAnnotation.h"
#import "Container.h"

@interface StoreNearByViewController ()<MKMapViewDelegate, MKAnnotation>
@property (strong, nonatomic) NSArray* stores;

@end

@implementation StoreNearByViewController


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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(containerFinishedUpdating:) name:CONTAINER_UPDATED_NOTIFICATION object:nil];
    //self.sortByNumberOfDeals = NO;
#warning might be wrong database
    self.currentQuery = [NSString stringWithFormat:@"http://onsalelocal.com/osl2/ws/v2/nearby-stores?format=json&latitude=%f&longitude=%f&radius=1&offer=true",[Container theContainer].location.coordinate.latitude,[Container theContainer].location.coordinate.longitude];
    
    //NSLog(@"%@",self.slidingViewController);
    [self refresh:self];
    CLLocationCoordinate2D coordinate = [Container theContainer].location.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake([Container theContainer].radius*.01, [Container theContainer].radius*.01);
    self.mapView.region = MKCoordinateRegionMake(coordinate, span);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setJsonDataFromQuery:(NSData *)jsonDataFromQuery{
    [super setJsonDataFromQuery:jsonDataFromQuery];
    self.stores = self.resultsArrayOfDictionaries;
    NSLog(@"%@", self.stores);
    [[self collectionView] reloadData];
}

-(void)setStores:(NSArray *)stores{
    [self.mapView removeAnnotations:self.stores];
    NSMutableArray* arr = [NSMutableArray array];
    for(NSDictionary* d in stores){
        StorePointAnnotation* pointAnn = [[StorePointAnnotation alloc]initWithStoreDictionary:d];
        [arr addObject:pointAnn];
    }
    _stores = arr;
    [self.mapView addAnnotations:self.stores];
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    //NSLog(@"%@", ((MKPointAnnotation*)view).title);
    
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKPinAnnotationView* view = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"point"];
    if(!view){
        view = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"point"];
        view.pinColor = MKPinAnnotationColorRed;
        view.animatesDrop = YES;
        view.canShowCallout = YES;
        view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }else{
        view.annotation = annotation;
    }
    return view;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    RootViewController* rvc = [self.storyboard instantiateViewControllerWithIdentifier:@"storeSelected"];
    //NSIndexPath* indexPath = [[self.collectionView indexPathsForSelectedItems]lastObject];
    rvc.info = ((StorePointAnnotation*)view.annotation).storeDict;
    NSLog(@"%@",rvc.info);
    rvc.modelController.dataType = DataTypeStoreProfile;
    [self.rootDelegate didSelectItem:rvc andIdentifier:@"storeSelected"];
}


/*
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.resultsArrayOfDictionaries.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    StoreCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.dataObject forIndexPath:indexPath];
    cell.count.text = [NSString stringWithFormat:@"(%@)",self.stores[indexPath.row][STORE_NUMBER_OF_OFFERS]];
    __weak StoreCollectionCell *cellCopy = cell;
    NSURL* url = [NSURL URLWithString:self.stores[indexPath.row][@"logo"]];
    if(!self.stores[indexPath.row][@"logo"]){
        [cell hideImage:YES];
        NSLog(@"%@",self.stores[indexPath.row]);
        NSString* text = self.stores[indexPath.row][STORE_LOOKUP_NAME];
        cell.nameLabel.text = text;
    }
    else{
        [cell hideImage:NO];
        [cell.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"downloading80.jpeg"] completed:^(UIImage* image, NSError* error, SDImageCacheType cacheType){
            
            if([self isBlankImage:image]){
                [cellCopy.imageView setImage:[UIImage imageNamed:@"place_holder_red_tag.jpg"]];
            }
            
        }];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    RootViewController* rvc = [self.storyboard instantiateViewControllerWithIdentifier:@"storeSelected"];
    //NSIndexPath* indexPath = [[self.collectionView indexPathsForSelectedItems]lastObject];
    rvc.info = self.stores[indexPath.row];
    NSLog(@"%@",rvc.info);
    rvc.modelController.dataType = DataTypeStoreProfile;
    [self.rootDelegate didSelectItem:rvc andIdentifier:@"storeSelected"];
    
}

- (void) containerFinishedUpdating:(NSNotification*) notification{
    [self refresh:self];
}

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
 */

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    RootViewController* rvc = (RootViewController*)segue.destinationViewController;
    NSIndexPath* indexPath = [[self.collectionView indexPathsForSelectedItems]lastObject];
    rvc.info = self.stores[indexPath.row];
}


@end
