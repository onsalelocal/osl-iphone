//
//  SizeObject.m
//  OnsaleLocal
//
//  Created by Jon on 7/9/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "SizeObject.h"

@implementation SizeObject

- (CGSize) imageSize{
    if(_imageSize.height == 0 && _imageSize.width == 0){
        _imageSize = CGSizeMake(140, 140);
    }
    return _imageSize;
}

- (CGFloat) totalHeightForAllLabels{
    return  self.imageSize.height +
            _titleSize.height +
            _descriptionSize.height +
            _distanceSize.height +
            _storeNameSize.height;
}

@end
