//
//  MeSharedViewController.m
//  OnsaleLocal
//
//  Created by Admin on 6/21/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "MeSharedViewController.h"
#import "DealCollectionViewCell.h"
#import "ModelController.h"
#import "RootViewController.h"


@interface MeSharedViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation MeSharedViewController

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

-(void)viewWillAppear:(BOOL)animated{
    self.nextQuery = @"http://onsalelocal.com/osl2/ws/user/my-offers?format=json";
    if(self.otherUser){
        self.nextQuery = [NSString stringWithFormat:@"http://onsalelocal.com/osl2/ws/user/offers?userId=%@",self.otherUser];
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
    DealCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"meSharedCell" forIndexPath:indexPath];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
*/
- (IBAction)likedPressed:(id)sender {
    RootViewController* root = (RootViewController*)self.parentViewController.parentViewController;
    UIViewController* vc = [root.modelController viewControllerAtIndex:1 storyboard:self.storyboard];
    NSArray* arr = @[vc];
    [root.pageViewController setViewControllers:arr direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}


@end
