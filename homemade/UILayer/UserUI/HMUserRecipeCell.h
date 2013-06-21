//
//  HMUserRecipeCell.h
//  homemade
//
//  Created by Guan Guan on 6/21/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMUserRecipeCell : UITableViewCell

@property (strong, nonatomic) PFObject *drinkObject;
@property (strong, nonatomic) PFImageView *avatar;
@property (strong, nonatomic) PFImageView *photo;
@property (strong, nonatomic) UILabel *timestampLabel;
@property (strong, nonatomic) UILabel *noteLabel;

@end
