//
//  HMSaveViewCell.h
//  homemade
//
//  Created by Guan Guan on 7/19/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <Parse/Parse.h>

@interface HMSaveViewCell : PFTableViewCell

@property (nonatomic, strong) PFImageView *photoView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;

@end
