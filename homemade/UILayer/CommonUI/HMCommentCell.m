//
//  HMCommentViewCell.m
//  homemade
//
//  Created by Guan Guan on 6/10/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMCommentCell.h"
#import <QuartzCore/QuartzCore.h>

#define CommentTextFontSize 13.0f

@implementation HMCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        self.clipsToBounds = YES;
        self.commentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        self.commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.commentLabel.numberOfLines = 0;
        self.commentLabel.textColor = [UIColor blackColor];
        self.commentLabel.font = [UIFont systemFontOfSize:CommentTextFontSize];

        [self addSubview:self.commentLabel];
        [self.commentLabel setBackgroundColor:[UIColor clearColor]];
        
        self.avatar = [[PFImageView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 30.0f, 30.0f)];
        self.avatar.layer.cornerRadius = 5.0f;
        self.avatar.layer.masksToBounds = YES;
        [self addSubview:self.avatar];
    }
    return self;
}

@end
