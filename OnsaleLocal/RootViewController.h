//
//  RootViewController.h
//  Page
//
//  Created by Jon on 6/4/13.
//  Copyright (c) 2013 Jon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ModelController;


@interface RootViewController : UIViewController <UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) id info;
@property (readonly, strong, nonatomic) ModelController *modelController;

//@property (strong, nonatomic) id<RootDelegate> delgate;

@end
