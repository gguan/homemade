//
//  HMStepsView.h
//  homemade
//
//  Created by Xiaodi Xing on 5/3/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "TTTAttributedLabel.h"

static CGFloat PageFlowViewWidth = 260.0f;
static CGFloat PageFlowViewHeight = 420.0f;

@interface HMStepsView : UIView

@property (nonatomic, strong) TTTAttributedLabel* stepNumberLabel;
@property (nonatomic, strong) UIImageView *stepNumberImage;
@property (nonatomic, copy) NSString *stepDescriptionText;
@property (nonatomic, strong) TTTAttributedLabel *stepDescrptionLabel;
@property (nonatomic, strong) PFImageView *stepImageView;
@property (nonatomic, strong) UIImageView *stepDescriptionLabelSnapShot;

- (void)setLayout;

@end
