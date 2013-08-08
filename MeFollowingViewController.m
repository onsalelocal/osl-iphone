//
//  MeFollowingViewController.m
//  OnsaleLocal
//
//  Created by Admin on 6/21/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "MeFollowingViewController.h"
#import "RootViewController.h"
#import "ModelController.h"
#import "StoreImageViewCell.h"
#import "UIImageView+WebCache.h"

@interface MeFollowingViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

- (IBAction)peoplePressed:(id)sender;
@end

@implementation MeFollowingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) setResultsArrayOfDictionaries:(NSArray *)resultsArrayOfDictionaries{
    [super setResultsArrayOfDictionaries:resultsArrayOfDictionaries];
    NSLog(@"%@",self.resultsArrayOfDictionaries);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.nextQuery = @"http://onsalelocal.com/osl2/ws/user/my-fav-stores?format=json";
    [self refresh:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    StoreImageViewCell* cell = (StoreImageViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    NSString* urlString = self.resultsArrayOfDictionaries[indexPath.item][@"smallImg"];
    [cell.imageView setImageWithURL:[NSURL URLWithString:urlString] completed:^(UIImage *image, NSError* error, SDImageCacheType cacheType){
        
    }];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.resultsArrayOfDictionaries.count;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    RootViewController* rvc = [self.storyboard instantiateViewControllerWithIdentifier:@"storeSelected"];
    //NSIndexPath* indexPath = [[self.collectionView indexPathsForSelectedItems]lastObject];
    rvc.info = self.resultsArrayOfDictionaries[indexPath.row];
    NSLog(@"%@",rvc.info);
    rvc.modelController.dataType = DataTypeStoreProfile;
    [self.rootDelegate didSelectItem:rvc andIdentifier:@"storeSelected"];
}

- (IBAction)likePressed:(id)sender {
    RootViewController* root = (RootViewController*)self.parentViewController.parentViewController;
    UIViewController* vc = [root.modelController viewControllerAtIndex:1 storyboard:self.storyboard];
    NSArray* arr = @[vc];
    [root.pageViewController setViewControllers:arr direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}
- (IBAction)peoplePressed:(id)sender {
    RootViewController* root = (RootViewController*)self.parentViewController.parentViewController;
    UIViewController* vc = [root.modelController viewControllerAtIndex:3 storyboard:self.storyboard];
    NSArray* arr = @[vc];
    [root.pageViewController setViewControllers:arr direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}
@end
