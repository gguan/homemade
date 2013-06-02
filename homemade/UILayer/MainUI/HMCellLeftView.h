//
//  HMCellLeftView.h
//  homemade
//
//  Created by Guan Guan on 4/25/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMProfileImageView.h"

@interface HMCellLeftView : UIView

@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) UIButton *commentButton;
@property (strong, nonatomic) UIButton *shareButton;

@property (nonatomic, strong) HMProfileImageView *avatarImageView;
//@property (nonatomic, strong) UIButton *userButton;
@property (nonatomic, strong) UILabel *timestampLabel;

@end
