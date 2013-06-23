//
//  HMUserRecipeCell.m
//  homemade
//
//  Created by Guan Guan on 6/21/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMUserRecipeCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation HMUserRecipeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 400.0f)];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        
        // user avatar
        self.avatar = [[PFImageView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 30.0f, 30.0f)];
        self.avatar.layer.cornerRadius = 15.0f;
        self.avatar.layer.masksToBounds = YES;
        [self addSubview:self.avatar];
        
        // summery label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, 5.0f, 180, 30.0f)];
        [label setText:@"Post a new drink"];
        [label setFont:[UIFont systemFontOfSize:12.0f]];
        [label setTextColor:[UIColor lightGrayColor]];
        [self addSubview:label];
        
        // add timestamp label
        self.timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake( self.bounds.size.width - 75.0f, 5.0f, 75.0f, 30.0f)];
        [self.timestampLabel setTextColor:[UIColor colorWithRed:124.0f/255.0f green:124.0f/255.0f blue:124.0f/255.0f alpha:1.0f]];
        [self.timestampLabel setShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f]];
        [self.timestampLabel setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
        [self.timestampLabel setFont:[UIFont systemFontOfSize:11.0f]];
        [self.timestampLabel setTextColor:[UIColor lightGrayColor]];
        [self.timestampLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.timestampLabel];
        
        // add photo imageview
        self.photo = [[PFImageView alloc] initWithFrame:CGRectMake(5.0f, 40.0f, 310.0f, 310.0f)];
        self.photo.layer.cornerRadius = 5.0f;
        self.photo.layer.masksToBounds = YES;
        [self addSubview:self.photo];
        
        // add note label
        self.noteLabel = [[UILabel alloc] initWithFrame:CGRectMake( 5.0f, 355.0f, 310.0f, 30.0f)];
        self.noteLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.noteLabel.numberOfLines = 2;
        self.noteLabel.textColor = [UIColor grayColor];
        self.noteLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:self.noteLabel];
        
        UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(5, 394, 310, 1)];
        [bottomBorder setBackgroundColor:[UIColor colorWithRed:124.0f/255.0f green:124.0f/255.0f blue:124.0f/255.0f alpha:0.2f]];
        [self addSubview:bottomBorder];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
