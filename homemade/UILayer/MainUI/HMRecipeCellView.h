//
//  HMRecipeCellView.h
//  homemade
//
//  Created by Guan Guan on 4/17/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//


@interface HMRecipeCellView : PFTableViewCell

@property (strong, nonatomic) UIView    *backCover;
@property (strong, nonatomic) PFImageView   *photo;
@property (strong, nonatomic) UILabel   *titleLabel;
@property (strong, nonatomic) UIView    *colorLine;
@property (strong, nonatomic) UIButton  *saveIcon;
@property (strong, nonatomic) UIButton  *cameraIcon;
@property (strong, nonatomic) UILabel   *saveCount;
@property (strong, nonatomic) UILabel   *photoCount;
@property (strong, nonatomic) UIColor   *colorArt;
@property (strong, nonatomic) PFObject  *recipe;

- (void)setSaveStatus:(BOOL)saved;

@end
