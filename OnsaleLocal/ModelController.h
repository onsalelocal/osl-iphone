//
//  ModelController.h
//  Page
//
//  Created by Jon on 6/4/13.
//  Copyright (c) 2013 Jon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

typedef enum {
    DataTypeDeal,
    DataTypeStore,
    DataTypeStoreProfile,
    DataTypeMe
}DataType;

@class DataViewController;

@interface ModelController : NSObject <UIPageViewControllerDataSource>

@property (strong, nonatomic) id info;
@property (strong, nonatomic) RootViewController* parent;
@property (assign, nonatomic) DataType dataType;
@property (strong, nonatomic) NSArray *pageData;




- (id) initWithDataType: (DataType) dataType;
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(UIViewController *)viewController;

@end
