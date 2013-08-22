//
//  DataViewController.h
//  Page
//
//  Created by Jon on 6/4/13.
//  Copyright (c) 2013 Jon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultsTableViewController.h"
@class  SearchObject;

@interface DataViewController : ResultsTableViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

//@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) id dataObject;
@property (strong, nonatomic) NSString* nextQuery;
@property (assign, nonatomic) BOOL useBackButton;
//@property (weak, nonatomic) IBOutlet AutoScrollLabel *autoScrollLabel;
@property (strong, nonatomic) NSString* lsAddition;
@property (strong, nonatomic) SearchObject* searchObject;



@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)followingPressed:(id)sender;
- (IBAction)trendPressed:(id)sender;
@end
