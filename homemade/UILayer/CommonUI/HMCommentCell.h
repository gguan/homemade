//
//  HMCommentViewCell.h
//  homemade
//
//  Created by Guan Guan on 6/10/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "TTTAttributedLabel.h"

@interface HMCommentCell : PFTableViewCell

@property (nonatomic, strong) TTTAttributedLabel *commentLabel;
@property (nonatomic, strong) PFImageView *avatar;

@end
