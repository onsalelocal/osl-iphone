//
//  PickerViewController.m
//  OnsaleLocal
//
//  Created by Admin on 2/7/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "PickerViewController.h"
#import "AutoScrollLabel.h"

@interface PickerViewController ()

//@property (strong, nonatomic) NSMutableDictionary* checkedItems;

@property (assign, nonatomic) int row;


@end

@implementation PickerViewController

@synthesize delegate = _delegate;
//@synthesize canSelectMultipleItems = _canSelectMultipleItems;
@synthesize items = _items;
//@synthesize checkedItems = _checkedItems;
@synthesize row = _row;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.items = [NSArray arrayWithObject:@"Error, please go back"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //self.checkedItems = [[NSMutableDictionary alloc]init];
    [self.bottomBar setBackgroundImage:[UIImage imageNamed:@"navBarBackground.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerView Delegates

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.items.count;
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%@",self.items[row]];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.row = row;
}

- (IBAction)donePressed:(id)sender {
    [self.delegate passBack:[NSString stringWithFormat:@"%@",self.items[self.row]]];

}

- (IBAction)cancelPressed:(id)sender {
    [self.delegate passBack:self];
}
 

@end
