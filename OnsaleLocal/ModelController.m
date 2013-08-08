//
//  ModelController.m
//  Page
//
//  Created by Jon on 6/4/13.
//  Copyright (c) 2013 Jon. All rights reserved.
//

#import "ModelController.h"

#import "DataViewController.h"
#import "RootViewController.h"
#define MAX_VIEW_CONTROLLERS 2

/*
#define DYNAMIC_CAST(x, cls)                            \
({                                                      \
cls *inst_ = (cls *)(x);                                \
[inst_ isKindOfClass:[cls class]] ? inst_ : nil;        \
})
*/

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

@interface ModelController()
//@property (strong, nonatomic) Class dataClass;
//@property (assign, nonatomic) NSInteger index;
@end

@implementation ModelController

- (void) setDataType:(DataType)dataType{
    //if(_dataType != dataType){
    _dataType = dataType;
    if(dataType == DataTypeDeal){
        self.pageData = @[@"deal1",@"deal2"];
    }
    else if(dataType == DataTypeStore){
        self.pageData = @[@"store1", @"store2"];
    }
    else if(dataType == DataTypeStoreProfile){
        self.pageData = @[@"storeProfileDeals",@"storeProfileComments"];
    }
    else if(dataType == DataTypeMe){
        self.pageData = @[@"meShared",@"meLiked",@"meFollowing",@"mePeople"];
    }
    //}
}

- (id)init
{
    self = [super init];
    if (self) {
        // Create the data model.
        self.dataType = DataTypeDeal;
        //self.pageData = @[@"deal1",@"deal2"];
        //self.dataClass = [DataViewController class];
    }
    return self;
}

- (id) initWithDataType:(DataType)dataType{
    self = [super init];
    if (self) {
        // Create the data model.
        self.dataType = dataType;
    }
    return self;
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{   
    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= self.pageData.count)) {
        return nil;
    }
    /*
    // Create a new view controller and pass suitable data.
    DataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"DataViewController"];
    dataViewController.dataObject = self.pageData[index];
    return dataViewController;
    */
   
    UIViewController* navdataViewController = [storyboard instantiateViewControllerWithIdentifier:self.pageData[index]];
    id vc = navdataViewController;//.viewControllers[0];
    if([vc respondsToSelector:@selector(rootDelegate)]){
        [vc performSelector:@selector(setRootDelegate:) withObject:self.parent];
    }
    if([vc respondsToSelector:@selector(dataObject)]){
        [vc setDataObject: self.pageData[index]];
    }
    if([vc respondsToSelector:@selector(info)] && self.info){
        [vc setInfo:self.info];
    }
    //((DataViewController* )navdataViewController.viewControllers[0]).dataObject = self.pageData[index];
    return navdataViewController;
   
}

- (NSUInteger)indexOfViewController:(id)viewController
{   
     // Return the index of the given data view controller.
     // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    if([viewController respondsToSelector:@selector(dataObject)]){
        return [self.pageData indexOfObject:[viewController dataObject]];
    }
    return NSNotFound;
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];//((UINavigationController*)viewController).viewControllers[0]];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    //[viewController.navigationController popToRootViewControllerAnimated:NO];
    if([viewController isMemberOfClass:[UINavigationController class]]){
        [((UINavigationController*)viewController) popToRootViewControllerAnimated:NO];
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];//((UINavigationController*)viewController).viewControllers[0]];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == self.pageData.count) {
        index = self.pageData.count - 1;
        return nil;
    }
    //[viewController.navigationController popToRootViewControllerAnimated:NO];
    if([viewController isMemberOfClass:[UINavigationController class]]){
        [((UINavigationController*)viewController) popToRootViewControllerAnimated:NO];
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

@end
