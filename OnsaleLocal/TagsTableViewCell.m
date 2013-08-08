//
//  TagsTableViewCell.m
//  OnsaleLocal
//
//  Created by Jon on 6/12/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "TagsTableViewCell.h"
#import "OnsaleLocalConstants.h"
#define VIEW_TAG 4321



@interface TagsTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *tagsTitleLabel;
@property (strong, nonatomic) NSArray* colors;
@property (assign, nonatomic) int colorIndex;
@property (strong, nonatomic) NSMutableSet *selectedTags;
@property (weak, nonatomic) IBOutlet UILabel *noTagsLabel;




@end

@implementation TagsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.colorIndex = -1;
        self.colors = @[[UIColor redColor], [UIColor blueColor], [UIColor greenColor], [UIColor purpleColor], [UIColor orangeColor]];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSMutableSet*) selectedTags{
    if(!_selectedTags){
        _selectedTags = [[NSMutableSet alloc]init];
    }
    return _selectedTags;
}
- (void) setTags:(NSArray *)tags{
    if(tags != nil && tags.count > 0)
        self.noTagsLabel.hidden = YES;
    int startX = 8;
    NSLog(@"%@",NSStringFromCGRect(self.tagsTitleLabel.frame));
    int startY = 34;//self.yOffset ? self.yOffset : self.tagsTitleLabel.frame.origin.y + self.tagsTitleLabel.frame.size.height + 8;
    if(tags != _tags){
        if(self.tagLabels){
            for(UILabel* label in self.tagLabels){
                [label removeFromSuperview];
                //label = nil;
            }
            [self.tagLabels removeAllObjects];
            self.tagLabels = nil;
        }
        self.tagLabels = [NSMutableArray arrayWithCapacity:tags.count];
        if(tags.count){
            CGSize size = [tags[0] sizeWithFont:TAG_FONT];
            /*
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(startX, startY, size.width+4, LABEL_HEIGHT)];
            label.font = TAG_FONT;
            label.text = tags[0];
            label.backgroundColor = [self getNextColor];
            [self.tagLabels addObject: label];
             */
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:tags[0] forState:UIControlStateNormal];
            button.titleLabel.font = TAG_FONT;
            button.frame = CGRectMake(startX, startY, size.width+4, LABEL_HEIGHT);
            button.backgroundColor = [self getNextColor];
            [button addTarget:self action:@selector(buttonTagPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.tagLabels addObject: button];
            
        }
        for(int i=1; i <tags.count; i++){
            startX += LABEL_SPACING + ((UILabel*)self.tagLabels[i-1]).frame.size.width;
            CGSize size = [tags[i] sizeWithFont:TAG_FONT];
            if(startX + size.width > self.bounds.size.width - 8){
                startX = 8;
                startY = startY + LABEL_HEIGHT + LABEL_SPACING;
            }
            /*
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(startX, startY, size.width+4, LABEL_HEIGHT)];
            label.font = TAG_FONT;
            label.text = tags[i];
            label.backgroundColor = [self getNextColor];
             */
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:tags[i] forState:UIControlStateNormal];
            button.titleLabel.font = TAG_FONT;
            button.frame = CGRectMake(startX, startY, size.width+4, LABEL_HEIGHT);
            button.backgroundColor = [self getNextColor];
            button.tag = i;
            [button addTarget:self action:@selector(buttonTagPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.tagLabels addObject: button];
            
        }
    }
    for(UIButton* label in self.tagLabels){
        [self.contentView addSubview:label];
    }
}

- (void)buttonTagPressed:(id)sender{
    if(self.canSelectTags){
        UIButton *b;
        if([sender isKindOfClass:[UIButton class]]){
            b = ((UIButton*)sender);
        }
        NSNumber* n = @(b.tag);
        if([self.selectedTags containsObject:n]){
            [self.selectedTags removeObject:n];
            UIView* view = [self viewWithTag:b.tag + VIEW_TAG];
            [view removeFromSuperview];
#warning make this a custom button and set a view over
        }
        else{
            [self.selectedTags addObject:n];
            UIView *view = [[UIView alloc]initWithFrame:b.frame];
            view.userInteractionEnabled = NO;
            view.tag = b.tag + VIEW_TAG;
            view.backgroundColor = [UIColor colorWithWhite:.2 alpha:.5];
            [self addSubview:view];
            
            //[b setHighlighted:YES];
        }
        if([self.delegate respondsToSelector:@selector(tagPressed:)]){
            [self.delegate tagPressed:[self.selectedTags allObjects]];
        }
    }
}

- (NSArray*) colors{
    if(!_colors){
        _colors = @[[UIColor redColor], [UIColor blueColor], [UIColor greenColor], [UIColor purpleColor], [UIColor orangeColor]];
    }
    return _colors;
}

- (UIColor*) getNextColor{
    self.colorIndex++;
    if(self.colorIndex > self.colors.count -1){
        self.colorIndex = 0;
    }
    return self.colors[self.colorIndex];
}



@end
