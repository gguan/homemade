//
//  HMFeedStreamViewCell.m
//  homemade
//
//  Created by Guan Guan on 3/21/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMFeedStreamViewCell.h"
#import <QuartzCore/QuartzCore.h>

#define PHOTO_TAG 1
#define DATE_TAG 2
#define NAME_TAG 3
#define DESC_TAG 4

@implementation HMFeedStreamViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // Initialization code
        self.photo = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 310.0, 310.0)];
        self.photo.tag = PHOTO_TAG;
        self.photo.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        self.photo.layer.cornerRadius = 5.0f;
        
        
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 320.0, 200.0, 20.0)];
        self.dateLabel.tag = DATE_TAG;
        self.dateLabel.font = [UIFont systemFontOfSize:12.0f];
        self.dateLabel.textColor = [UIColor darkGrayColor];
        self.dateLabel.textAlignment = NSTextAlignmentLeft;
        self.dateLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 340.0, 200.0, 20.0)];
        self.nameLabel.tag = NAME_TAG;
        self.nameLabel.font = [UIFont systemFontOfSize:12.0f];;
        self.nameLabel.textColor = [UIColor darkGrayColor];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        self.descLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 360.0, 250.0, 10.0)];
        self.descLabel.tag = DESC_TAG;
        self.descLabel.font = [UIFont systemFontOfSize:8.0];
        self.descLabel.textColor = [UIColor grayColor];
        self.descLabel.textAlignment = NSTextAlignmentLeft;
        self.descLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        self.descLabel.numberOfLines = 0;
        
        [self.contentView addSubview:self.photo];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.descLabel];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
