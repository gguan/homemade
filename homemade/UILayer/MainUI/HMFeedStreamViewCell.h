//
//  HMFeedStreamViewCell.h
//  homemade
//
//  Created by Guan Guan on 3/21/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMFeedStreamViewCell :  PFTableViewCell

@property (strong, nonatomic) IBOutlet PFImageView *photo;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;

@end
