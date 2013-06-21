//
//  HMSearchCell.m
//  homemade
//
//  Created by Guan Guan on 6/21/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMSearchCell.h"

@implementation HMSearchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.photoView = [[PFImageView alloc] initWithFrame:CGRectMake(3.0f, 3.0f, 100, 100)];
        self.photoView.contentMode = UIViewContentModeScaleAspectFill;
        self.photoView.clipsToBounds = YES;
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(106, 5, 200, 40)];
        self.nameLabel.textColor = [UIColor darkGrayColor];
        self.nameLabel.font = [UIFont systemFontOfSize:19.0f];
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(106, 46, 200, 55)];
        self.descriptionLabel.textColor = [UIColor lightGrayColor];
        self.descriptionLabel.font = [UIFont systemFontOfSize:12.0f];
        self.descriptionLabel.numberOfLines = 3;
        [self addSubview:self.photoView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.descriptionLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
