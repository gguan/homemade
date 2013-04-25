//
//  HMRecipeCellView.h
//  homemade
//
//  Created by Guan Guan on 4/17/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ColorArt.h"
#import "HMCellLeftView.h"

@interface HMRecipeCellView : PFTableViewCell {
    
    CGPoint     firstTouch;
    BOOL        slideEnabled;
}

@property (strong, nonatomic) PFImageView   *photo;
@property (strong, nonatomic) UIButton  *divider;
@property (strong, nonatomic) UILabel   *titleLabel;
@property (strong, nonatomic) UIView    *colorLine;
@property (strong, nonatomic) UIButton  *saveButton;
@property (strong, nonatomic) UIButton  *commentButton;
@property (strong, nonatomic) UILabel   *saveCount;
@property (strong, nonatomic) UILabel   *commentCount;
@property (strong, nonatomic) UIColor   *colorArt;

@property (strong, nonatomic) HMCellLeftView *cellLeft;

@end
