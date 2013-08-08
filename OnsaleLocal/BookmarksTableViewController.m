//
//  BookmarksTableViewController.m
//  OnsaleLocal
//
//  Created by Admin on 1/29/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "BookmarksTableViewController.h"
#import "ECSlidingViewController.h"
#import "OnsaleLocalConstants.h"
#import "SearchResultsCell.h"
#import "Deal.h"
#import "UIImageView+WebCache.h"
#import "BookmarkCell.h"
#import "DetailViewController.h"
#import "GTMNSString+URLArguments.h"
#import "SearchResultsCell.h"
#import "NavigationTopViewController.h"

#define IMAGEVIEW_TOTAL_HEIGHT 96
#define NAME_LABEL_FRAME CGRectMake(88, 2, 212, 32)


@interface BookmarksTableViewController ()

@property (strong, nonatomic) NSMutableArray* bookmarkItems;
@property (weak, nonatomic) IBOutlet UIToolbar *bottonBar;

- (IBAction)editButtonPushed:(id)sender;
- (IBAction)search:(id)sender;
@end

@implementation BookmarksTableViewController

@synthesize bookmarkItems = _bookmarkItems;
@synthesize tableView = _tableView;
- (IBAction)search:(id)sender {
    [self revealUnderRight:sender];
}
- (IBAction)editButtonPushed:(id)sender {
    if(self.tableView.isEditing == NO){
        [self.tableView setEditing:YES animated:YES];
    }
    else{
        [self.tableView setEditing:NO animated:YES];
    }
}

- (void) setBookmarkItems:(NSMutableArray *)bookmarkItems{
    if(bookmarkItems != _bookmarkItems){
        _bookmarkItems = bookmarkItems;
        if(_bookmarkItems == nil || _bookmarkItems.count == 0){
            UIAlertView* popup = [[UIAlertView alloc]initWithTitle:@"No Bookmarks Set" message:@"Please select the Bookmark button on a deal to add it to your Bookmark list." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [popup show];
        }
        [self.tableView reloadData];
    }
}

- (void) viewDidLoad{
    [super viewDidLoad];
    [self.bottonBar setBackgroundImage:[UIImage imageNamed:@"navBarBackground.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath
                          stringByAppendingPathComponent:BOOKMARK_FILE_NAME];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        self.bookmarkItems = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    }
    else{
        UIAlertView* popup = [[UIAlertView alloc]initWithTitle:@"No Bookmarks Set" message:@"Please select the Bookmark button on a deal to add it to your Bookmark list." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [popup show];
    }
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    if (![self.slidingViewController.underRightViewController isKindOfClass:[UnderRightViewController class]]) {
        self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UnderRight"];
        NSLog(@"%@", self.slidingViewController.underRightViewController);
    }
    
    //NSLog(@"%@ _____ %@",self.slidingViewController, self.slidingViewController.panGesture);
    
    //NSLog(@"%@", self.parentViewController);
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    //[self refresh:self];
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)revealUnderRight:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECLeft];
}



- (void) viewWillDisappear:(BOOL)animated{
    if(self.bookmarkItems){
        NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectoryPath
                              stringByAppendingPathComponent:BOOKMARK_FILE_NAME];
        [self.bookmarkItems writeToFile:filePath atomically:YES];
    }
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
    return self.bookmarkItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    NSString* cellID = @"subtitle";
    
    Deal* d = [[Deal alloc]initWithContentsOfDictionary:self.bookmarkItems[indexPath.row]];
    
    
    /*
    //Deal* deal = (Deal*)self.deals[indexPath.row];
    cell.textLabel.text = d.name;
    cell.detailTextLabel.text = d.deal;
    if(d.store){
        cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingFormat:@"\n%@", d.store];
    }
    if(d.cityAndDistanceString){
    cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingFormat:@"\n%@", d.cityAndDistanceString ];
    }
    //cell.autoresizesSubviews = NO;
    //cell.imageView.frame = CGRectMake(5,12,80,80);
    //cell.imageView.autoresizesSubviews = NO;
    
    [cell.imageView setImageWithURL:[NSURL URLWithString: d.imageURL] placeholderImage:[UIImage imageNamed:@"downloading80.jpeg"] completed:^(UIImage* image, NSError* error, SDImageCacheType cacheType){
        //image = [self scaleTheImage:image];
    }];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;

    return cell;
     
     */
    SearchResultsCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[SearchResultsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    for(UIView* view in cell.contentView.subviews){
        //NSLog(@"%@",view);
        if([view isKindOfClass:[UILabel class]]){
            [view removeFromSuperview];
        }
    }
    cell.description = @"";
    
    
    NSDictionary* dealDict = self.bookmarkItems[indexPath.row];
    //Deal* deal = (Deal*)self.deals[indexPath.row];
    cell.nameLabel = nil;
    cell.descriptionLabel = nil;
    cell.nameLabel = [[UILabel alloc]initWithFrame:NAME_LABEL_FRAME];
    cell.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    cell.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.nameLabel.numberOfLines = 0;
    cell.nameLabel.text = d.name;
    CGRect frame = cell.nameLabel.frame;
    CGSize maximumLabelSize = CGSizeMake(212, FLT_MAX);
    CGSize expectedLabelSize = [cell.nameLabel.text sizeWithFont:cell.nameLabel.font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping ];
    frame.size.height = expectedLabelSize.height;
    cell.nameLabel.frame = frame;
    [cell.contentView addSubview:cell.nameLabel];
    //cell.descriptionLabel.text = d.deal;
    if([dealDict[DEAL_PRICE] floatValue]){
        NSString* tempString = [NSString stringWithFormat:@"$%.2f",[dealDict[DEAL_PRICE]floatValue]];
        cell.description = [cell.description stringByAppendingFormat:@"%@",tempString];
        
    }else{
        cell.description = dealDict[DEAL_PRICE];
    }
    
    NSRange range;
    
    if(dealDict[DEAL_DISCOUNT]){
        
        cell.description = [cell.description stringByAppendingFormat:@" %@",dealDict[DEAL_DISCOUNT]];
        range = [cell.description rangeOfString:dealDict[DEAL_DISCOUNT]];
    }
    
    if(d.store){
        //cell.descriptionLabel.text = [cell.descriptionLabel.text stringByAppendingFormat:@"\n%@",d.store];
        if([cell.description length] > 0){
            cell.description = [cell.description stringByAppendingString:@"\n"];
        }
        cell.description = [cell.description stringByAppendingFormat:@"%@",d.store];
    }
    
    if(d.cityAndDistanceString){
        // cell.descriptionLabel.text = [cell.descriptionLabel.text stringByAppendingFormat:@"\n%@",d.cityAndDistanceString];
        cell.description = [cell.description stringByAppendingFormat:@"\n%@",d.cityAndDistanceString];
        
    }
    cell.descriptionLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(88, cell.nameLabel.frame.origin.y+cell.nameLabel.frame.size.height+2, 212, 80)];
    cell.descriptionLabel.numberOfLines = 0;
    cell.descriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    cell.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGRect frame2 = cell.descriptionLabel.frame;
    CGSize maximumLabelSize2 = CGSizeMake(212, FLT_MAX);
    CGSize expectedLabelSize2 = [cell.description sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13] constrainedToSize:maximumLabelSize2 lineBreakMode:NSLineBreakByWordWrapping ];
    frame2.size.height = expectedLabelSize2.height+2;
    //cell.descriptionLabel.backgroundColor = [UIColor redColor];
    //NSLog(@"cell Height: %f",frame2.size.height);
    cell.descriptionLabel.frame = frame2;
    [cell.descriptionLabel setText:cell.description afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString* (NSMutableAttributedString *mutableAttributedString){
        if(dealDict[DEAL_DISCOUNT] && range.location != NSNotFound){
            //NSLog(@"%d",range.length);
            [mutableAttributedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:range];
            [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor redColor] CGColor] range:range];
        }
        
        
        return mutableAttributedString;
    }];
    //NSLog(@"%@",cell.descriptionLabel.text);
    [cell.contentView addSubview:cell.descriptionLabel];
    //NSLog(@"%@", d.imageURL);
    __weak SearchResultsCell *cellCopy = cell;
    [cell.imageView setImageWithURL:[NSURL URLWithString: d.imageURL] placeholderImage:[UIImage imageNamed:@"downloading80.jpeg"] completed:^(UIImage* image, NSError* error, SDImageCacheType cacheType){
        //NSLog(@"%@",error.localizedDescription);
        //NSLog(@"%@, %@", indexPath, d.imageURL);
        /*
         if (cim == nil && cgref == NULL)
         {
         [cellCopy.imageView setImage:[UIImage imageNamed:@"place_holder_red_tag.jpg"]];
         }
         */
        if([self isBlankImage:image]){
            [cellCopy.imageView setImage:[UIImage imageNamed:@"place_holder_red_tag.jpg"]];
        }
        
    }];
    //cell.imageView.autoresizingMask = UIView | UIViewAutoresizingFlexibleWidth;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.nameLabel.clipsToBounds = YES;
    //cell.descriptionLabel.clipsToBounds = YES;
    CGPoint center = cell.imageView.center;
    center.y = cell.frame.size.height / 2;
    cell.imageView.center = center;
    
    return cell;


}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //[cell.contentView addSubview:cell.textLabel];
    //[cell.contentView addSubview:cell.detailTextLabel];
    
    //[cell.contentView sendSubviewToBack:cell.textLabel];
    //[cell.contentView sendSubviewToBack:cell.detailTextLabel];
    
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView beginUpdates];
        
        [self.bookmarkItems removeObjectAtIndex:indexPath.row];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [tableView endUpdates];
    }   
      
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[DetailViewController class]]){
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController* dvc = (DetailViewController*) segue.destinationViewController;
        NSLog(@"%@", indexPath);
        [dvc performSelectorOnMainThread:@selector(setDealDict:) withObject:[self.bookmarkItems[indexPath.row]copy] waitUntilDone:YES ];
        //dvc.nextQuery = [NSString stringWithFormat:@"http://onsalelocal.com/osl/ws/offer/search?format=json&merchant=%@",[((NSString*)self.bookmarkItems[indexPath.row][DEAL_STORE]) gtm_stringByEscapingForURLArgument]];
        dvc.currentLocation = ((InitialSlidingViewController*)self.slidingViewController).location;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchResultsCell *cell = (SearchResultsCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    CGFloat tbr = cell.descriptionLabel.frame.origin.y + cell.descriptionLabel.frame.size.height +2;
    CGFloat num = tbr>IMAGEVIEW_TOTAL_HEIGHT ? tbr : IMAGEVIEW_TOTAL_HEIGHT;
    return num;
}

-(UIImage*)scaleTheImage:(UIImage*)image
{
    CGSize size = CGSizeMake(80, 80);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (CGFloat) heightOfCellBasedOnStrings: (NSArray*) strings withFonts:(NSArray*) fonts maxWidth:(CGFloat) width {
    NSAssert(strings.count == fonts.count, @"Number of strings != Number of Fonts");
    CGFloat sumHeight = 0;
    NSLog(@"%@", strings);
    NSLog(@"%@",fonts);
    for(int i = 0; i < strings.count; i++){
        
        CGSize maximumLabelSize2 = CGSizeMake(width, FLT_MAX);
        CGSize expectedLabelSize2 = [strings[i] sizeWithFont:fonts[i] constrainedToSize:maximumLabelSize2 lineBreakMode:NSLineBreakByWordWrapping ];
        sumHeight += expectedLabelSize2.height;
        
    }
    
    
    return sumHeight;
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


@end
