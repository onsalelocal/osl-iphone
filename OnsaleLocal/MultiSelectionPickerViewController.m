//
//  MultiSelectionPickerViewController.m
//  OnsaleLocal
//
//  Created by Admin on 2/8/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "MultiSelectionPickerViewController.h"

@interface MultiSelectionPickerViewController ()

@property (strong, nonatomic) NSMutableDictionary* selectionStates;

@end

@implementation MultiSelectionPickerViewController

@synthesize items = _items;
@synthesize selectionStates = _selectionStates;
@synthesize delegate = _delegate;
@synthesize pickerView = _pickerView;

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
    self.selectionStates = [[NSMutableDictionary alloc] init];
	for (NSString *key in self.items)
		[self.selectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
	
	// Init picker and add it to view
	self.pickerView = [[ALPickerView alloc] initWithFrame:CGRectMake(0, 110, 0, 0)];
	self.pickerView.delegate = self;
	[self.view addSubview:self.pickerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfRowsForPickerView:(ALPickerView *)pickerView {
	return [self.items count];
}

- (NSString *)pickerView:(ALPickerView *)pickerView textForRow:(NSInteger)row {
	return [self.items objectAtIndex:row];
}

- (BOOL)pickerView:(ALPickerView *)pickerView selectionStateForRow:(NSInteger)row {
	return [[self.selectionStates objectForKey:[self.items objectAtIndex:row]] boolValue];
}

- (void)pickerView:(ALPickerView *)pickerView didCheckRow:(NSInteger)row {
	// Check whether all rows are checked or only one
	if (row == -1)
		for (id key in [self.selectionStates allKeys])
			[self.selectionStates setObject:[NSNumber numberWithBool:YES] forKey:key];
	else
		[self.selectionStates setObject:[NSNumber numberWithBool:YES] forKey:[self.items objectAtIndex:row]];
}

- (void)pickerView:(ALPickerView *)pickerView didUncheckRow:(NSInteger)row {
	// Check whether all rows are unchecked or only one
	if (row == -1)
		for (id key in [self.selectionStates allKeys])
			[self.selectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
	else
		[self.selectionStates setObject:[NSNumber numberWithBool:NO] forKey:[self.items objectAtIndex:row]];
}
- (IBAction)donePressed:(id)sender {
    NSMutableArray *tbr = [[NSMutableArray alloc]init];
    for(NSString* key in self.selectionStates.allKeys){
        if([self.selectionStates[key] boolValue] == YES){
            [tbr addObject:[NSString stringWithFormat:@"%@", key]];
        }
    }
    [self.delegate passBack:tbr];
}
- (IBAction)cancelPressed:(id)sender {
    [self.delegate passBack:self];
}

@end
