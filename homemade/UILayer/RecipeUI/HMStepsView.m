//
//  HMStepsView.m
//  homemade
//
//  Created by Xiaodi Xing on 5/3/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMStepsView.h"
#import "UIImageView+Addition.h"
#import <QuartzCore/QuartzCore.h>

#define kStepDescriptionTextFontSize 13

@implementation HMStepsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
                
        [self setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
        self.layer.masksToBounds = NO;
        self.layer.shadowRadius = 0.4f;
        self.layer.shadowOpacity = 0.4f;
        self.layer.shadowOffset = CGSizeMake( 0.0f, 0.4f);
        
        // Init step image view
        self.stepImageView = [[PFImageView alloc] initWithFrame:CGRectZero];
        self.stepImageView.clipsToBounds = YES;
        self.stepImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin;
        [self.stepImageView addDetailShow];
        [self addSubview:self.stepImageView];
        
        // Init step description
        self.stepDescrptionLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [self.stepDescrptionLabel setBackgroundColor:[UIColor clearColor]];
        self.stepDescrptionLabel.font = [UIFont systemFontOfSize:kStepDescriptionTextFontSize];
        self.stepDescrptionLabel.textColor = [UIColor darkGrayColor];
        self.stepDescrptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.stepDescrptionLabel.numberOfLines = 0;
        self.stepDescrptionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:self.stepDescrptionLabel];
                
        // Init step number image and text
        self.stepNumberImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pagination.png"]];
        self.stepNumberImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin;
        self.stepNumberLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, 47, 41)];
        [self.stepNumberLabel setBackgroundColor:[UIColor clearColor]];
        self.stepNumberLabel.font = [UIFont systemFontOfSize:20];
        self.stepNumberLabel.textColor = [UIColor whiteColor];
        self.stepNumberLabel.numberOfLines = 1;
        self.stepNumberLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin;
        [self.stepNumberLabel setTextAlignment:NSTextAlignmentCenter];
        [self.stepNumberImage addSubview:self.stepNumberLabel];
        [self addSubview:self.stepNumberImage];
        
    }
    return self;
}



- (CGFloat)heightForStepText:(NSString *)text {
    CGFloat height = 10.0f;
    height += ceilf([text sizeWithFont:[UIFont systemFontOfSize:kStepDescriptionTextFontSize] constrainedToSize:CGSizeMake(PageFlowViewWidth - 20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height);
    return height;
}

- (void)setLayout {
    CGFloat textHeight = [self heightForStepText:self.description];
    self.stepDescrptionLabel.frame = CGRectMake(10, PageFlowViewHeight - textHeight - 10, PageFlowViewWidth - 20, textHeight);
    self.stepImageView.frame = CGRectMake(0, 0, PageFlowViewWidth, PageFlowViewHeight - textHeight - 30);
    self.stepNumberImage.frame = CGRectMake(0, PageFlowViewHeight - textHeight - 30 - 21, 47, 41);
}

- (void)hideSubViews {
    [self.stepDescrptionLabel setHidden:YES];
    [self.stepImageView setHidden:YES];
    [self.stepNumberImage setHidden:YES];

}

- (void)showSubViews {
    [self.stepDescrptionLabel setHidden:NO];
    [self.stepImageView setHidden:NO];
    [self.stepNumberImage setHidden:NO];
}

@end
