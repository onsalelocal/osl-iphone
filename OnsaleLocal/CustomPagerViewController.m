//
//  CustomPageViewController.m
//  PageViewController
//
//  Created by Tom Fewster on 11/01/2012.
//

#import "CustomPagerViewController.h"

@interface CustomPagerViewController ()

@end

@implementation CustomPagerViewController

- (void)viewDidLoad
{
	// Do any additional setup after loading the view, typically from a nib.
    [super viewDidLoad];

	[self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"left"]];
	[self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"right"]];
}

@end
