//
//  SizeObject.h
//  OnsaleLocal
//
//  Created by Jon on 7/9/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SizeObject : NSObject

@property (assign, nonatomic) CGSize titleSize;
@property (assign, nonatomic) CGSize descriptionSize;
@property (assign, nonatomic) CGSize distanceSize;
@property (assign, nonatomic) CGSize storeNameSize;
@property (assign, nonatomic) CGSize imageSize;

- (CGFloat) totalHeightForAllLabels;
-(void)setImageSize:(CGSize)imageSize withMaxWidth:(CGFloat) maxWidth;

@end
