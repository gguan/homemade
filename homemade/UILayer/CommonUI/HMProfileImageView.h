//
//  HMProfileImageView.h
//  homemade
//
//  Created by Guan Guan on 6/1/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

@interface HMProfileImageView : UIView

@property (nonatomic, strong) UIButton *profileButton;
@property (nonatomic, strong) PFImageView *profileImageView;

- (void)setFile:(PFFile *)file;

@end
