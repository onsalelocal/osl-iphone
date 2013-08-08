//
//  OffersOrDealsViewController.m
//  OnsaleLocal
//
//  Created by Admin on 3/25/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "OffersOrDealsViewController.h"
#import "ECSlidingViewController.h"
#import "FirstTopViewController.h"

@interface OffersOrDealsViewController ()

@property (strong, nonatomic) NSArray* localOffersFileNames;
@property (strong, nonatomic) NSArray* weeklyDealsFileNames;
@property (assign, nonatomic) int weeklyCount;
@property (assign, nonatomic) int offerCount;

@end

@implementation OffersOrDealsViewController

@synthesize localOffersFileNames = _localOffersFileNames;
@synthesize weeklyDealsFileNames = _weeklyDealsFileNames;
@synthesize weeklyCount = _weeklyCount;
@synthesize offerCount = _offerCount;

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
    self.localOffersFileNames = @[@"store_logo_amazon.jpg",@"store_logo_deal_chicken.jpg",@"store_logo_google_offers.jpg",@"store_logo_groupon_logo.jpg",@"store_logo_lifebooker.jpeg",@"store_logo_livingsocial.jpeg",@"store_logo_yipit.jpeg"];
    self.weeklyDealsFileNames = @[@"store_logo_bestbuy.jpg",@"store_logo_cvs.jpg",@"store_logo_safeway_400.jpeg",@"store_logo_target_296.jpg",@"store_logo_toysrus.png",@"store_logo_walmart_420.gif",@"store_logo_wholefoods.jpg"];
    self.weeklyCount = 1;
    self.offerCount = 1;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIImage* offerImage = [UIImage imageNamed:@"store_logo_amazon.jpg"];
    self.localOfferButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.localOfferButton setImage:offerImage forState:UIControlStateNormal];
    
    UIImage* dealImage = [UIImage imageNamed:@"store_logo_bestbuy.jpg"];
    self.weeklyDealButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.weeklyDealButton setImage: dealImage forState:UIControlStateNormal];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self performSelector:@selector(startChangingButtonImages) withObject:nil afterDelay:2];
}


- (void) startChangingButtonImages{
    if(self.weeklyCount >= self.weeklyDealsFileNames.count){
        self.weeklyCount = 0;
    }
    if(self.offerCount >= self.localOffersFileNames.count){
        self.offerCount = 0;
    }
    UIImage* offerImage = [UIImage imageNamed:self.localOffersFileNames[self.offerCount]];
    self.localOfferButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.localOfferButton setImage:offerImage forState:UIControlStateNormal];
    
    UIImage* dealImage = [UIImage imageNamed:self.weeklyDealsFileNames[self.weeklyCount]];
    self.weeklyDealButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.weeklyDealButton setImage: dealImage forState:UIControlStateNormal];
    self.weeklyCount++;
    self.offerCount++;
    if(self.view.window){
        [self performSelector:@selector(startChangingButtonImages) withObject:nil afterDelay:2];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    FirstTopViewController* ftvc = (FirstTopViewController*) segue.destinationViewController;
    if([segue.identifier isEqualToString:@"localOffers"]){
        ftvc.lsAddition = @"true";
    }else{
        ftvc.lsAddition = @"false";
    }
}

- (IBAction)revealMenu:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)revealUnderRight:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECLeft];
}

-(UIImage*)scaleTheImage:(UIImage*)image
{
    /*
    if(image.size.height<280 && image.size.width<133){
        return image;
    }
    float ratio = image.size.height/image.size.width;
    */
    CGSize size = CGSizeMake(280, 133);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
@end
