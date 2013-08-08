//
//  NewSearchViewController.m
//  OnsaleLocal
//
//  Created by Jon on 6/13/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "NewSearchViewController.h"
#import "NewSearchTagsCell.h"
#import "CollectionInTableViewCell.h"
#import "CollectionButtonViewCell.h"
#import "UIImageView+WebCache.h"
#import "Container.h"
#import "SearchObject.h"
#import "DataViewController.h"
#import "DetailViewController.h"
#import "OnsaleLocalConstants.h"
#define COLLECTION_CELL_HEIGHT 64
#define COLLECTION_CELL_SPACING 8
//#define STORE_IMAGE_URL @"url"
#define TAGS_URL @""

@interface NewSearchViewController ()<TagCellProtocal, UISearchBarDelegate>

@property (strong, nonatomic) NSArray* tags;
@property (strong, nonatomic) NSArray* stores;
@property (strong, nonatomic) NSURLConnection* tagsConnection;
@property (strong, nonatomic) NSURLConnection* storesConnection;
@property (strong, nonatomic) NSMutableOrderedSet* selectedStores;
@property (strong, nonatomic) NSArray* selectedTagNumbers;
@property (strong, nonatomic) NSMutableData* tagsData;
@property (strong, nonatomic) NSMutableData* storesData;
@property (strong, nonatomic) UICollectionView* collectionView;
@property (strong, nonatomic) NSArray* radiusArray;

- (IBAction)searchPressed:(id)sender;

@end

@implementation NewSearchViewController

- (NSMutableOrderedSet*) selectedStores{
    if(!_selectedStores){
        _selectedStores = [[NSMutableOrderedSet alloc]init];
    }
    return _selectedStores;
}

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
#warning change radius
    self.currentQuery = @"";
    self.dataObject = @"search";
    self.radiusArray = @[@1,@5,@10,@20];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView
/*
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([sender isKindOfClass:[UIBarButtonItem class]]){
        SearchObject* searchObject = [[SearchObject alloc]init];
        NSMutableArray* mArray = [[NSMutableArray alloc]initWithCapacity:self.selectedTagNumbers.count];
        for(NSNumber* number in self.selectedTagNumbers ){
            [mArray addObject:self.tags[[number intValue]]];
        }
        searchObject.tagStringsArray = self.selectedTagNumbers;
        NSMutableArray* storeTempArray = [NSMutableArray array];
        for(NSNumber* num in self.selectedStores){
            [storeTempArray addObject:self.stores[[num intValue] ][@"name"]];
        }
        searchObject.storeNamesArray = [storeTempArray copy];
        searchObject.keyWords = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@","];
        searchObject.radius = [self.radiusArray[self.searchBar.selectedScopeButtonIndex] intValue];
        DataViewController* dvc = (DataViewController*) segue.destinationViewController;
        dvc.searchObject = searchObject;
        
        [Container theContainer].searchObject = searchObject;
    }
}
*/
- (void) tagPressed:(NSArray *)selectedItems{
    
}

- (IBAction)searchPressed:(id)sender {
    [self.searchBar resignFirstResponder];
    SearchObject* searchObject = [[SearchObject alloc]init];
    //searchObject.storeNamesArray = [storeTempArray copy];
    searchObject.keyWords = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@","];
    searchObject.radius = [self.radiusArray[self.searchBar.selectedScopeButtonIndex] intValue];
    self.searchObject = searchObject;
    [self refresh:self];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchPressed:nil];
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController* dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"detailVC"];
    //int index = ((NSIndexPath*)[[self.collectionView indexPathsForSelectedItems]lastObject]).row;
    
    //dvc.dealDict = self.resultsArrayOfDictionaries[index];
    NSDictionary* dealDict = self.resultsArrayOfDictionaries[indexPath.item];
    dealDict = dealDict[@"offer"] ? dealDict[@"offer"] : dealDict;
    dvc.offerID = dealDict[DEAL_ID];
    
    [self.navigationController pushViewController:dvc animated:YES];
}
@end
