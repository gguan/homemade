//
//  HMFeedStreamViewCell.m
//  homemade
//
//  Created by Guan Guan on 3/21/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMFeedStreamViewCell.h"
#import "EDColor.h"
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
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"E3E3E3"];
        
        // Initialization code
        
        // add shadow view
        UIView *dropshadowView = [[UIView alloc] init];
        dropshadowView.backgroundColor = [UIColor whiteColor];
        dropshadowView.frame = CGRectMake( 6.0f, 6.0f, 308.0f, 248.0f);
        [self.contentView addSubview:dropshadowView];
        CALayer *layer = dropshadowView.layer;
        layer.masksToBounds = NO;
        layer.shadowRadius = 1.0f;
        layer.shadowOpacity = 0.5f;
        layer.shadowOffset = CGSizeMake( 0.0f, 1.0f);
        layer.shouldRasterize = YES;
        
        self.photo = [[PFImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 310.0, 310.0)];
        self.photo.tag = PHOTO_TAG;
        self.photo.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        self.photo.layer.cornerRadius = 2.0f;
//        self.photo.layer.borderWidth = 2.0f;
//        self.photo.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.photo.contentMode = UIViewContentModeScaleAspectFill;
        self.photo.layer.masksToBounds = YES;
        NSLog(@"%@", [UIFont fontNamesForFamilyName:@"Helvetica Neue"]);
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 310.0, 50.0)];
        header.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, 49.0f, 310.0f, 1.0f);
        bottomBorder.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f].CGColor;
        [header.layer addSublayer:bottomBorder];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 10.0, 310.0, 30.0)];
        self.nameLabel.tag = NAME_TAG;
        self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        self.descLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 270.0, 300.0, 30.0)];
        self.descLabel.tag = DESC_TAG;
        self.descLabel.font = [UIFont systemFontOfSize:12.0];
        self.descLabel.textColor = [UIColor whiteColor];
        self.descLabel.backgroundColor = [UIColor clearColor];
        self.descLabel.textAlignment = NSTextAlignmentLeft;
        self.descLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        self.descLabel.numberOfLines = 0;
        
        [self.contentView addSubview:self.photo];
        [self.photo addSubview:header];
        [self.photo addSubview:self.nameLabel];
        [self.photo addSubview:self.descLabel];
        
        
        // add save button
        UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [header addSubview:saveButton];
        [saveButton setFrame:CGRectMake(280.0f, 16.0f, 17.0f, 17.0f)];
        [saveButton setBackgroundColor:[UIColor clearColor]];
        [saveButton setTitle:@"5" forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor colorWithRed:0.369f green:0.271f blue:0.176f alpha:1.0f] forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [saveButton setTitleShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f] forState:UIControlStateNormal];
        [saveButton setTitleShadowColor:[UIColor colorWithWhite:0.0f alpha:0.750f] forState:UIControlStateSelected];
        [saveButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        [[saveButton titleLabel] setShadowOffset:CGSizeMake(0.0f, 1.0f)];
        [[saveButton titleLabel] setFont:[UIFont systemFontOfSize:10.0f]];
        [[saveButton titleLabel] setMinimumScaleFactor:11.0f];
        [[saveButton titleLabel] setAdjustsFontSizeToFitWidth:YES];
        [saveButton setAdjustsImageWhenHighlighted:NO];
        [saveButton setAdjustsImageWhenDisabled:NO];
        [saveButton setBackgroundImage:[UIImage imageNamed:@"ButtonLike.png"] forState:UIControlStateNormal];
        [saveButton setBackgroundImage:[UIImage imageNamed:@"ButtonLikeSelected.png"] forState:UIControlStateSelected];
        [saveButton setSelected:YES];

    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
