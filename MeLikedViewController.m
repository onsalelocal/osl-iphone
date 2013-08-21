//
//  MeLikedViewController.m
//  OnsaleLocal
//
//  Created by Admin on 6/21/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "MeLikedViewController.h"
#import "DealCollectionViewCell.h"
#import "RootViewController.h"
#import "ModelController.h"

@interface MeLikedViewController ()//<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation MeLikedViewController

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
    self.nextQuery = @"http://onsalelocal.com/osl2/ws/user/my-fav-offers?format=json";
    if(self.otherUser){
        self.nextQuery = [NSString stringWithFormat:@"http://onsalelocal.com/osl2/ws/user/offers?format=json&userId=%@",self.otherUser];
    }
    [self refresh:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DealCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StoreDealCell" forIndexPath:indexPath];
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
*/
- (IBAction)sharedPressed:(id)sender {
    RootViewController* root = (RootViewController*)self.parentViewController.parentViewController;
    UIViewController* vc = [root.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
    NSArray* arr = @[vc];
    [root.pageViewController setViewControllers:arr direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

- (IBAction)followingPressed:(id)sender {
    RootViewController* root = (RootViewController*)self.parentViewController.parentViewController;
    UIViewController* vc = [root.modelController viewControllerAtIndex:2 storyboard:self.storyboard];
    NSArray* arr = @[vc];
    [root.pageViewController setViewControllers:arr direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}
@end
