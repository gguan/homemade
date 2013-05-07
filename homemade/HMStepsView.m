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
@synthesize stepDescriptionText = _stepDescriptionText;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 0; // if you like rounded corners
        self.layer.shadowOffset = CGSizeMake(-8, 8);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.4;
        
        _stepImageView = [[PFImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width*3/4)];
       _stepImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:self.stepImageView];
        
        _stepDescrptionLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, _stepImageView.frame.size.height, self.frame.size.width, self.frame.size.height - _stepImageView.frame.size.height)];
        _stepDescrptionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin;
        [self.stepDescrptionLabel setBackgroundColor:[UIColor lightGrayColor]];
        self.stepDescrptionLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.stepDescrptionLabel.numberOfLines = 0;
        self.stepDescrptionLabel.adjustsFontSizeToFitWidth = YES;
      [self addSubview:self.stepDescrptionLabel];
        
//        _stepDescriptionText = [[UITextView alloc] initWithFrame:CGRectMake(0, _stepImageView.frame.size.height, self.frame.size.width, self.frame.size.height - _stepImageView.frame.size.height)];
//        _stepDescriptionText.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin;
//        [self.stepDescriptionText setBackgroundColor:[UIColor lightGrayColor]];
//        [self.stepDescriptionText setEditable:NO];
//        [self.stepDescriptionText ]
//        [self addSubview:self.stepDescriptionText];
        
        
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
