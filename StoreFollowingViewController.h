//
//  StoreFollowingViewController.h
//  OnsaleLocal
//
//  Created by Jon on 6/5/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultsTableViewController.h"
#import "StoreNearByViewController.h"
@interface StoreFollowingViewController : StoreNearByViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) id dataObject;
@property (strong, nonatomic) id<RootDelegate> rootDelegate;

@end
