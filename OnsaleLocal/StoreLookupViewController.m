//
//  StoreLookupViewController.m
//  OnsaleLocal
//
//  Created by Jon on 7/10/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "StoreLookupViewController.h"
#import "OnsaleLocalConstants.h"
#import "Container.h"



@interface StoreLookupViewController ()

@property (strong, nonatomic) NSMutableArray* autocompleteStores;
@property (strong, nonatomic) NSArray* allStores;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControll;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;


- (IBAction)refreshPressed:(id)sender;
@end

@implementation StoreLookupViewController

- (void) setResultsArrayOfDictionaries:(NSArray *)resultsArrayOfDictionaries{
    [super setResultsArrayOfDictionaries:resultsArrayOfDictionaries];
    NSLog(@"%@", self.resultsArrayOfDictionaries);
    /*
    for(NSDictionary* d in self.resultsArrayOfDictionaries){
        [self.allStores addObject:d];
    }
     */
    self.allStores = [self.resultsArrayOfDictionaries sortedArrayUsingComparator:^NSComparisonResult(NSDictionary* d1, NSDictionary* d2){
        if(![[d1[STORE_LOOKUP_NAME] lowercaseString] isEqualToString:[d2[STORE_LOOKUP_NAME] lowercaseString]]){
            return [d1[STORE_LOOKUP_NAME] caseInsensitiveCompare:d2[STORE_LOOKUP_NAME]];
        }
        return [d1[STORE_ADDRESS] caseInsensitiveCompare:d2[STORE_ADDRESS]];
    }];
    [self.tableView reloadData];
}

- (NSArray*) allStores{
    if (!_allStores){
        _allStores = [NSArray array];
    }
    return _allStores;
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
    self.autocompleteStores = [NSMutableArray array];
    int radius;
    if (self.segmentedControll.selectedSegmentIndex == 0){
        radius = 1;
    }else if(self.segmentedControll.selectedSegmentIndex == 1){
        radius = 2;
    }else{
        radius = 5;
    }
    self.currentQuery = [NSString stringWithFormat:@"http://onsalelocal.com/osl2/ws/v2/nearby-stores?format=json&latitude=%f&longitude=%f&radius=%d", [Container theContainer].location.coordinate.latitude, [Container theContainer].location.coordinate.longitude, radius];
    [self refresh:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *substring = [NSString stringWithString:self.searchBar.text];
    substring = [substring
                 stringByReplacingCharactersInRange:range withString:text];
    [self searchAutocompleteEntriesWithSubstring:substring];
    return YES;
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    // Put anything that starts with this substring into the autocompleteUrls array
    // The items in this array is what will show up in the table view
    [self.autocompleteStores removeAllObjects];
    for(NSDictionary *d in self.allStores) {
        NSString* curString = [d[STORE_LOOKUP_NAME] lowercaseString];
        NSRange substringRange = [curString rangeOfString:[substring lowercaseString]];
        if (substringRange.location == 0) {
            [self.autocompleteStores addObject:d];
        }
    }
    [self.tableView reloadData];
}

- (IBAction)refreshPressed:(id)sender {
    int radius;
    if (self.segmentedControll.selectedSegmentIndex == 0){
        radius = 1;
    }else if(self.segmentedControll.selectedSegmentIndex == 1){
        radius = 2;
    }else{
        radius = 5;
    }
    self.currentQuery = [NSString stringWithFormat:@"http://onsalelocal.com/osl2/ws/v2/nearby-stores?format=json&latitude=%f&longitude=%f&radius=%d", [Container theContainer].location.coordinate.latitude, [Container theContainer].location.coordinate.longitude, radius];
    [self refresh:self];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.searchBar.text.length > 0){
        return self.autocompleteStores.count;
    }
    else return self.allStores.count;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"storeSearchCell" forIndexPath:indexPath];
    NSString* title;
    NSString* description;
    if(self.autocompleteStores.count){
        title = self.autocompleteStores[indexPath.item][STORE_LOOKUP_NAME];
        description = self.autocompleteStores[indexPath.item][STORE_ADDRESS];
    }
    else{
        title = self.allStores[indexPath.item][STORE_LOOKUP_NAME];
        description = self.allStores[indexPath.item][STORE_ADDRESS];
    }
    cell.textLabel.text = title;
    cell.detailTextLabel.text = description;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* d = self.autocompleteStores.count ? self.autocompleteStores[indexPath.item] : self.allStores[indexPath.item];
    [self.passBackDelegate passBack: d];
}
@end
