//
//  NSString+SizeWithNewline.h
//  OnsaleLocal
//
//  Created by Admin on 3/3/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SizeWithNewline)

- (CGSize)sizeContainingNewlinesWithFont:(UIFont*)font
                       constrainedToSize:(CGSize)maxSize
                           lineBreakMode:(NSLineBreakMode*)lineBreakMode;

@end
