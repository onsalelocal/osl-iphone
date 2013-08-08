//
//  SubCategoryViewController.m
//  OnsaleLocal
//
//  Created by Admin on 2/12/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//
#import "OnsaleLocalConstants.h"
#import "SubCategoryViewController.h"
#import "FirstTopViewController.h"
#import "GTMNSString+URLArguments.h"
#import "Container.h"
#import "MarqueeLabel.h"
#import "NavigationTopViewController.h"

@interface SubCategoryViewController () <UITableViewDataSource, UITableViewDelegate>
//@property (weak, nonatomic) IBOutlet AutoScrollLabel *autoScrollLabel;

@property (strong, nonatomic)MarqueeLabel* marqueeLabel;
@end

@implementation SubCategoryViewController

@synthesize tableView = _tableView;
@synthesize currentCategory = _currentCategory;
@synthesize currentStore = _currentStore;
@synthesize placeholderView = _placeholderView;
@synthesize marqueeLabel = _marqueeLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)containerFinishedUpdating:(NSNotification*) notification{
    Container* container = [Container theContainer];
    NSLog(@"%@",[NSString stringWithFormat:@"Location: %@, %@ %@; Search Radius: %d miles;", container.cityString, container.stateString, container.countryString, container.radius]);
    //self.autoScrollLabel.textColor = [UIColor blackColor];
    NSString* text = [NSString stringWithFormat:@"Location: %@, %@ %@; Search Radius: %d miles;", container.cityString, container.stateString, container.countryString, container.radius];
    self.marqueeLabel.text = text;
}

- (void) viewDidLoad{
    [super viewDidLoad];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(containerFinishedUpdating:) name:CONTAINER_UPDATED_NOTIFICATION object:nil];
    self.marqueeLabel = [[MarqueeLabel alloc]initWithFrame:CGRectZero duration:8 andFadeLength:10.0f];
    [self.view addSubview:self.marqueeLabel];
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    self.slidingViewController.shouldAddPanGestureRecognizerToTopViewSnapshot = YES;

    
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}
 

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)revealUnderRight:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECLeft];
}


- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGRect frame = self.placeholderView.frame;
    self.marqueeLabel.frame = frame;
    NSLog(@"%f,%f,%f,%f", frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
    self.marqueeLabel.marqueeType = MLContinuous;
    //continuousLabel2.continuousMarqueeSeparator = @"  |SEPARATOR|  ";
    //self.marqueeLabel.animationCurve = UIViewAnimationOptionCurveLinear;
    self.marqueeLabel.numberOfLines = 1;
    self.marqueeLabel.opaque = NO;
    self.marqueeLabel.enabled = YES;
    self.marqueeLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    self.marqueeLabel.textAlignment = NSTextAlignmentLeft;
    self.marqueeLabel.textColor = [UIColor colorWithRed:0.234 green:0.234 blue:0.234 alpha:1.000];
    self.marqueeLabel.backgroundColor = [UIColor clearColor];
    self.marqueeLabel.font = [UIFont fontWithName:@"Helvetica" size:12.000];
    self.marqueeLabel.text = @"Waiting for location to update...";
    Container* container = [Container theContainer];
    if(container && !container.isUpdating){
        
        NSString* marqueeString = [NSString stringWithFormat:@"Location: %@, %@ %@, Search Radius: %d miles", container.cityString, container.stateString, container.countryString, container.radius];
        
        self.marqueeLabel.text = marqueeString;
    }
    [self.marqueeLabel removeFromSuperview];
    [self.view addSubview:self.marqueeLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSLog(@"%@", self.resultsArrayOfDictionaries);
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self.spinner1 stopAnimating];
    static NSString *CellIdentifier = @"subCategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //NSLog(@"%@",[self.categories[indexPath.row]objectForKey:CATEGORY_NAME]);
    cell.textLabel.text = [self.items[indexPath.row]objectForKey:CATEGORY_NAME];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@)",[self.items[indexPath.row] objectForKey:CATEGORY_OFFER_COUNT]];
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isMemberOfClass:[FirstTopViewController class] ]){
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
        FirstTopViewController* ftvc = (FirstTopViewController*)segue.destinationViewController;
        NSString* ls = @"";
        if(self.ls == LS_LOCAL_OFFERS_CATEGORIES){
            ls = @"true";
        }
        else if(self.ls == LS_WEEKLY_DEALS_STORES){
            ls = @"false";
        }
        ftvc.nextQuery = [NSString stringWithFormat:@"http://onsalelocal.com/osl/ws/offer/search?format=json&subcategory=%@",[cell.textLabel.text gtm_stringByEscapingForURLArgument]];
        ftvc.useBackButton = YES;
        if (self.currentStore) {
            ftvc.nextQuery = [ftvc.nextQuery stringByAppendingFormat:@"&merchant=%@&ls=%@",[self.currentStore gtm_stringByEscapingForURLArgument],ls];
        }
        if(self.currentCategory){
            ftvc.nextQuery = [ftvc.nextQuery stringByAppendingFormat:@"&category=%@&ls=%@",[self.currentCategory gtm_stringByEscapingForURLArgument],ls];
        }
    }
}

@end
