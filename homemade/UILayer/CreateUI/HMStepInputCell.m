//
//  HMStepInputCell.m
//  homemade
//
//  Created by Guan Guan on 6/19/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMStepInputCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation HMStepInputCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        // Initialization code
        self.content = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 60)];
        self.content.numberOfLines = 0;
        self.content.lineBreakMode = NSLineBreakByWordWrapping;
        self.content.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.content];
        
        self.stepImage = [[PFImageView alloc] initWithFrame:CGRectMake(210, 5, 60, 60)];
        self.stepImage.contentMode = UIViewContentModeScaleAspectFill;
        self.stepImage.clipsToBounds = YES;
        [self addSubview:self.stepImage];
    }
    return self;
}

@end
