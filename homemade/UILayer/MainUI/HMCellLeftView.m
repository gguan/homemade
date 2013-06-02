//
//  HMCellLeftView.m
//  homemade
//
//  Created by Guan Guan on 4/25/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMCellLeftView.h"

@implementation HMCellLeftView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor darkGrayColor]];
        
        self.saveButton = [[UIButton alloc] initWithFrame:CGRectMake(21.0, 75.0, 18.0, 18.0)];
        [self.saveButton setBackgroundImage:[UIImage imageNamed:@"addToFavorite.png"] forState:UIControlStateNormal];
        [self.saveButton setBackgroundImage:[UIImage imageNamed:@"addToFavoriteActive.png"] forState:UIControlStateSelected];
        
        self.commentButton = [[UIButton alloc] initWithFrame:CGRectMake(21.0, 115.0, 18.0, 18.0)];
        [self.commentButton setBackgroundImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];
        [self.commentButton setBackgroundImage:[UIImage imageNamed:@"commentActive.png"] forState:UIControlStateSelected];
        
        self.shareButton = [[UIButton alloc] initWithFrame:CGRectMake(21.0, 155.0, 18.0, 18.0)];
        [self.shareButton setBackgroundImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
        [self.shareButton setBackgroundImage:[UIImage imageNamed:@"shareActive.png"] forState:UIControlStateSelected];
        
        [self addSubview:self.saveButton];
        [self addSubview:self.commentButton];
        [self addSubview:self.shareButton];
        
        
        self.avatarImageView = [[HMProfileImageView alloc] init];
        self.avatarImageView.frame = CGRectMake( 10.0f, 10.0f, 40.0f, 40.0f);
        [self.avatarImageView.profileButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.avatarImageView];
        
        self.timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake( 50.0f, 24.0f, self.bounds.size.width - 50.0f - 72.0f, 18.0f)];
        [self addSubview:self.timestampLabel];
        [self.timestampLabel setTextColor:[UIColor colorWithRed:124.0f/255.0f green:124.0f/255.0f blue:124.0f/255.0f alpha:1.0f]];
        [self.timestampLabel setShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f]];
        [self.timestampLabel setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
        [self.timestampLabel setFont:[UIFont systemFontOfSize:11.0f]];
        [self.timestampLabel setBackgroundColor:[UIColor clearColor]];


    }
    return self;
}

@end
