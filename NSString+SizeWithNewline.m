//
//  NSString+SizeWithNewline.m
//  OnsaleLocal
//
//  Created by Admin on 3/3/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "NSString+SizeWithNewline.h"

@implementation NSString (SizeWithNewline)

- (CGSize)sizeContainingNewlinesWithFont:(UIFont*)font
                       constrainedToSize:(CGSize)maxSize
                           lineBreakMode:(NSLineBreakMode*)lineBreakMode{
    NSArray *substrings = [self componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSLog(@"%@",substrings);
    if(substrings.count == 0) return CGSizeZero;
    if(substrings.count == 1) return [self sizeWithFont:font constrainedToSize:maxSize lineBreakMode: lineBreakMode];
    NSMutableArray *sizes = [[NSMutableArray alloc]initWithCapacity:substrings.count];
    int counter = 0;
    for(NSString* substring in substrings){
        CGSize newSize = [substring sizeWithFont:font constrainedToSize:maxSize lineBreakMode:lineBreakMode];
        NSLog(@"%d : %@",counter,NSStringFromCGSize(newSize));
        NSValue* sizeValue = [NSValue valueWithCGSize:newSize];
        [sizes addObject:sizeValue];
        counter++;
    }
    CGFloat maxHeight = maxSize.height;
    CGFloat currentWidth = 0.0f;
    CGFloat currentHight = 0.0f;
    
    //go throught the sizes array and add the heights
    //go throught the sizes array and find (not add) the largest width
    
    for(NSValue* sizeVale in sizes){
        CGSize size = [sizeVale CGSizeValue];
        currentHight += size.height;
        if(currentWidth < size.width){
            currentWidth = size.width;
        }
        
    }
    CGFloat newMaxHeight = currentHight < maxHeight ? currentHight :maxHeight;
    CGSize tbr = CGSizeMake(currentWidth, newMaxHeight+2);
    NSLog(@"%@",NSStringFromCGSize(maxSize));
    NSLog(@"%@",NSStringFromCGSize([self sizeWithFont:font constrainedToSize:maxSize lineBreakMode:lineBreakMode]));
    NSLog(@"%@",NSStringFromCGSize(tbr));
    return tbr;
}

@end
