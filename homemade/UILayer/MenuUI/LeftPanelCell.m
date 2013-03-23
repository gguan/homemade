//
//  LeftPanelCell.m
//  homemade
//
//  Created by Sai Luo on 3/18/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "LeftPanelCell.h"

@implementation LeftPanelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
//        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.shadowColor = [UIColor whiteColor];
        self.textLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        [self.textLabel setBackgroundColor:[UIColor colorWithRed:59.0/255.0 green:57.0/255.0 blue:59.0/255.0 alpha:1.0]];
        
        [self.contentView setBackgroundColor:[UIColor colorWithRed:59.0/255.0 green:57.0/255.0 blue:59.0/255.0 alpha:1.0]];
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        UIView *arrowView = [[UIView alloc] initWithFrame:CGRectMake(230, 10 , 24, 23)];
        arrowView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"arrow_right.png"]];
        [self.contentView addSubview:arrowView];


    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
