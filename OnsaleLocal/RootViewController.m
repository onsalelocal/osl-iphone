//
//  RootViewController.m
//  Page
//
//  Created by Jon on 6/4/13.
//  Copyright (c) 2013 Jon. All rights reserved.
//

#import "RootViewController.h"
#import "ModelController.h"
#import "DataViewController.h"
#import "SettingsViewController.h"
#import "DownloadObject.h"

@interface RootViewController () <RootDelegate>
//@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
//@property (strong, nonatomic) UIPageControl* pageControl;
@property (strong, nonatomic) NSDictionary* meDictionary;
@end

@implementation RootViewController

@synthesize modelController = _modelController;

- (void)setInfo:(id)info{
    if (info != _info) {
        _info = info;
        self.modelController.info = self.info;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Configure the page view controller and add it as a child view controller.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(meUpdated:) name:DATA_OBJECT_ONE_DONE object:nil];
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
   
    int index = 0;
    if (self.modelController.dataType == DataTypeMe) {
        index = 0;
    }
    UIViewController *startingViewController = [self.modelController viewControllerAtIndex:index storyboard:self.storyboard];
    if([startingViewController respondsToSelector:@selector(rootDelegate)]){
        [startingViewController performSelector:@selector(setRootDelegate:) withObject:self];
    }
    
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];

    self.pageViewController.dataSource = self.modelController;

    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];

    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    CGRect pageViewRect = self.view.bounds;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        //pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0);
        pageViewRect = CGRectInset(pageViewRect, 0.0, 0.0);

    }
    self.pageViewController.view.frame = pageViewRect;

    [self.pageViewController didMoveToParentViewController:self];

    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    //self.pageControl.numberOfPages = self.modelController.pageData.count;
    //self.view insertSubview:self.pageControl.v aboveSubview:<#(UIView *)#>
    
}

-(void) meUpdated:(NSNotification*) notification{
    self.meDictionary = notification.userInfo;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ModelController *)modelController
{
     // Return the model controller object, creating it if necessary.
     // In more complex implementations, the model controller may be passed to the view controller.
    if (!_modelController) {
        DataType d = NULL;
        if([self.restorationIdentifier isEqualToString:@"deal"]) d = DataTypeDeal;
        if([self.restorationIdentifier isEqualToString:@"store"]) d = DataTypeStore;
        if([self.restorationIdentifier isEqualToString:@"storeProfile"]) d = DataTypeStoreProfile;
        if([self.restorationIdentifier isEqualToString:@"me" ])d = DataTypeMe;
        _modelController = [[ModelController alloc] initWithDataType:d];
        _modelController.parent = self;
    }
    return _modelController;
}

#pragma mark - UIPageViewController delegate methods

-(void) pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
    UIViewController* nav = [pageViewController.viewControllers lastObject];
    if([nav isMemberOfClass:([UINavigationController class])]){
        [((UINavigationController*) nav) popToRootViewControllerAnimated:NO];
    }
    //self.pageControl.currentPage = [self.modelController indexOfViewController:nav];
}

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
   return UIPageViewControllerSpineLocationMin;
}

#pragma mark- RootDelegate

- (void) didSelectItem:(id)item andIdentifier:(NSString *)identifier{
    [self.navigationController pushViewController:item animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    SettingsViewController* vc = (SettingsViewController*)segue.destinationViewController;
    vc.infoObject = [self.meDictionary[@"key"] mutableCopy];
}

@end
