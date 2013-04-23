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
        
        [banner addSubview:self.titleLabel];
        [self.contentView addSubview:self.photo];
        [self.photo addSubview:banner];
        

        //NSLog(@"%@", [UIFont fontNamesForFamilyName:@"Helvetica Neue"]);
        
        // add save button
        UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [banner addSubview:saveButton];
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
