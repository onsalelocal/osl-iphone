//
//  DetailCell.m
//  OnsaleLocal
//
//  Created by Admin on 2/4/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "DetailCell.h"
#import "OnsaleLocalConstants.h"
#import <MapKit/MapKit.h>
#import "MKMapView+ZoomLevel.h"
#import "UIImage+ImageWithUIView.h"
#import "UIImageView+WebCache.h"
#import "TTTAttributedLabel.h"

#define ZOOM_LEVEL_PAD 7
#define ZOOM_LEVEL_PHONE 7

@interface DetailCell()<TTTAttributedLabelDelegate>

@property (strong, nonatomic) UIImage* mapImage;
@property (strong, nonatomic) NSString* description;

@end

@implementation DetailCell

//@synthesize imageView1 = _imageView1;
@synthesize productName = _productName;
@synthesize cost = _cost;
@synthesize deal = _deal;
@synthesize from = _from;
@synthesize shareButton = _shareButton;
@synthesize bookmarkButton = _bookmarkButton;
@synthesize callButton = _callButton;
@synthesize storeName = _storeName;
@synthesize address = _address;
@synthesize distance = _distance;
@synthesize mapButton = _mapButton;
@synthesize dealDict = _dealDict;
@synthesize mapView = _mapView;
@synthesize mapImage =_mapImage;
@synthesize phone = _phone;
@synthesize detailLabel = _detailLabel;
@synthesize description = _description;
@synthesize isBookmarked = _isBookmarked;

-(void)setLocation:(CLLocation *)location{
    CLLocationDegrees latitude = location.coordinate.latitude;
    CLLocationDegrees longitude = location.coordinate.longitude;
    CLLocationCoordinate2D loc2D = CLLocationCoordinate2DMake(latitude, longitude);
    int zoomLevel = ZOOM_LEVEL_PAD;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        zoomLevel = ZOOM_LEVEL_PHONE;
    }
    
    //NSLog(@"%f, %f",self.mapView.bounds.size.width, self.mapView.bounds.size.height);
    if(![[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        [self.mapView setCenterCoordinate:loc2D zoomLevel:zoomLevel animated:YES];
    }
    self.mapImage = [UIImage imageWithUIView:self.mapView];
    //[self.mapButton setImage:self.mapImage forState:UIControlStateNormal];

    
}

-(void) setDealDict:(NSDictionary *)dealDict{
    if (dealDict != _dealDict) {

        //NSLog(@"%f,%f,%f,%f",self.productName.frame.origin.x,self.productName.frame.origin.y,self.productName.frame.size.width,self.productName.frame.size.height);
        //NSLog(@"%f,%f,%f,%f",self.detailLabel.frame.origin.x,self.detailLabel.frame.origin.y,self.detailLabel.frame.size.width,self.detailLabel.frame.size.height);
        
        _dealDict = dealDict;
        
        //self.productName.text = dealDict[DEAL_TITLE];
        //[self addSubview:self.productName];
        

        
        //////////////
        self.description = @"";
        if(dealDict[DEAL_PRICE]){
            // self.cost.text = [NSString stringWithFormat:@"$%.2f",[(NSNumber*)dealDict[DEAL_PRICE] doubleValue]];
            if([dealDict[DEAL_PRICE] doubleValue]){
                self.description = [self.description stringByAppendingFormat:@"$%.2f ",[(NSNumber*)dealDict[DEAL_PRICE] doubleValue]];
                self.cost.text = [NSString stringWithFormat:@"$%.2f ",[(NSNumber*)dealDict[DEAL_PRICE] doubleValue]];
            }
            else{
                self.description = [self.description stringByAppendingString:dealDict[DEAL_PRICE]];
                self.cost.text = [NSString stringWithFormat:@"%@",dealDict[DEAL_PRICE]];
            }
            //NSLog(@"%@",self.description);

        }
        else{
            self.cost.hidden = YES;
        }
        NSRange range;
        if(dealDict[DEAL_DISCOUNT]){
            //self.deal.text = dealDict[DEAL_DISCOUNT];
            if([dealDict[DEAL_DISCOUNT] floatValue]){
                self.description = [self.description stringByAppendingFormat:@"%@ off",dealDict[DEAL_DISCOUNT]];
                range = [self.description rangeOfString:[NSString stringWithFormat:@"%@ off",dealDict[DEAL_DISCOUNT]]];
                
                self.cost.text = [NSString stringWithFormat:@"%@ off",dealDict[DEAL_DISCOUNT]];
            }
            else if([[dealDict[DEAL_DISCOUNT] substringToIndex:[dealDict[DEAL_DISCOUNT] length]-1]floatValue] &&
                    [[dealDict[DEAL_DISCOUNT] substringFromIndex:[dealDict[DEAL_DISCOUNT] length]-1] isEqualToString:@"%"]){
                NSString *p = @"% off";
                self.description = [self.description stringByAppendingFormat:@"%@%@",dealDict[DEAL_DISCOUNT],p];
                range = [self.description rangeOfString:[NSString stringWithFormat:@"%@%@",dealDict[DEAL_DISCOUNT],p]];
                
                self.cost.text = [NSString stringWithFormat:@"%@%@",dealDict[DEAL_DISCOUNT],p];

            }
            else{
                self.description = [self.description stringByAppendingFormat:@"%@",dealDict[DEAL_DISCOUNT]];
                range = [self.description rangeOfString:[NSString stringWithFormat:@"%@",dealDict[DEAL_DISCOUNT]]];
                
                self.cost.text = [NSString stringWithFormat:@"%@",dealDict[DEAL_DISCOUNT]];
            }
            

        }
        else{
            self.deal.hidden = YES;
        }
        /*
        NSRange rangeOfLink;
        if(dealDict[DEAL_SOURCE]){
           // self.from.text = [NSString stringWithFormat:@"From: %@", dealDict[DEAL_SOURCE] ];
            self.description = [self.description stringByAppendingFormat:@"\nFrom: %@",dealDict[DEAL_SOURCE]];
            rangeOfLink = [self.description rangeOfString:dealDict[DEAL_SOURCE]];
            self.detailLabel.dataDetectorTypes = UIDataDetectorTypeAll;
            //self.detailLabel.delegate = self;
            
            
           
        }
        else{
            self.from.hidden = YES;
        }
         */
        self.address = [[UILabel alloc]initWithFrame:CGRectZero];
        self.address.text = [NSString stringWithFormat:@"%@\n%@, %@", dealDict[DEAL_ADDRESS], dealDict[DEAL_CITY], dealDict[DEAL_STATE]];
        self.storeName = [[UILabel alloc]initWithFrame:CGRectZero];
        self.storeName.text = dealDict[DEAL_STORE];
        self.distance = [[UILabel alloc]initWithFrame:CGRectZero];
        self.distance.text = [NSString stringWithFormat:@"%.2f Miles", [(NSNumber*)dealDict[DEAL_DISTANCE] doubleValue]];
        self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0,0, 105, 105)];
        CLLocation *dealLocation = [[CLLocation alloc]initWithLatitude:[(NSNumber*)dealDict[DEAL_LAT] doubleValue] longitude:[(NSNumber*)dealDict[DEAL_LONG] doubleValue]];
        [self setLocation:dealLocation];
        UIImageView* __block wImageView = self.imageView;
        [self.imageView setImageWithURL:[NSURL URLWithString: self.dealDict[DEAL_IMAGE_URL] ]placeholderImage:[UIImage imageNamed:@"downloading90.jpeg"]completed:^(UIImage* image, NSError* error, SDImageCacheType cacheType){
            if (image == nil) {
                [wImageView setImage:[UIImage imageNamed:@"place_holder_red_tag80.jpg"]];
            }
        }];
        if(dealDict[DEAL_PHONE]){
            self.phone.hidden = NO;
            NSString *phone = [NSString stringWithFormat:@"%@", dealDict[DEAL_PHONE]];
            if ([[phone substringToIndex:1] isEqualToString:@"1"]) {
                phone = [phone substringFromIndex:1];
            }
            phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
            phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
            phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
            phone = [phone stringByReplacingOccurrencesOfString:@"." withString:@""];
            NSRange mid = NSMakeRange(3, 3);
            self.phone = [[UILabel alloc]initWithFrame:CGRectZero];
            self.phone.text = [NSString stringWithFormat:@"(%@) %@-%@",[phone substringToIndex:3],[phone substringWithRange:mid],[phone substringFromIndex:6]];
        }
        else{
            self.phone.hidden = YES;
        }
        self.productName = [[UILabel alloc]initWithFrame: CGRectMake(117, 9, 189, 55)];
        self.productName.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        self.productName.lineBreakMode = NSLineBreakByWordWrapping;
        self.productName.numberOfLines = 0;
        self.productName.minimumScaleFactor = .7;
        self.productName.text = self.dealDict[DEAL_TITLE];
        //[self addSubview:self.productName];
        CGSize maximumLabelSize = CGSizeMake(189, FLT_MAX);
        CGSize expectedLabelSize = [self.productName.text sizeWithFont:self.productName.font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping ];

        //////////////////////
        //adjust the label the the new height.
        CGRect newFrame = self.productName.frame;
        newFrame.size.height = expectedLabelSize.height;
        //newFrame.size.height += 10;
        self.productName.frame = newFrame;
        [self.contentView addSubview:self.productName];
        //////////////
        
        CGRect pnFrame = self.productName.frame;
        self.detailLabel =[[TTTAttributedLabel alloc]initWithFrame: CGRectMake(pnFrame.origin.x, pnFrame.size.height+10, pnFrame.size.width, 55)];
        self.detailLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
        self.detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.detailLabel.numberOfLines = 0;
        
        maximumLabelSize = CGSizeMake(189, FLT_MAX);
        expectedLabelSize = [self.description sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping ];

        newFrame = self.detailLabel.frame;
        newFrame.size.height = expectedLabelSize.height;
        
        self.detailLabel.frame = newFrame;
        [self.detailLabel setText:self.description afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString* (NSMutableAttributedString *mutableAttributedString){
            if(dealDict[DEAL_DISCOUNT] && range.location != NSNotFound){
                //NSLog(@"%d",range.length);
                [mutableAttributedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:range];
                [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor redColor] CGColor] range:range];
            }
            
            
            
            return mutableAttributedString;
        }];/*
        if(dealDict[DEAL_SOURCE] && rangeOfLink.location != NSNotFound){
            [self.detailLabel addLinkToURL:[NSURL URLWithString:dealDict[DEAL_FROM_URL]] withRange:rangeOfLink];
        }*/
        
        //[self.contentView addSubview:self.detailLabel];
        
        //self.mapButton = [[UIButton alloc]initWithFrame:CGRectZero];
        
        /*
        if(self.detailLabel.frame.origin.y + self.detailLabel.frame.size.height > self.storeName.frame.origin.y - 6){
            CGRect frame = self.storeName.frame;
            frame.origin.y = self.detailLabel.frame.origin.y + self.detailLabel.frame.size.height;
            self.storeName.frame = frame;
            //[self updateConstraintsIfNeeded];
        }
         */
        //[self resizeHeights];
        [self setupCell];
        
    }
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(9,9,100,100);
    if((self.detailLabel.frame.origin.y + self.detailLabel.frame.size.height)/2 > self.imageView.center.y){
        CGPoint center = CGPointMake(self.imageView.center.x, (self.detailLabel.frame.origin.y + self.detailLabel.frame.size.height)/2);
        self.imageView.center = center;
        
    }
    float limgW =  self.imageView.image.size.width;
    if(limgW > 0) {
        self.textLabel.frame = CGRectMake(55,self.textLabel.frame.origin.y,self.textLabel.frame.size.width,self.textLabel.frame.size.height);
        self.detailTextLabel.frame = CGRectMake(55,self.detailTextLabel.frame.origin.y,self.detailTextLabel.frame.size.width,self.detailTextLabel.frame.size.height);
    }
    if(!self.dealDict[DEAL_PHONE]){
        self.callButton.hidden = YES;
    }

}

- (void) setupCell{
    //storeName
    self.imageView.frame = CGRectMake(9,9,100,100);
    float imageViewMax = self.imageView.frame.origin.y + self.imageView.frame.size.height+4;
    //NSLog(@"%@",NSStringFromCGRect(self.imageView.frame));
    float tttLabelMax = self.detailLabel.frame.origin.y + self.detailLabel.frame.size.height+4;
    float picPointOrTTTLabelPoint = imageViewMax > tttLabelMax ? imageViewMax : tttLabelMax;
    CGRect storeframe = CGRectMake(9, picPointOrTTTLabelPoint + 6, 280, 40);
    self.storeName.frame = storeframe;
    self.storeName.font = [UIFont fontWithName:@"Helvetica-Bold" size:19];
    self.storeName.lineBreakMode = NSLineBreakByWordWrapping;
    self.storeName.numberOfLines = 0;
    //self.storeName.backgroundColor = [UIColor redColor];
    CGSize maximumLabelSize = CGSizeMake(280, FLT_MAX);
    CGSize expectedLabelSize = [self.storeName.text sizeWithFont:self.storeName.font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping ];
    CGRect newFrame = self.storeName.frame;
    newFrame.size.height = expectedLabelSize.height;
    self.storeName.frame = newFrame;    
    [self.contentView addSubview:self.storeName];
    
    //mapButton
    CGRect mapFrame = CGRectMake(201, newFrame.origin.y + newFrame.size.height +4, 116, 116);
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = mapFrame;
    [btn setImage:[UIImage imageNamed:@"map_image.jpeg"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(mapPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.mapButton = btn;
    [self.contentView addSubview:self.mapButton];
    //phoneLabel
    CGRect phoneFrame = CGRectMake(9, storeframe.origin.y + storeframe.size.height + 10, 190, 16);
    self.phone.frame = phoneFrame;
    self.phone.font = [UIFont fontWithName:@"Helvetica" size:15];
    self.phone.numberOfLines = 1;

    [self.contentView addSubview:self.phone];
    //addressLabel
    CGRect addressFrame = CGRectMake(9, phoneFrame.origin.y + phoneFrame.size.height +1, 190, 40);
    self.address.frame = addressFrame;
    self.address.font = [UIFont fontWithName:@"Helvetica" size:15];
    self.address.numberOfLines = 2;
    [self.contentView addSubview:self.address];
    //distance
    CGRect distanceFrame = CGRectMake(9, addressFrame.origin.y + addressFrame.size.height +1, 190, 16);
    self.distance.frame = distanceFrame;
    self.distance.font = [UIFont fontWithName:@"Helvetica" size:15];
    self.distance.numberOfLines = 1;
    [self.contentView addSubview:self.distance];
    
    CGFloat buttonY = (distanceFrame.origin.y + distanceFrame.size.height +30);
    CGFloat mapY = mapFrame.origin.y + mapFrame.size.height +10;
    CGFloat maxY =  buttonY > mapY ? buttonY : mapY;
    //shareButton
    CGRect shareFrame = CGRectMake(18, maxY, 44, 44);
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareButton setImage:[UIImage imageNamed:@"Share1.png"] forState:UIControlStateNormal];
    self.shareButton.frame = shareFrame;
    //[self.shareButton setTitle:@"Share" forState:UIControlStateNormal];
    [self.shareButton addTarget:self action:@selector(sharePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.shareButton];
    //bookmarkButton
    CGRect bookmarkFrame = CGRectMake(113, maxY, 44, 44);
    self.bookmarkButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    NSString* file = self.isBookmarked ?  @"heart_delete_32.png" : @"heart_add_32.png" ;
    [self.bookmarkButton setImage:[UIImage imageNamed:file] forState:UIControlStateNormal];
    self.bookmarkButton.frame = bookmarkFrame;
    //[self.bookmarkButton setTitle:@"Bookmark" forState:UIControlStateNormal];
    [self.bookmarkButton addTarget:self action:@selector(bookMarkPressed:) forControlEvents:UIControlEventTouchUpInside];

    [self.contentView addSubview:self.bookmarkButton];
    //phoneButton
    CGRect callButtonFrame = CGRectMake(219, mapY, 44, 44);
    self.callButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.callButton setImage:[UIImage imageNamed:@"phoneIcon1.jpeg"] forState:UIControlStateNormal];
    //self.callButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.callButton.frame = callButtonFrame;
    //[self.callButton setTitle:@"Call" forState:UIControlStateNormal];
    [self.callButton addTarget:self action:@selector(callPressed:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:self.callButton];
    
    CGPoint center = self.center;
    CGPoint bookmarkButtonCenter = self.bookmarkButton.center;
    bookmarkButtonCenter.x = center.x;
    self.bookmarkButton.center = bookmarkButtonCenter;
    
    CGPoint shareButtonCenter = self.shareButton.center;
    shareButtonCenter.x = center.x/2;
    self.shareButton.center = shareButtonCenter;
    
    CGPoint callButtonCenter = self.callButton.center;
    callButtonCenter.x = center.x*3/2;
    self.callButton.center = callButtonCenter ;
    
}

- (void) mapPressed:(id) sender{
    [self.delegate mapButtonPressed];
}

- (void) sharePressed: (id) sender{
    [self.delegate sharePressed];
}

- (void) callPressed: (id) sender{
    [self.delegate callPressed];
}

- (void) bookMarkPressed: (id) sender{
    [self.delegate bookMarkPressed];
}

@end
