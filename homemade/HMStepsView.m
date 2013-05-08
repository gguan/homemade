//
//  HMStepsView.m
//  homemade
//
//  Created by Xiaodi Xing on 5/3/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMStepsView.h"
#import <QuartzCore/QuartzCore.h>

@implementation HMStepsView
@synthesize stepDescrptionLabel = _stepDescrptionLabel;
@synthesize stepImageView = _stepImageView;
@synthesize stepNumberLabel = _stepNumberLabel;
@synthesize stepDescriptionLabelSnapShot = _stepDescriptionLabelSnapShot;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 0; // if you like rounded corners
        self.layer.shadowOffset = CGSizeMake(0, 10);
        self.layer.shadowRadius = 10;
        self.layer.shadowOpacity = 0.6;
        
        _stepImageView = [[PFImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width*3/4)];
       _stepImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:self.stepImageView];
        
        _stepDescrptionLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, _stepImageView.frame.size.height, self.frame.size.width, self.frame.size.height - _stepImageView.frame.size.height)];
        _stepDescrptionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin;
        [self.stepDescrptionLabel setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
        self.stepDescrptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.stepDescrptionLabel.numberOfLines = 0;
        self.stepDescrptionLabel.adjustsFontSizeToFitWidth = YES;
        
        _stepDescriptionLabelSnapShot = [[UIImageView alloc] initWithFrame:CGRectMake(0, _stepImageView.frame.size.height, self.frame.size.width, self.frame.size.height - _stepImageView.frame.size.height)];
        self.stepDescriptionLabelSnapShot.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin;
      [self addSubview:self.stepDescriptionLabelSnapShot];
        
        
        
        _stepNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.stepImageView.frame.size.height - 10, 20, 20)];
        _stepNumberLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:self.stepNumberLabel];
        
      
        
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
