//
//  HMStepsView.m
//  homemade
//
//  Created by Xiaodi Xing on 5/3/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMStepsView.h"

@implementation HMStepsView
@synthesize stepDescrptionLabel = _stepDescrptionLabel;
@synthesize stepImageView = _stepImageView;
@synthesize stepNumberLabel = _stepNumberLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    
        
        _stepImageView = [[PFImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width*3/4)];
       _stepImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.stepImageView];
        
        _stepDescrptionLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, _stepImageView.frame.size.height, self.frame.size.width, self.frame.size.height - _stepImageView.frame.size.height)];
        _stepDescrptionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.stepDescrptionLabel setBackgroundColor:[UIColor lightGrayColor]];
        
        [self addSubview:self.stepDescrptionLabel];
        
        _stepNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.stepImageView.frame.size.height - 10, 20, 20)];
        _stepNumberLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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
