//
//  HMDrinkPhotoViewCell.m
//  homemade
//
//  Created by Guan Guan on 7/4/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMDrinkPhotoViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation HMDrinkPhotoViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.photoView = [[PFImageView alloc] initWithFrame:CGRectMake(10, 10, 140, 140)];
        self.photoView.contentMode = UIViewContentModeScaleAspectFill;
        self.photoView.clipsToBounds = YES;
        
        self.label = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(10, 155, 140, 40)];
        self.label.opaque = NO;
        self.label.backgroundColor = [UIColor clearColor];
        self.label.numberOfLines = 2;
        
        self.label.font = [UIFont fontWithName:@"Helvetica-Oblique" size:11];
        self.label.textColor = [UIColor colorWithRed:69.0f/255.0f green:78.0f/255.0f blue:81.0f/255.0f alpha:1.0f];
        self.label.textAlignment = NSTextAlignmentLeft;
        self.label.text = @"";
        
        self.contentView.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:238.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
        
        [self.contentView addSubview:self.photoView];
        [self.contentView addSubview:self.label];
        

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
