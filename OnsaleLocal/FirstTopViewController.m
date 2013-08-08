//
//  FirstTopViewController.m
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import "FirstTopViewController.h"
#import "EGOCache.h"
#import "DataFetcher.h"
#import "MyEGOCache.h"
#import "OnsaleLocalConstants.h"
#import "Deal.h"
#import "SearchResultsCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import <CoreLocation/CoreLocation.h>
#import "InitialSlidingViewController.h"
#import "NSString+MD5.h"
#import "ResultsTableViewController.h"
#import "DetailViewController.h"
#import "GTMNSString+URLArguments.h"
#import "Container.h"
#import "MarqueeLabel.h"
#import "NSString+SizeWithNewline.h"
//#import <ApplicationServices/ApplicationServices.h>

#define NAME_LABEL_FRAME CGRectMake(88, 2, 212, 32)
#define IMAGEVIEW_TOTAL_HEIGHT 96

@interface FirstTopViewController()<UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) NSString* locationString;
@property (strong, nonatomic) NSArray* deals;
@property (assign, nonatomic) BOOL afterFirstTimeUsingApp;
@property (strong, nonatomic) UIBarButtonItem* menuButton;
@property (strong, nonatomic) UIView* coverView;
//@property (strong, nonatomic) IBOutlet MarqueeLabel *marqueeLabel;
//@property (strong, nonatomic) IBOutlet UIView* placeHolderView;



@end

@implementation FirstTopViewController

@synthesize deals = _deals;
@synthesize locationString = _locationString;
@synthesize afterFirstTimeUsingApp = _afterFirstTimeUsingApp;
@synthesize useBackButton = _useBackButton;
@synthesize menuButton = _menuButton;
@synthesize autoScrollLabel = _autoScrollLabel;
@synthesize coverView = _coverView; 
@synthesize lsAddition = _lsAddition;


- (IBAction)menuPressed:(id)sender {
    //[super revealMenu:sender];
}

- (IBAction)revealUnderRight:(id)sender{
    
    //[super revealUnderRight:sender];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.view addSubview:self.spinner];
    //[self.spinner startAnimating];
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.currentQuery = [NSString stringWithFormat:@"http://onsalelocal.com/osl/ws/offer/search?format=json"];
    if(self.lsAddition){
        self.currentQuery = [self.currentQuery stringByAppendingFormat:@"&ls=%@",self.lsAddition];
    }

}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    //NSLog(@"%@",[self.view gestureRecognizers]);

}



- (void) viewDidLoad{
    [super viewDidLoad];

    
     //[[NSUserDefaults standardUserDefaults] setBool:NO forKey:AFTER_FIRST_TIME_USER];
    
    //NSLog(@"self.slidingViewController: %@", self.slidingViewController);
    //self.navigationController.navigationItem.hidesBackButton = NO;
    self.afterFirstTimeUsingApp = [[NSUserDefaults standardUserDefaults] boolForKey:AFTER_FIRST_TIME_USER];
    
   
    

}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(!self.afterFirstTimeUsingApp){
        
        [self performSelector:@selector(firstAnimation) withObject:nil afterDelay:1.5];
        self.afterFirstTimeUsingApp = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:AFTER_FIRST_TIME_USER];
    }
    if(!self.useBackButton){
        self.menuButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu21.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(revealMenu:)];
        [self.menuButton setTintColor:[UIColor colorWithRed:176/255.0 green:27/255.0f blue:23/255.0f alpha:1]];
        self.navigationItem.leftBarButtonItem = self.menuButton;
    }
    else{
        [self.navigationItem.backBarButtonItem setTintColor:[UIColor colorWithRed:176/255.0 green:27/255.0f blue:23/255.0f alpha:1]];
    }
    //NSLog(@"%@",self.slidingViewController.underLeftViewController);
    //NSLog(@"%@",self.slidingViewController.underRightViewController);


    

}

-(void) firstAnimation{
    [self.slidingViewController anchorTopViewTo:ECRight animations:nil onComplete:^{
        [self performSelector:@selector(resetAnimation) withObject:nil afterDelay:.8];
    }];
  

}

- (void) secondAnimation{
    
    [self.slidingViewController anchorTopViewTo:ECLeft animations:nil  onComplete:^{
        [self performSelector:@selector(resetAnimation2) withObject:nil afterDelay:.8];
    }];
    
}

-(void) resetAnimation{
    [self.slidingViewController resetTopViewWithAnimations:nil onComplete:^{
        [self performSelector:@selector(secondAnimation) withObject:nil afterDelay:.8];
    }];
}

-(void) resetAnimation2{
    [self.slidingViewController resetTopViewWithAnimations:nil onComplete:^{
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultsArrayOfDictionaries.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchResultsCell *cell = (SearchResultsCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    CGFloat tbr = cell.descriptionLabel.frame.origin.y + cell.descriptionLabel.frame.size.height +2;
    CGFloat num = tbr>IMAGEVIEW_TOTAL_HEIGHT ? tbr : IMAGEVIEW_TOTAL_HEIGHT;
    return num;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"%@",indexPath);
    
    [self.spinner stopAnimating];
    
    NSString *cellIdentifier = @"SearchResultsCell";
    SearchResultsCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[SearchResultsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    for(UIView* view in cell.contentView.subviews){
        //NSLog(@"%@",view);
        if([view isKindOfClass:[UILabel class]]){
            [view removeFromSuperview];
        }
    }
    cell.description = @"";

    Deal* d = [[Deal alloc]initWithContentsOfDictionary:self.resultsArrayOfDictionaries[indexPath.row]];
    NSDictionary* dealDict = self.resultsArrayOfDictionaries[indexPath.row];
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
/*
-(CGFloat)getCellHeight{
    UILabel* label1 = [[UILabel alloc]initWithFrame:NAME_LABEL_FRAME];
    CGRect frame = label1.frame;
    CGSize maximumLabelSize = CGSizeMake(212, FLT_MAX);
    CGSize expectedLabelSize = [label1.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping ];
    frame.size.height = expectedLabelSize.height;
    label1.frame = frame;
    
    UILabel* label2 = [[UILabel alloc]initWithFrame:NAME_LABEL_FRAME];
    CGRect frame2 = label2.frame;
    CGSize maximumLabelSize2 = CGSizeMake(212, FLT_MAX);
    CGSize expectedLabelSize2 = [cell.nameLabel.text sizeWithFont:cell.nameLabel.font constrainedToSize:maximumLabelSize2 lineBreakMode:NSLineBreakByWordWrapping ];
    frame2.size.height = expectedLabelSize2.height;
    cell.descriptionLabel.frame = frame2;

    
    

}
 */

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[DetailViewController class]]){
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController* dvc = (DetailViewController*) segue.destinationViewController;
        //NSLog(@"%@", indexPath);
        [dvc performSelectorOnMainThread:@selector(setDealDict:) withObject:[self.resultsArrayOfDictionaries[indexPath.row]copy] waitUntilDone:YES ];
        //dvc.nextQuery = [NSString stringWithFormat:@"http://onsalelocal.com/osl/ws/offer/search?format=json&merchant=%@",[((NSString*)self.resultsArrayOfDictionaries[indexPath.row][DEAL_STORE]) gtm_stringByEscapingForURLArgument]];
        dvc.currentLocation = self.location;
    }
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