//
//  LeftPanelCell.m
//  homemade
//
//  Created by Sai Luo on 3/18/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "LeftPanelCell.h"
#import <QuartzCore/QuartzCore.h>
#import "EDColor.h"

@implementation LeftPanelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(25.0f, 20.0f, 20.0f, 20.0f)];
        self.icon.alpha = 0.5f;
        self.icon.layer.shadowColor = [UIColor whiteColor].CGColor;
        self.icon.layer.shadowOffset = CGSizeMake(0.0, -1.0);
        [self.contentView addSubview:self.icon];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.icon.layer.shadowOpacity = 0.8f;
    } else {
        self.icon.layer.shadowOpacity = 0.0f;
    }
    // Configure the view for the selected state
}


@end
