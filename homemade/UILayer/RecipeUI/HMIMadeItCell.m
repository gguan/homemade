//
//  HMIMadeItCell.m
//  homemade
//
//  Created by Y.CORP.YAHOO.COM\gguan on 6/7/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMIMadeItCell.h"
#import <QuartzCore/QuartzCore.h>

#define AvatarSize 50.0f
#define PictureSize 230.0f

@implementation HMIMadeItCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.avatar = [[PFImageView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, AvatarSize, AvatarSize)];
        self.avatar.layer.cornerRadius = AvatarSize / 2;
        self.avatar.layer.masksToBounds = YES;
        [self addSubview:self.avatar];
        
        self.photo = [[PFImageView alloc] initWithFrame:CGRectMake(0.0f, AvatarSize, PictureSize, PictureSize)];
        
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(self.avatar.frame.origin.x + AvatarSize + 20.0f, 5.0f, PictureSize, PictureSize + AvatarSize + 50)];
        [container setBackgroundColor:[UIColor whiteColor]];
        container.layer.shadowRadius = 0.4f;
        container.layer.shadowOpacity = 0.4f;
        container.layer.shadowOffset = CGSizeMake( 0.0f, 0.0f);
        container.layer.cornerRadius = 3.5f;
        
        [container addSubview:self.photo];
        [self addSubview:container];
    }
    
    return self;
}

+ (CGFloat) cellHeight {
    return AvatarSize + PictureSize + 50 + 10;
}

@end
