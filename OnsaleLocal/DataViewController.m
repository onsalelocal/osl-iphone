//
//  DataViewController.m
//  Page
//
//  Created by Jon on 6/4/13.
//  Copyright (c) 2013 Jon. All rights reserved.
//

#import "DataViewController.h"
#import "DealCollectionViewCell.h"
#import "Deal.h"
#import "OnsaleLocalConstants.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "DetailViewController.h"
#import "Container.h"
#import "GTMNSString+URLArguments.h"
#import "EGOCache.h"
#import "UICollectionViewWaterfallLayout.h"
#import <ImageIO/ImageIO.h>
#import "SizeObject.h"
#import "NSString+MD5.h"
#import "RootViewController.h"
#import "ModelController.h"
#import "InfiniTabBar.h"
#import "CustomTabBarController.h"

#define CELL_TITLE_LABEL_FONT [UIFont fontWithName:@"Helvetica-Bold" size:14]
#define CELL_DESCRIPTION_LABEL_FONT [UIFont fontWithName:@"Helvetica" size:12]
#define IMAGEVIEW_WIDTH 140.0
#define CELL_MAX_SIZE CGSizeMake(IMAGEVIEW_WIDTH, 9999)
#define LABEL_MAX_SIZE CGSizeMake(IMAGEVIEW_WIDTH-6, 999)


@interface DataViewController ()<UICollectionViewDelegateWaterfallLayout, NSURLConnectionDelegate, NSURLConnectionDataDelegate>

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

@property (strong, nonatomic) NSString* locationString;
@property (strong, nonatomic) NSArray* deals;
@property (strong, nonatomic) NSString* append;
@property (strong, nonatomic) NSMutableDictionary* sizes;
@property (assign, nonatomic) CGFloat cellWidth;
@property (strong, nonatomic) NSArray* cellHeights;
@property (strong, nonatomic) UIRefreshControl* refreshControl;
@property (nonatomic, assign) NSInteger lastContentOffset;
@property (nonatomic, assign) BOOL bottonBarVisible;

@end

@implementation DataViewController



- (void) setResultsArrayOfDictionaries:(NSArray *)resultsArrayOfDictionaries{
    [super setResultsArrayOfDictionaries:resultsArrayOfDictionaries];
    
    //NSLog(@"%@", resultsArrayOfDictionaries);
    self.sizes = [[NSMutableDictionary alloc]initWithCapacity:resultsArrayOfDictionaries.count];
    if(resultsArrayOfDictionaries.count){
        int __block count = 0;
        for(NSDictionary* __strong d in resultsArrayOfDictionaries){
            d = d[@"offer"] ? d[@"offer"] : d;
            if(self.sizes[d[DEAL_ID]] == nil){
                //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                //CGSize imageSize = [self sizeOfImageAtURL:url];
                //CGFloat relativeHeight;
                //CGFloat relativeWidth = IMAGEVIEW_WIDTH;
                //CGFloat ratio = imageSize.width/IMAGEVIEW_WIDTH;
                //if(imageSize.width > IMAGEVIEW_WIDTH){
                //    relativeHeight = imageSize.height/ ratio;
                //}else{
                //    relativeHeight = imageSize.height*ratio;
                //}
                //CGSize newImageSize = CGSizeMake(relativeWidth, relativeHeight);
                //NSString* dealID = d[DEAL_ID];
                //NSLog(@"%@", dealID);
                //NSValue* v = [NSValue valueWithCGSize:newImageSize];
                SizeObject* s = [[SizeObject alloc]init];
                CGSize imageSize = CGSizeZero;
                if([d[DEAL_IMAGE_WIDTH] floatValue]){
                    imageSize = CGSizeMake([d[DEAL_IMAGE_WIDTH] floatValue], [d[DEAL_IMAGE_HEIGHT] floatValue]);
                    NSLog (@"%@", NSStringFromCGSize(imageSize));
                }
                [s setImageSize:imageSize withMaxWidth:IMAGEVIEW_WIDTH];
                NSLog (@"%@", NSStringFromCGSize(s.imageSize));
                s.titleSize = [d[DEAL_TITLE] sizeWithFont:CELL_TITLE_LABEL_FONT constrainedToSize:LABEL_MAX_SIZE lineBreakMode:NSLineBreakByWordWrapping];
                NSString* temp;
                if([d[DEAL_PRICE] floatValue]){
                    temp = [NSString stringWithFormat:@"$%.2f",[d[DEAL_PRICE]floatValue]];
                    NSLog(@"%@", temp);
                    
                }else{
                    NSLog(@"%@",d[DEAL_PRICE]);
                    temp = d[DEAL_PRICE];
                }
                s.descriptionSize = [temp sizeWithFont:CELL_DESCRIPTION_LABEL_FONT constrainedToSize:LABEL_MAX_SIZE lineBreakMode:NSLineBreakByWordWrapping];
                s.storeNameSize = [d[DEAL_STORE] sizeWithFont:CELL_DESCRIPTION_LABEL_FONT constrainedToSize:LABEL_MAX_SIZE lineBreakMode:NSLineBreakByWordWrapping];
                
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.roundingIncrement = [NSNumber numberWithDouble:0.01];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                
                CLLocation* here = [Container theContainer].location;
                CLLocation* there = [[CLLocation alloc]initWithLatitude:[d[DEAL_LAT] floatValue] longitude:[d[DEAL_LONG] floatValue]];
                CGFloat distance = [here distanceFromLocation:there];
                NSString* text = [NSString stringWithFormat: @"%@ Mi",[formatter stringFromNumber:[NSNumber numberWithFloat:distance]]];
                
                s.distanceSize = [text sizeWithFont:CELL_DESCRIPTION_LABEL_FONT constrainedToSize:LABEL_MAX_SIZE lineBreakMode:NSLineBreakByWordWrapping];
                [self.sizes setValue:s forKey:d[DEAL_ID]];
                
                //});
                
            }
            //[self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:count inSection:0]]];
            
            
            count++;
        }
        
        [self.refreshControl endRefreshing];
        [self.refreshControl setAttributedTitle:[[NSAttributedString alloc]initWithString:@"Pull To Update"]];
    }
    [self.collectionView reloadData];
}


- (void) setSearchObject:(SearchObject *)searchObject{
   
    if (_searchObject != searchObject){
        _searchObject = searchObject;
        self.currentQuery = [NSString stringWithFormat:@"http://onsalelocal.com/osl2/ws/v2/search?format=json"];
        self.append = @"";
        if(self.searchObject.keyWords){
            self.append = [self.append stringByAppendingFormat:@"&keywords=%@",self.searchObject.keyWords];
        }
        if(self.searchObject.tagStringsArray.count > 0){
            NSArray* tagArr = self.searchObject.tagStringsArray;
            NSString* addr = tagArr[0];
            for(int i = 1; i < tagArr.count; i++){
                addr = [addr stringByAppendingFormat:@",%@", tagArr[i]];
            }
            self.append = [self.append stringByAppendingFormat:@"&category=%@",addr];
        }
        if(self.searchObject.storeNamesArray.count > 0){
            NSArray* tagArr = self.searchObject.storeNamesArray;
            NSString* addr = tagArr[0];
            for(int i = 1; i < tagArr.count; i++){
                addr = [addr stringByAppendingFormat:@",%@", tagArr[i]];
            }
            self.append = [[self.append stringByAppendingFormat:@"&merchant=%@",addr] gtm_stringByEscapingForURLArgument];
        }
        self.currentQuery = [self.currentQuery stringByAppendingString:self.append];

    }
}

- (void) setDataObject:(id)dataObject{
    if(_dataObject != dataObject){
        _dataObject = dataObject;
        if([dataObject isEqualToString:@"deal2"]){
            self.currentQuery = @"http://onsalelocal.com/osl2/ws/user/my-fav-offers?format=json";
        }
        [self refresh:self];

    }
}

-(void) refresh:(id)sender{
    NSString* fullQuery;
    Container* container = [Container theContainer];
    [self.spinner startAnimating];
    if(container.location){
        NSLog(@"%@",container.location);
        int tempRadius = (container && !container.isUpdating) ? container.radius : 5;
        //if(container && !container.isUpdating){
        if([self.dataObject isEqualToString:@"deal2"]){
            //dont append
        }
        else{
            if(self.nextQuery){
                //fullQuery = [NSString stringWithFormat:@"%@&latitude=%f&longitude=%f&radius=%d",self.nextQuery,container.location.coordinate.latitude,container.location.coordinate.longitude,tempRadius];
                self.currentQuery = self.nextQuery;
                self.nextQuery = nil;
            }else{
                
                if([[self.currentQuery componentsSeparatedByString:@"latitude="] count] == 1){
                    fullQuery = [NSString stringWithFormat:@"%@&latitude=%f&longitude=%f&radius=%d",self.currentQuery,container.location.coordinate.latitude,container.location.coordinate.longitude,tempRadius];
                    self.currentQuery = fullQuery;
                    self.nextQuery = nil;
                }
                 
                
            }
        }
    }
    [super refresh:sender];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bottonBarVisible = YES;
	// Do any additional setup after loading the view, typically from a nib.
    [[EGOCache globalCache]clearCache];
    self.cellWidth = 155;
    Container* container = [Container theContainer];
    self.currentQuery = [NSString stringWithFormat:@"http://onsalelocal.com/osl2/ws/v2/trend?format=json" ];
    //NSString* temp = [NSString stringWithFormat:@"%@&latitude=%f&longitude=%f&radius=%d",self.currentQuery,container.location.coordinate.latitude,container.location.coordinate.longitude,container.radius];
    //self.currentQuery = temp;
    self.dataObject = self.dataObject;//used to refresh query string if needed
    NSLog(@"%@", [Container theContainer].location);
    
    UICollectionViewWaterfallLayout *layout = [[UICollectionViewWaterfallLayout alloc] init];
    
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.delegate = self;
    self.collectionView.collectionViewLayout = layout;
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl setAttributedTitle:[[NSAttributedString alloc]initWithString:@"Pull To Update"]];
    [self.refreshControl addTarget:self action:@selector(refreshControlAction:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    
    /*
    if(self.searchObject){
        self.currentQuery = [NSString stringWithFormat:@"http://onsalelocal.com/osl2/ws/offer/search?format=json"];
        if([Container theContainer].searchObject.keyWords){
            self.currentQuery = [self.currentQuery stringByAppendingFormat:@"&keywords=%@",[Container theContainer].searchObject.keyWords];
        }
        if([Container theContainer].searchObject.tagStringsArray.count > 0){
            NSArray* tagArr = [Container theContainer].searchObject.tagStringsArray;
            NSString* addr = tagArr[0];
            for(int i = 1; i < tagArr.count; i++){
                addr = [addr stringByAppendingFormat:@",%@", tagArr[i]];
            }
            self.currentQuery = [self.currentQuery stringByAppendingFormat:@"&category=%@",addr];
        }
        if([Container theContainer].searchObject.storeNamesArray.count > 0){
            NSArray* tagArr = [Container theContainer].searchObject.storeNamesArray;
            NSString* addr = tagArr[0];
            for(int i = 1; i < tagArr.count; i++){
                addr = [addr stringByAppendingFormat:@",%@", tagArr[i]];
            }
            self.currentQuery = [self.currentQuery stringByAppendingFormat:@"&merchant=%@",addr];
        }
        //radius addition handled elsewhere
    }
     */
}

-(void) refreshControlAction:(UIRefreshControl*)refreshControl{
    [self.refreshControl beginRefreshing];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Updating..."];
    NSLog(@"Refresh Pulled");
    NSString* encodedString = [self.currentQuery md5];
    [[EGOCache globalCache]removeCacheForKey:encodedString];
    [self refresh:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.dataLabel.text = [self.dataObject description];
    //[self.collectionView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self.collectionView selector:@selector(reloadData) name:REFRESH_COLLECTION_VIEW object:nil];
    //[self.view insertSubview:self.collectionView aboveSubview:self.tabBarController.tabBar];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [Container theContainer].searchObject = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self.collectionView];
    if(!self.bottonBarVisible){
        /*
        [UIView animateWithDuration:.4 animations:^{
            CustomTabBarController* ctbc = (CustomTabBarController*)self.tabBarController;;
            UIView* bottonBar = ctbc.infinityTabBar;
            CGRect frame = bottonBar.frame;
            NSLog(@"%f",self.view.frame.size.height);
            frame.origin.y = frame.origin.y - frame.size.height;
            bottonBar.frame = frame;
            
            CGRect frame2 = ctbc.view.frame;
            frame2.size.height -= frame.size.height;
            ctbc.view.frame = frame2;
            
        }];
         */
        [self showTabBar:(CustomTabBarController*)self.tabBarController];
        self.bottonBarVisible = YES;
    }
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"%d",self.resultsArrayOfDictionaries.count);
    return self.resultsArrayOfDictionaries.count;
}

- (void)updateLayout
{
    UICollectionViewWaterfallLayout *layout =
    (UICollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = self.collectionView.bounds.size.width / self.cellWidth;
    layout.itemWidth = self.cellWidth;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    ScrollDirection scrollDirection;
    if (self.lastContentOffset > scrollView.contentOffset.y)
        scrollDirection = ScrollDirectionUp;
    else if (self.lastContentOffset < scrollView.contentOffset.y)
        scrollDirection = ScrollDirectionDown;
    else
        scrollDirection = ScrollDirectionNone;
    
    self.lastContentOffset = scrollView.contentOffset.y;
    
    // do whatever you need to with scrollDirection here.
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    //if (bottomEdge >= scrollView.contentSize.height
    if(scrollDirection == ScrollDirectionDown && self.bottonBarVisible && scrollView.contentOffset.y>0){
        self.tabBarController.view.backgroundColor = [UIColor clearColor];
        [self hideTabBar:(CustomTabBarController *)self.tabBarController];
        self.bottonBarVisible = NO;
    }
    else if (scrollDirection == ScrollDirectionUp && !self.bottonBarVisible && scrollView.contentOffset.y>0 && bottomEdge < scrollView.contentSize.height){
        [self showTabBar:(CustomTabBarController*)self.tabBarController];
        self.bottonBarVisible = YES;
    }
}

- (void)showTabBar:(CustomTabBarController *)tabbarcontroller
{
    tabbarcontroller.tabBar.hidden = NO;
    [UIView animateWithDuration:.4 animations:^{
        for (UIView *view in tabbarcontroller.view.subviews) {
            if ([view isKindOfClass:[UITabBar class]] || [view isKindOfClass:[InfiniTabBar class]]) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-49.f, view.frame.size.width, view.frame.size.height)];
            }
            /*
            else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height-49.f)];
            }
             */
        }
    } completion:^(BOOL finished) {
        //do smth after animation finishes
        for (UIView *view in tabbarcontroller.view.subviews) {
            if (!([view isKindOfClass:[UITabBar class]] || [view isKindOfClass:[InfiniTabBar class]])) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height-49.f)];
            }
        }
        
    }];
}

- (void)hideTabBar:(CustomTabBarController *)tabbarcontroller
{
    [UIView animateWithDuration:.4 animations:^{
        for (UIView *view in tabbarcontroller.view.subviews) {
            if ([view isKindOfClass:[UITabBar class]] || [view isKindOfClass:[InfiniTabBar class]]) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+49.f, view.frame.size.width, view.frame.size.height)];
            }
            else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height+49.f)];
            }
              
        }
    } completion:^(BOOL finished) {
        //do smth after animation finishes
        //tabbarcontroller.tabBar.hidden = YES;
        /*
        for (UIView *view in tabbarcontroller.view.subviews) {
            if (!([view isKindOfClass:[UITabBar class]] || [view isKindOfClass:[InfiniTabBar class]])) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height+49.f)];
            }
        }
         */
    }];
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DealCollectionViewCell* cell = nil;
    /*
    if([self.dataObject isEqualToString:@"deal1"]){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"deal1" forIndexPath:indexPath];
        //cell.pictureImageView.backgroundColor = [UIColor redColor];
    }
    else if([self.dataObject isEqualToString:@"deal2"]){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"deal2" forIndexPath:indexPath];
        //cell.pictureImageView.backgroundColor = [UIColor blueColor];
    }
     */
    NSLog(@"%@", self.dataObject);
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.dataObject forIndexPath:indexPath];
    //if(!cell.dealName){
    cell.dealName = [[UILabel alloc]initWithFrame:CGRectZero];
    cell.dealShortDescription = [[UILabel alloc]initWithFrame:CGRectZero];
    cell.storeName = [[UILabel alloc]initWithFrame:CGRectZero];
    cell.distanceToLocation = [[UILabel alloc]initWithFrame:CGRectZero];
    cell.pictureImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    
    for(UIView* v in cell.contentView.subviews){
        [v removeFromSuperview];
    }

    [cell.contentView addSubview:cell.pictureImageView];
    [cell.contentView addSubview:cell.dealName];
    [cell.contentView addSubview:cell.dealShortDescription];
    [cell.contentView addSubview:cell.storeName];
    [cell.contentView addSubview:cell.distanceToLocation];
    //}
    
    NSDictionary* dealDict = self.resultsArrayOfDictionaries[indexPath.item];
    dealDict = dealDict[@"offer"] ? dealDict[@"offer"] : dealDict;
    NSString* itemID = dealDict[DEAL_ID];
    SizeObject* s = self.sizes[itemID];
    CGSize size = s.imageSize;
    cell.pictureImageView.frame = CGRectMake(0, 0, size.width , size.height);
    //cell.pictureImageView.backgroundColor = [UIColor redColor];
    NSLog(@"%@",NSStringFromCGSize(s.imageSize));
    NSLog(@"%@",NSStringFromCGRect(cell.pictureImageView.frame));
    CGSize titleLabelSize = s.titleSize;
    CGSize descriptionLabelSize = s.descriptionSize;

    
    cell.dealName.frame = CGRectMake(2, size.height , titleLabelSize.width, titleLabelSize.height);
    cell.dealName.backgroundColor = [UIColor clearColor];
    cell.dealName.font = CELL_TITLE_LABEL_FONT;
    cell.dealName.lineBreakMode = NSLineBreakByWordWrapping;
    cell.dealName.numberOfLines = 0;
    cell.dealShortDescription.frame = CGRectMake(2,
                                                 titleLabelSize.height+cell.dealName.frame.origin.y,
                                                 descriptionLabelSize.width,
                                                 descriptionLabelSize.height);
    cell.dealShortDescription.backgroundColor = [UIColor clearColor];
    cell.dealShortDescription.font = CELL_DESCRIPTION_LABEL_FONT;
    cell.dealShortDescription.lineBreakMode = NSLineBreakByWordWrapping;
    cell.dealShortDescription.numberOfLines = 0;
    //cell.dealShortDescription.backgroundColor = [UIColor grayColor];
    
    cell.storeName.frame = CGRectMake(2, CGRectGetMaxY(cell.dealShortDescription.frame),s.storeNameSize.width , s.storeNameSize.height);
    cell.storeName.backgroundColor = [UIColor clearColor];
    cell.storeName.font = CELL_DESCRIPTION_LABEL_FONT;
    cell.storeName.lineBreakMode = NSLineBreakByWordWrapping;
    cell.storeName.numberOfLines = 0;
    //cell.storeName.backgroundColor = [UIColor greenColor];
    
    cell.distanceToLocation.frame = CGRectMake(2, CGRectGetMaxY(cell.storeName.frame), s.distanceSize.width, s.distanceSize.height);
    cell.distanceToLocation.backgroundColor = [UIColor clearColor];
    cell.distanceToLocation.font = CELL_DESCRIPTION_LABEL_FONT;
    cell.distanceToLocation.lineBreakMode = NSLineBreakByWordWrapping;
    //cell.distanceToLocation.backgroundColor = [UIColor redColor];
    Deal* d = [[Deal alloc]initWithContentsOfDictionary:dealDict];
    cell.dealName.text = d.name;
    if([dealDict[DEAL_PRICE] floatValue]){
        NSString* tempString = [NSString stringWithFormat:@"$%.2f",[dealDict[DEAL_PRICE]floatValue]];
        cell.dealShortDescription.text = [NSString stringWithFormat:@"%@",tempString];
        NSLog(@"%@", tempString);
        
    }else{
        NSLog(@"%@",dealDict[DEAL_PRICE]);
        cell.dealShortDescription.text = dealDict[DEAL_PRICE];
    }
    if(d.store){
        cell.storeName.text = d.store;
    }
    if(dealDict[DEAL_LONG] && dealDict[DEAL_LAT]){
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.roundingIncrement = [NSNumber numberWithDouble:0.01];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        
        CLLocation* here = [Container theContainer].location;
        CLLocation* there = [[CLLocation alloc]initWithLatitude:[dealDict[DEAL_LAT] floatValue] longitude:[dealDict[DEAL_LONG] floatValue]];
        CGFloat distance = [here distanceFromLocation:there]*0.000621371;
        NSString* text = [NSString stringWithFormat: @"%@ Mi",[formatter stringFromNumber:[NSNumber numberWithFloat:distance]]];
        cell.distanceToLocation.text = [NSString stringWithFormat: @"%@ Mi",[formatter stringFromNumber:[NSNumber numberWithFloat:distance]]];
    }
    __block NSIndexPath *path = indexPath;
    __weak DealCollectionViewCell *cellCopy = cell;
    //cell.backgroundColor = [UIColor orangeColor];
    
    cell.pictureImageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.pictureImageView setImageWithURL:[NSURL URLWithString: d.imageURL] placeholderImage:[UIImage imageNamed:@"downloading80.jpeg"] completed:^(UIImage* image, NSError* error, SDImageCacheType cacheType){
        
        if([self isBlankImage:image]){
            [cellCopy.pictureImageView setImage:[UIImage imageNamed:@"place_holder_red_tag.jpg"]];
        }else{
            /*
            CGSize imageSize = image.size;
            CGFloat relativeHeight;
            CGFloat relativeWidth = IMAGEVIEW_WIDTH;
            CGFloat ratio = imageSize.width/IMAGEVIEW_WIDTH;
            if(imageSize.width > IMAGEVIEW_WIDTH){
                relativeHeight = imageSize.height/ ratio;
            }else{
                relativeHeight = imageSize.height*ratio;
            }
            CGSize newImageSize = CGSizeMake(relativeWidth, relativeHeight);
            cellCopy.pictureImageView.frame = CGRectMake(cellCopy.pictureImageView.frame.origin.x,
                                                         cellCopy.pictureImageView.frame.origin.y,
                                                         newImageSize.width,
                                                         newImageSize.height);
             */
            //[self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:path]];

        }
        
        
    }];
    NSLog(@"%@",NSStringFromCGRect(cell.frame));
    
    return cell;
    
}
/*
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
*/
-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController* dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"detailVC"];
    //int index = ((NSIndexPath*)[[self.collectionView indexPathsForSelectedItems]lastObject]).row;
    
    //dvc.dealDict = self.resultsArrayOfDictionaries[index];
    NSDictionary* dealDict = self.resultsArrayOfDictionaries[indexPath.item];
    dealDict = dealDict[@"offer"] ? dealDict[@"offer"] : dealDict;
    dvc.offerID = dealDict[DEAL_ID];
    
    [self.rootDelegate didSelectItem:dvc andIdentifier:@"detailVC"];
}
/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //DealCollectionViewCell* cell = (DealCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    NSDictionary* dealDict = self.resultsArrayOfDictionaries[indexPath.row];
    CGSize titleLabelSize = [dealDict[DEAL_TITLE] sizeWithFont:CELL_TITLE_LABEL_FONT constrainedToSize:CELL_MAX_SIZE];
    CGSize descriptionLabelSize = [dealDict[DEAL_DESCRIPTION] sizeWithFont:CELL_DESCRIPTION_LABEL_FONT constrainedToSize:CELL_MAX_SIZE];
    NSValue* sizeValue = self.sizes[dealDict[DEAL_ID]];
    CGFloat imageHeight = sizeValue.CGSizeValue.height;
    
    return CGSizeMake(150, imageHeight + titleLabelSize.height + descriptionLabelSize.height +30);
    
}
 */
/*
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    DetailViewController* dvc = (DetailViewController*)segue.destinationViewController;
    int index = ((NSIndexPath*)[[self.collectionView indexPathsForSelectedItems]lastObject]).row;
    
    //dvc.dealDict = self.resultsArrayOfDictionaries[index];
    dvc.offerID = self.resultsArrayOfDictionaries[index][DEAL_ID];
}
 */

- (BOOL)isBlankImage: (UIImage*) myImage{
    
    //The pixel format depends on what sort of image you're expecting. If it's RGBA, this should work
    typedef struct
    {
        uint8_t red;
        uint8_t green;
        uint8_t blue;
        uint8_t alpha;
    } MyPixel_T;
    
    NSData* pngData = UIImagePNGRepresentation(myImage);
    UIImage* image = [UIImage imageWithData:pngData];
    
    CGImageRef myCGImage = [image CGImage];
    
    //Get a bitmap context for the image
    CGContextRef bitmapContext =
    CGBitmapContextCreate(NULL, CGImageGetWidth(myCGImage), CGImageGetHeight(myCGImage),
                          CGImageGetBitsPerComponent(myCGImage), CGImageGetBytesPerRow(myCGImage),
                          CGImageGetColorSpace(myCGImage), CGImageGetBitmapInfo(myCGImage));
    
    //Draw the image into the context
    CGContextDrawImage(bitmapContext, CGRectMake(0, 0, CGImageGetWidth(myCGImage), CGImageGetHeight(myCGImage)), myCGImage);
    
    //Get pixel data for the image
    MyPixel_T *pixels = CGBitmapContextGetData(bitmapContext);
    size_t pixelCount = CGImageGetWidth(myCGImage) * CGImageGetHeight(myCGImage);
    
    for(size_t i = 0; i < pixelCount; i++)
    {
        MyPixel_T p = pixels[i];
        //Your definition of what's blank may differ from mine
        if(p.red > 0.02 && p.green > 0.02 && p.blue > 0.02 && p.alpha > 0.02)
            return NO;
    }
    
    return YES;
}

- (CGSize)sizeOfImageAtURL:(NSURL *)imageURL
{
    // With CGImageSource we avoid loading the whole image into memory
    CGSize imageSize = CGSizeZero;
    CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)imageURL, NULL);
    if (source) {
        NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCGImageSourceShouldCache];
        CFDictionaryRef properties = ( CFDictionaryRef)CFBridgingRetain((__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(source, 0, (__bridge CFDictionaryRef)options));
        if (properties) {
            NSNumber *width = [(__bridge NSDictionary *)properties objectForKey:(NSString *)kCGImagePropertyPixelWidth];
            NSNumber *height = [(__bridge  NSDictionary *)properties objectForKey:(NSString *)kCGImagePropertyPixelHeight];
            if ((width != nil) && (height != nil))
                imageSize = CGSizeMake(width.floatValue, height.floatValue);
            CFRelease(properties);
        }
        CFRelease(source);
    }
    return imageSize;
}

#pragma mark - UICollectionViewWaterfallLayout Delegate

#pragma mark - UICollectionViewWaterfallLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary* dealDict = self.resultsArrayOfDictionaries[indexPath.item];
    dealDict = dealDict[@"offer"] ? dealDict[@"offer"] : dealDict;

    
    /*
    CGSize titleLabelSize = [dealDict[DEAL_TITLE] sizeWithFont:CELL_TITLE_LABEL_FONT constrainedToSize:CELL_MAX_SIZE];
    CGSize descriptionLabelSize = [dealDict[DEAL_DESCRIPTION] sizeWithFont:CELL_DESCRIPTION_LABEL_FONT constrainedToSize:CELL_MAX_SIZE];
    NSValue* sizeValue = self.sizes[dealDict[DEAL_ID]];
    
    if(self.sizes.count>0){
        //NSLog(@"%@",self.sizes);
    }
    CGFloat imageHeight = sizeValue.CGSizeValue.height;
    if(!imageHeight){
        imageHeight = IMAGEVIEW_WIDTH;
    }
    */
    SizeObject* o = self.sizes[dealDict[DEAL_ID]];
    NSLog(@"%f", [o totalHeightForAllLabels]);
    return [o totalHeightForAllLabels];
}



- (IBAction)followingPressed:(id)sender {
    RootViewController* root = (RootViewController*)self.parentViewController.parentViewController;
    UIViewController* vc = [root.modelController viewControllerAtIndex:1 storyboard:self.storyboard];
    NSArray* arr = @[vc];
    [root.pageViewController setViewControllers:arr direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (IBAction)trendPressed:(id)sender {
    RootViewController* root = (RootViewController*)self.parentViewController.parentViewController;
    UIViewController* vc = [root.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
    NSArray* arr = @[vc];
    [root.pageViewController setViewControllers:arr direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}
@end
