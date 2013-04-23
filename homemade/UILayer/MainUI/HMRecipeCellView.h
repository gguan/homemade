//
//  HMRecipeCellView.h
//  homemade
//
//  Created by Guan Guan on 4/17/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ColorArt.h"

@interface HMRecipeCellView : PFTableViewCell

@property (strong, nonatomic) PFImageView   *photo;
@property (strong, nonatomic) UILabel   *dateLabel;
@property (strong, nonatomic) UILabel   *titleLabel;
@property (strong, nonatomic) UIView    *colorLine;
@property (strong, nonatomic) UIButton  *saveButton;
@property (strong, nonatomic) UIButton  *commentButton;

@property (strong, nonatomic) SLColorArt *colorArt;

@end
