//
//  StoreNearByViewController.h
//  OnsaleLocal
//
//  Created by Jon on 6/5/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultsTableViewController.h"
#import <MapKit/MapKit.h>

@interface StoreNearByViewController : ResultsTableViewController //<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) id dataObject;

@end
