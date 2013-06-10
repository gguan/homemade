//
//  HMCommentViewCell.m
//  homemade
//
//  Created by Guan Guan on 6/10/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMCommentViewCell.h"

#define CommentTextFontSize 13.0f

@implementation HMCommentViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.commentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        self.commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.commentLabel.numberOfLines = 0;
        self.commentLabel.textColor = [UIColor blackColor];
        self.commentLabel.font = [UIFont systemFontOfSize:CommentTextFontSize];
        [self addSubview:self.commentLabel];
        [self.commentLabel setBackgroundColor:[UIColor clearColor]];
        
        self.avatar = [[PFImageView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 30.0f, 30.0f)];
        [self addSubview:self.avatar];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.commentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        self.commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.commentLabel.numberOfLines = 0;
        self.commentLabel.textColor = [UIColor blackColor];
        self.commentLabel.font = [UIFont systemFontOfSize:CommentTextFontSize];
        [self addSubview:self.commentLabel];
        
        self.avatar = [[PFImageView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 30.0f, 30.0f)];
        [self addSubview:self.avatar];
    }
    return self;
}

@end
