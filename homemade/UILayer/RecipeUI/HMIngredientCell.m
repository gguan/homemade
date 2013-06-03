//
//  HMIngredientCell.m
//  homemade
//
//  Created by Sai Luo on 3/27/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMIngredientCell.h"

@implementation HMIngredientCell
@synthesize nameView = _nameView;
@synthesize quantityView = _quantityView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:193.0/255.0 green:67.0/255.0 blue:29.0/255.0 alpha:1.0];
        self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        self.textLabel.backgroundColor = self.backgroundColor = [UIColor colorWithRed:193.0/255.0 green:67.0/255.0 blue:29.0/255.0 alpha:1.0];
        self.nameView = [[UIView alloc] initWithFrame:CGRectMake(40, 10, 140, 20)];
        self.nameView.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.nameView];
        
        self.quantityView = [[UIView alloc] initWithFrame:CGRectMake(180, 10, 120, 20)];
        self.quantityView.backgroundColor = [UIColor blueColor];
        [self addSubview:self.quantityView];
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
    
    CGRect b = [self bounds];
    b.size.width -= 40;
    b.origin.x = 20;
    [self.textLabel setFrame:b];
}



@end
