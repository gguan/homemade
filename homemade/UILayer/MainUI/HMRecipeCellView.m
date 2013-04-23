//
//  HMRecipeCellView.m
//  homemade
//
//  Created by Guan Guan on 4/17/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMRecipeCellView.h"
#import <QuartzCore/QuartzCore.h>

@implementation HMRecipeCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;    
        self.contentView.backgroundColor = [UIColor grayColor];
        
        // Initialization code
        
        self.photo = [[PFImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 205.0)];
        self.photo.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        self.photo.contentMode = UIViewContentModeScaleAspectFill;
        self.photo.layer.masksToBounds = YES;
        
        UIView *banner = [[UIView alloc] initWithFrame:CGRectMake(0.0, 135.0, 320.0, 70.0)];
        banner.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
                
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 10.0, 270.0, 30.0)];
        self.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:19.0];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        self.colorLine = [[UIView alloc] initWithFrame:CGRectMake(310.0, 0.0, 10.0, 70.0)];
        [self.colorLine setBackgroundColor:[UIColor clearColor]];
        
                

        //NSLog(@"%@", [UIFont fontNamesForFamilyName:@"Helvetica Neue"]);
        
        // add save button
        self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.saveButton setFrame:CGRectMake(100.0f, 42.0f, 12.0f, 12.0f)];
        [self.saveButton setBackgroundColor:[UIColor clearColor]];
        [self.saveButton setAdjustsImageWhenHighlighted:NO];
        [self.saveButton setAdjustsImageWhenDisabled:NO];
        [self.saveButton setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        [self.saveButton setBackgroundImage:[UIImage imageNamed:@"likeActive.png"] forState:UIControlStateSelected];
        [self.saveButton setSelected:YES];
        
        
        self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.commentButton setFrame:CGRectMake(40.0f, 42.0f, 12.0f, 12.0f)];
        [self.commentButton setBackgroundColor:[UIColor clearColor]];
        [self.commentButton setAdjustsImageWhenHighlighted:NO];
        [self.commentButton setAdjustsImageWhenDisabled:NO];
        [self.commentButton setBackgroundImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];
        [self.commentButton setBackgroundImage:[UIImage imageNamed:@"commentActive.png"] forState:UIControlStateSelected];
        [self.commentButton setSelected:YES];
        
        [banner addSubview:self.titleLabel];
        [banner addSubview:self.colorLine];
        [banner addSubview:self.saveButton];
        [banner addSubview:self.commentButton];
        [self.contentView addSubview:self.photo];
        [self.photo addSubview:banner];

        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
