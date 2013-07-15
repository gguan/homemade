//
//  HMStepsView.m
//  homemade
//
//  Created by Xiaodi Xing on 5/3/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMStepsView.h"
#import "UIImageView+Addition.h"
#import "UIImage+ResizeAdditions.h"
#import <QuartzCore/QuartzCore.h>

#define kStepDescriptionTextFontSize 15

@implementation HMStepsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.layer.shadowRadius = kShadowRadius;
        self.layer.shadowOpacity = kShadowOpacity;
        self.layer.shadowOffset = kShadowOffset;
        
        [self setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
        
        // Init step image view
        self.stepImageView = [[PFImageView alloc] initWithFrame:CGRectZero];
        self.stepImageView.clipsToBounds = YES;
        self.stepImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.stepImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin;
        [self.stepImageView addDetailShow];
        [self addSubview:self.stepImageView];
        
        // Init step description
        self.stepDescrptionLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [self.stepDescrptionLabel setBackgroundColor:[UIColor clearColor]];
        self.stepDescrptionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
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
    height += ceilf([text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:15] constrainedToSize:CGSizeMake(PageFlowViewWidth - 40, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height);
    return height;
}

- (void)setLayout {
    
    CGFloat viewHeight = PageFlowViewHeight;
    if ([[UIScreen mainScreen] bounds].size.height < 548) {
        viewHeight -= 68;
    }
    
    CGFloat textHeight = [self heightForStepText:self.description];
    
    if (self.stepImageView.file) {
        
        CGFloat imageScaleHeight = self.stepImageView.image.size.height * PageFlowViewWidth / self.stepImageView.image.size.width;
        NSLog(@"Image size:%@ SH:%f", NSStringFromCGSize(self.stepImageView.image.size), imageScaleHeight);
        
        CGFloat stepDescriptionY = viewHeight - textHeight - 20;
        if (imageScaleHeight < stepDescriptionY) {
            stepDescriptionY = imageScaleHeight + 20;
        }
        CGFloat stepDescriptionHeight = textHeight;
        if (viewHeight - imageScaleHeight - 20 > textHeight) {
            stepDescriptionHeight = viewHeight - imageScaleHeight - 20;
        }
        
        CGFloat stepImageHeight = viewHeight - textHeight - 40;
        if (stepImageHeight > imageScaleHeight) {
            stepImageHeight = imageScaleHeight;
        }
        
        self.stepImageView.frame = CGRectMake(0, 0, PageFlowViewWidth, stepImageHeight);
        self.stepDescrptionLabel.frame = CGRectMake(20, stepDescriptionY, PageFlowViewWidth - 40, stepDescriptionHeight);
        self.stepNumberImage.frame = CGRectMake(0, stepDescriptionY - 41, 47, 41);
    } else {
        self.stepDescrptionLabel.frame = CGRectMake(30, 100, PageFlowViewWidth - 60, textHeight + 20);
        self.stepNumberImage.frame = CGRectMake(20, 50, 47, 41);
    }
    
}


@end
