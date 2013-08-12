//
//  FirstDetailCell.m
//  OnsaleLocal
//
//  Created by Jon on 6/12/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "FirstDetailCell.h"
#import "OnsaleLocalConstants.h"
#import "SDWebImage/UIImageView+WebCache.h"

#define DEAL_NAME_FONT [UIFont fontWithName:@"Helvetica" size:15]

@interface FirstDetailCell()<NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (strong, nonatomic) UIImageView* dealImageView;
@property (strong, nonatomic) UILabel* dealNameLabel;
@property (strong, nonatomic) UILabel* dealCostLabel;
@property (strong, nonatomic) UILabel* dealDiscountLabel;
@property (strong, nonatomic) UIButton* favButton;
@property (strong, nonatomic) UIButton* commentButton;
@property (strong, nonatomic) UIButton* shareButton;
@property (strong, nonatomic) UIButton* phoneButton;
@property (strong, nonatomic) UIView* greyView;
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData* data;

@end

@implementation FirstDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDictionary: (NSDictionary*) dict
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
                
    }
    return self;
}

-(void) setDealDict:(NSDictionary *)dealDict{
    if(_dealDict != dealDict){
        _dealDict = dealDict;
        CGSize dealNameSize = [dealDict[DEAL_TITLE] sizeWithFont:DEAL_NAME_FONT constrainedToSize:CGSizeMake(300, 999) lineBreakMode:NSLineBreakByWordWrapping];
        self.dealNameLabel = [[UILabel alloc]initWithFrame: CGRectMake(8, 8, dealNameSize.width, dealNameSize.height)];
        self.dealNameLabel.text = dealDict[DEAL_TITLE];
        self.dealNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.dealNameLabel.numberOfLines = 0;
        self.dealNameLabel.backgroundColor = [UIColor clearColor];
        self.dealNameLabel.font = DEAL_NAME_FONT;
        [self addSubview:self.dealNameLabel];
        self.dealImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.dealNameLabel.frame.origin.y+self.dealNameLabel.frame.size.height+8, 300, 300)];
        self.dealImageView.contentMode = UIViewContentModeScaleAspectFit;
        NSString* largeImageURL = dealDict[DEAL_LARGE_IMAGE_URL] ? dealDict[DEAL_LARGE_IMAGE_URL] : dealDict[DEAL_IMAGE_URL];
        [self.dealImageView setImageWithURL:[NSURL URLWithString:largeImageURL] placeholderImage:nil];
        [self addSubview:self.dealImageView];
        
        
        int maxImageViewY = self.dealImageView.frame.size.height + self.dealImageView.frame.origin.y;
        NSString* text = nil;
        if([dealDict[DEAL_PRICE] doubleValue]){
            text = [NSString stringWithFormat:@"$%.2f",[dealDict[DEAL_PRICE] doubleValue]];
        }
        else{
            text = dealDict[DEAL_PRICE];
        }
        CGSize costSize = [text sizeWithFont:DEAL_NAME_FONT constrainedToSize:CGSizeMake(300, 999) lineBreakMode:NSLineBreakByWordWrapping];
        self.dealCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, maxImageViewY + 8, costSize.width, costSize.height)];
        self.dealCostLabel.font = DEAL_NAME_FONT;
        self.dealCostLabel.text = text;
        
        [self addSubview:self.dealCostLabel];
        
        
        
        int maxCostLabelY = self.dealCostLabel.frame.size.height + self.dealCostLabel.frame.origin.y;
        int trueMax = maxImageViewY > maxCostLabelY ? maxImageViewY : maxCostLabelY;
        trueMax +=8;
        
        self.greyView = [[UIView alloc]initWithFrame:CGRectMake(0, trueMax, 320, 57)];
        self.greyView.backgroundColor = [UIColor colorWithWhite:.86 alpha:1];
        
        self.favButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.favButton.frame = CGRectMake(8, 8, 40, 40);
        [self.favButton addTarget:self action:@selector(favButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.favButton setImage:[UIImage imageNamed:@"btn_img_heart_51x42"] forState:UIControlStateNormal];
        [self.greyView addSubview:self.favButton];
        
        self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shareButton.frame = CGRectMake(96, 8, 40, 40);
        [self.shareButton addTarget:self action:@selector(shareButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.shareButton setImage:[UIImage imageNamed:@"btn_img_comment_51x46"] forState:UIControlStateNormal];
        [self.greyView addSubview:self.shareButton];
        
        self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.commentButton.frame = CGRectMake(184, 8, 40, 40);
        [self.commentButton addTarget:self action:@selector(commentButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.commentButton setImage:[UIImage imageNamed:@"btn_img_connect_47x45"] forState:UIControlStateNormal];
        [self.greyView addSubview:self.commentButton];
        
        self.phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.phoneButton.frame = CGRectMake(272, 8, 40, 40);
        [self.phoneButton addTarget:self action:@selector(phoneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.phoneButton setImage:[UIImage imageNamed:@"btn_img_tel_51x50"] forState:UIControlStateNormal];
        [self.greyView addSubview:self.phoneButton];
        
        [self addSubview:self.greyView];
        
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0];

    }
}

-(void)commentButtonPressed{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Not Implemeted Yet"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];

}

-(void)shareButtonPressed{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Not Implemeted Yet"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];

}

-(void)phoneButtonPressed{
    NSLog(@"%@", self.dealDict[DEAL_PHONE]);
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",self.dealDict[DEAL_PHONE]]];
    [[UIApplication sharedApplication] openURL:url];
}

-(void)favButtonPressed{
    NSString* urlString = [NSString stringWithFormat:@"http://onsalelocal.com/osl2/ws/v2/offer/like/%@?format=json",self.dealDict[DEAL_ID]];
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    self.connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%@", error.localizedDescription);
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.data = [[NSMutableData alloc]init];
}
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.data appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString* text = [[NSString alloc]initWithData:self.data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", text);
}

@end
