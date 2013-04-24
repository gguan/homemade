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
        self.contentView.backgroundColor = [UIColor clearColor];
        
        // Initialization code
        
        self.photo = [[PFImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 205.0)];
        self.photo.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        self.photo.contentMode = UIViewContentModeScaleAspectFill;
        self.photo.clipsToBounds = YES;
        
        UIView *banner = [[UIView alloc] initWithFrame:CGRectMake(0.0, 135.0, 320.0, 70.0)];
        banner.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
                
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 7.0, 270.0, 30.0)];
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:19.0];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        self.colorLine = [[UIView alloc] initWithFrame:CGRectMake(312.0, 0.0, 8.0, 70.0)];
        [self.colorLine setBackgroundColor:[UIColor clearColor]];
        
//        NSLog(@"%@", [UIFont fontNamesForFamilyName:@"Helvetica Neue"]);
        
        // add save button
        self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.saveButton setFrame:CGRectMake(100.0f, 50.0f, 12.0f, 12.0f)];
        [self.saveButton setBackgroundColor:[UIColor clearColor]];
        [self.saveButton setAdjustsImageWhenHighlighted:NO];
        [self.saveButton setAdjustsImageWhenDisabled:NO];
        [self.saveButton setBackgroundImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        [self.saveButton setBackgroundImage:[UIImage imageNamed:@"likeActive.png"] forState:UIControlStateSelected];
        [self.saveButton setSelected:YES];
        
        self.saveCount = [[UILabel alloc] initWithFrame:CGRectMake(118.0f, 50.0f, 40.0f, 12.0f)];
        [self.saveCount setBackgroundColor:[UIColor clearColor]];
        self.saveCount.textColor = [UIColor whiteColor];
        self.saveCount.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0];
        
        self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.commentButton setFrame:CGRectMake(40.0f, 50.0f, 12.0f, 12.0f)];
        [self.commentButton setBackgroundColor:[UIColor clearColor]];
        [self.commentButton setAdjustsImageWhenHighlighted:NO];
        [self.commentButton setAdjustsImageWhenDisabled:NO];
        [self.commentButton setBackgroundImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];
        [self.commentButton setBackgroundImage:[UIImage imageNamed:@"commentActive.png"] forState:UIControlStateSelected];
        [self.commentButton setSelected:YES];
        
        self.commentCount = [[UILabel alloc] initWithFrame:CGRectMake(58.0f, 50.0f, 40.0f, 12.0f)];
        [self.commentCount setBackgroundColor:[UIColor clearColor]];
        self.commentCount.textColor = [UIColor whiteColor];
        self.commentCount.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0];

        [banner addSubview:self.titleLabel];
        [banner addSubview:self.colorLine];
        [banner addSubview:self.saveButton];
        [banner addSubview:self.commentButton];
        [banner addSubview:self.saveCount];
        [banner addSubview:self.commentCount];
        [self.photo addSubview:banner];
        
        // add shadow view
        UIView *dropshadowView = [[UIView alloc] init];
        dropshadowView.frame = CGRectMake(0.0, 0.0, 320.0, 205.0);
        dropshadowView.layer.masksToBounds = NO;
        dropshadowView.layer.shadowRadius = 2.0f;
        dropshadowView.layer.shadowOpacity = 0.7f;
        dropshadowView.layer.shadowOffset = CGSizeMake( 0.0f, 1.0f);
        dropshadowView.layer.shadowPath =
        [UIBezierPath bezierPathWithRect:dropshadowView.layer.bounds].CGPath;
        
        [self.contentView addSubview:dropshadowView];
        [self.contentView addSubview:self.photo];
        

        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
