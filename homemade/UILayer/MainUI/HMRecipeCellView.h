//
//  HMRecipeCellView.h
//  homemade
//
//  Created by Guan Guan on 4/17/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMRecipeCellView : PFTableViewCell

@property (strong, nonatomic) IBOutlet PFImageView *photo;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;


@end
