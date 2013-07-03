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
        [self.contentView setBackgroundColor:[UIColor colorWithRed:246.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:1.0f]];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 250, 20)];
        
        [self.nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
        [self.nameLabel setTextColor:[UIColor colorWithRed:63.0f/255.0f green:72.0f/255.0f blue:75.0f/255.0f alpha:1.0f]];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.nameLabel setAdjustsFontSizeToFitWidth:YES];
        [self.contentView addSubview:self.nameLabel];
        
        self.quantityLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 25, 250, 15)];
        
        [self.quantityLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
        [self.quantityLabel setTextColor:[UIColor colorWithRed:174.0f/255.0f green:177.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
        [self.quantityLabel setBackgroundColor:[UIColor clearColor]];
        [self.quantityLabel setAdjustsFontSizeToFitWidth:YES];
        [self.contentView addSubview:self.quantityLabel];

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
}



@end
