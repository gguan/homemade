//
//  HMStepsView.h
//  homemade
//
//  Created by Xiaodi Xing on 5/3/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMStepsView : UIView

@property(nonatomic,retain) UILabel* stepNumberLabel;
@property(nonatomic,retain) UILabel* stepDescrptionLabel;
@property(nonatomic,retain) PFImageView *stepImageView;
@property(nonatomic,retain) UIImageView *stepDescriptionLabelSnapShot;
@end
