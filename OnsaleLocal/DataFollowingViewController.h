//
//  DataFollowingViewController.h
//  OnsaleLocal
//
//  Created by Jon on 6/5/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultsTableViewController.h"

@interface DataFollowingViewController : ResultsTableViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) id dataObject;
@property (strong, nonatomic) id<RootDelegate> rootDelegate;
@end
