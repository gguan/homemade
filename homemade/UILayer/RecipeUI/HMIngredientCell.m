//
//  HMIngredientCell.m
//  homemade
//
//  Created by Sai Luo on 3/27/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMIngredientCell.h"

@implementation HMIngredientCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
        [self.textLabel setTextColor:[UIColor grayColor]];
        [self.textLabel setBackgroundColor:[UIColor clearColor]];
        [self.textLabel setAdjustsFontSizeToFitWidth:YES];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.textLabel setFrame:CGRectMake(10, 0, 300, 20)];
}



@end
