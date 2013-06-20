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
        // Initialization code
        self.contentField = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 200, 60)];
        self.contentField.font = [UIFont systemFontOfSize:14.0f];
        self.contentField.returnKeyType = UIReturnKeyDefault;
        self.contentField.layer.borderWidth = 1.0f;
        self.contentField.layer.borderColor = [UIColor colorWithWhite:0.7f alpha:0.5f].CGColor;
        self.contentField.layer.cornerRadius = 3.0f;
        [self addSubview:self.contentField];
        
        self.stepImage = [[PFImageView alloc] initWithFrame:CGRectMake(210, 5, 60, 60)];
        self.stepImage.contentMode = UIViewContentModeScaleAspectFill;
        self.stepImage.clipsToBounds = YES;
        self.stepImage.layer.borderColor = [UIColor colorWithWhite:0.7f alpha:0.5f].CGColor;

        self.imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.imageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.imageButton.titleLabel setFont:[UIFont systemFontOfSize:10.0f]];
        [self.imageButton setFrame:CGRectMake(210, 5, 60, 60)];
        [self.imageButton setBackgroundColor:[UIColor clearColor]];
        [self.imageButton setTitle:@"choose image" forState:UIControlStateNormal];
        
        [self addSubview:self.stepImage];
        [self insertSubview:self.imageButton aboveSubview:self.stepImage];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
