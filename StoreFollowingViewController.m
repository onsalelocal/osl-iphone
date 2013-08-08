//
//  StoreFollowingViewController.m
//  OnsaleLocal
//
//  Created by Jon on 6/5/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "StoreFollowingViewController.h"
#import "OnsaleLocalConstants.h"
#import "StoreCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "RootViewController.h"

@interface StoreFollowingViewController ()

@property (strong, nonatomic) NSArray* favorites;//array of deal dictionaries

@end

@implementation StoreFollowingViewController



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
    /*
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath
                          stringByAppendingPathComponent:FAVORITE_STORE_FILE_NAME];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        self.favorites = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    }
    */
    self.currentQuery = [NSString stringWithFormat:@"http://onsalelocal.com/osl2/ws/v2/following-stores?format=json"];
    [self refresh:self];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    /*
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath
                          stringByAppendingPathComponent:FAVORITE_STORE_FILE_NAME];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        UIAlertView* popup = [[UIAlertView alloc]initWithTitle:@"No Favorites Set" message:@"Please select the Favorite button on a deal to add it to your Favorites list." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [popup show];
        
    }
     */
}


- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    /*
    if(self.favorites){
        NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectoryPath
                              stringByAppendingPathComponent:FAVORITE_STORE_FILE_NAME];
        [self.favorites writeToFile:filePath atomically:YES];
    }
     */
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.favorites.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    StoreCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.dataObject forIndexPath:indexPath];
    
    cell.count.text = [NSString stringWithFormat:@"(%@)",self.favorites[indexPath.row][STORE_DEAL_COUNT]];
    __weak StoreCollectionCell *cellCopy = cell;
    NSURL* url = [NSURL URLWithString:self.favorites[indexPath.row][@"imageURL"]];
    [cell.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"downloading80.jpeg"] completed:^(UIImage* image, NSError* error, SDImageCacheType cacheType){
        
        if([self isBlankImage:image]){
            [cellCopy.imageView setImage:[UIImage imageNamed:@"place_holder_red_tag.jpg"]];
        }
        
    }];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    RootViewController* rvc = [self.storyboard instantiateViewControllerWithIdentifier:@"storeSelected"];
    //NSIndexPath* indexPath = [[self.collectionView indexPathsForSelectedItems]lastObject];
    rvc.info = self.resultsArrayOfDictionaries[indexPath.row];
    [self.rootDelegate didSelectItem:rvc andIdentifier:@"storeSelected"];
    
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
/*
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    RootViewController* rvc = (RootViewController*)segue.destinationViewController;
    NSIndexPath* indexPath = [[self.collectionView indexPathsForSelectedItems]lastObject];
    rvc.info = self.favorites[indexPath.row];
}
 */
@end
