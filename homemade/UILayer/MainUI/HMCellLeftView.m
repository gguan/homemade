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
        
        self.saveButton = [[UIButton alloc] initWithFrame:CGRectMake(21.0, 115.0, 18.0, 18.0)];
        [self.saveButton setBackgroundImage:[UIImage imageNamed:@"addToFavorite.png"] forState:UIControlStateNormal];
        [self.saveButton setBackgroundImage:[UIImage imageNamed:@"addToFavoriteActive.png"] forState:UIControlStateSelected];
        
        self.shareButton = [[UIButton alloc] initWithFrame:CGRectMake(21.0, 155.0, 18.0, 18.0)];
        [self.shareButton setBackgroundImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
        [self.shareButton setBackgroundImage:[UIImage imageNamed:@"shareActive.png"] forState:UIControlStateSelected];
        
        [self addSubview:self.saveButton];
        [self addSubview:self.shareButton];

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

@end
