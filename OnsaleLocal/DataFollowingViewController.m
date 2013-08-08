//
//  DataFollowingViewController.m
//  OnsaleLocal
//
//  Created by Jon on 6/5/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "DataFollowingViewController.h"
#import "OnsaleLocalConstants.h"
#import "DealCollectionViewCell.h"
#import "DetailViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"


@interface DataFollowingViewController ()

@property (strong, nonatomic) NSArray* favorites;//array of deal dictionaries

@end

@implementation DataFollowingViewController

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
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath
                          stringByAppendingPathComponent:FAVORITE_DEALS_FILE_NAME];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        self.favorites = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    }


}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath
                          stringByAppendingPathComponent:FAVORITE_DEALS_FILE_NAME];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        UIAlertView* popup = [[UIAlertView alloc]initWithTitle:@"No Favorites Set" message:@"Please select the Favorite button on a deal to add it to your Favorites list." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [popup show];
        
    }
}


- (void) viewWillDisappear:(BOOL)animated{
    if(self.favorites){
        NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectoryPath
                              stringByAppendingPathComponent:FAVORITE_DEALS_FILE_NAME];
        [self.favorites writeToFile:filePath atomically:YES];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.favorites.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DealCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"deal2" forIndexPath:indexPath];
    
    
    
    Deal* d = [[Deal alloc]initWithContentsOfDictionary:self.favorites[indexPath.row]];
    NSDictionary* dealDict = self.favorites[indexPath.row];
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
        //NSLog(@"%@",error.localizedDescription);
        //NSLog(@"%@, %@", indexPath, d.imageURL);
        /*
         if (cim == nil && cgref == NULL)
         {
         [cellCopy.imageView setImage:[UIImage imageNamed:@"place_holder_red_tag.jpg"]];
         }
         */
        if([self isBlankImage:image]){
            [cellCopy.pictureImageView setImage:[UIImage imageNamed:@"place_holder_red_tag.jpg"]];
        }
        
    }];
    
    return cell;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController* dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"detailVC"];
    //int index = ((NSIndexPath*)[[self.collectionView indexPathsForSelectedItems]lastObject]).row;
    
    //dvc.dealDict = self.resultsArrayOfDictionaries[index];
    dvc.offerID = self.favorites[indexPath.row][DEAL_ID];
    [self.rootDelegate didSelectItem:dvc andIdentifier:@"detailVC"];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
/*
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    DetailViewController* dvc = (DetailViewController*)segue.destinationViewController;
    int index = ((NSIndexPath*)[[self.collectionView indexPathsForSelectedItems]lastObject]).row;
    //dvc.dealDict = self.resultsArrayOfDictionaries[index];
    dvc.offerID = self.favorites[index][DEAL_ID];
    
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



@end
