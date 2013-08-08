//
//  CollectionButtonViewCell.m
//  OnsaleLocal
//
//  Created by Jon on 6/13/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "CollectionButtonViewCell.h"

@implementation CollectionButtonViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
           }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (UIView*)greyView{
    /*
    if(!_greyView){
        _greyView = [[UIView alloc]initWithFrame:self.frame];
        _greyView.backgroundColor = [UIColor colorWithWhite:.5 alpha:1];
        _greyView.hidden = YES;
        [self addSubview:_greyView];
    }
     */
    return _greyView;
}

- (void) setup{
    

}

@end
