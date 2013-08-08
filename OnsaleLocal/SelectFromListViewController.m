//
//  SelectFromListViewController.m
//  OnsaleLocal
//
//  Created by Admin on 2/10/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "SelectFromListViewController.h"
#import "NSArray+Create2DSortedStringArray.h"
#import "AutoScrollLabel.h"


@interface SelectFromListViewController ()

@property (strong, nonatomic) NSArray* items2D;
@property (strong, nonatomic) NSArray* indexTitles;
@property (strong, nonatomic) NSMutableDictionary* selectedItems;

@end

@implementation SelectFromListViewController

@synthesize items = _items;
@synthesize items2D = _items2D;
@synthesize indexTitles = _indexTitles;
@synthesize delegate = _delegate;
@synthesize selectedItems = _selectedItems;
@synthesize tableView = _tableView;


- (IBAction)donePressed:(id)sender {
    NSLog(@"%@",[self.selectedItems allKeys]);
    [self.delegate passBack: [self.selectedItems allKeys]];
    
}

- (void) setItems:(NSArray *)items{
    if (items != _items) {
        _items = items;
        self.items2D = [items create2DSortedStringArray];
        NSMutableArray* tempIndex = [[NSMutableArray alloc] initWithCapacity:self.items2D.count];
        for(NSArray* arr in self.items2D){
            if(arr.count > 0){
                [tempIndex addObject:[[arr[0] substringToIndex:1] uppercaseStringWithLocale:[NSLocale currentLocale]]];
            }
        }
        if([tempIndex count] > 0 && [tempIndex[0]intValue])
            [tempIndex replaceObjectAtIndex:0 withObject:@"#"];
        
        NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ"] ;
        //NSLog(@"%@",tempIndex[1]);
        //NSLog(@"%lu", (unsigned long)[tempIndex[1] rangeOfCharacterFromSet:set].location);
        if ([tempIndex[1] rangeOfCharacterFromSet:set].location == NSNotFound){
            [tempIndex removeObjectAtIndex:1];
            NSMutableArray* items2DMutableCopy = [self.items2D mutableCopy];
            NSArray* firstArr = [self.items2D[0] mutableCopy];
            firstArr = [firstArr arrayByAddingObjectsFromArray:self.items2D[1]];
            [items2DMutableCopy replaceObjectAtIndex:0 withObject:firstArr];
            [items2DMutableCopy removeObjectAtIndex:1];
            self.items2D = items2DMutableCopy;
        }
        self.indexTitles = tempIndex;
    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.bottomBar setBackgroundImage:[UIImage imageNamed:@"navBarBackground.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    self.selectedItems = [[NSMutableDictionary alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.items2D.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.items2D[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"pickFromListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.items2D[indexPath.section][indexPath.row];
    NSString* key = self.items2D[indexPath.section][indexPath.row];
    if([self.selectedItems[key] boolValue] == YES){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString* key = self.items2D[indexPath.section][indexPath.row];
    if([self.selectedItems[key] boolValue] == YES){
        [self.selectedItems removeObjectForKey:key];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else{
        [self.selectedItems setObject:[NSNumber numberWithBool:YES] forKey:key];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    
    
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if(self.items.count<30){
        return nil;
    }
    
    return self.indexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}

@end
