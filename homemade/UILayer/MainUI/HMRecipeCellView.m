//
//  HMRecipeCellView.m
//  homemade
//
//  Created by Guan Guan on 4/17/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMRecipeCellView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+ColorImage.h"

@interface HMRecipeCellView()

@end

@implementation HMRecipeCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;    
        [self setBackgroundColor:[UIColor clearColor]];
        
        // Initialization code
                
        self.backCover = [[UIView alloc] initWithFrame:self.frame];
        self.backCover.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:self.backCover];
        
        self.photo = [[PFImageView alloc] initWithFrame:CGRectMake(0.0f, 3.0f, self.frame.size.width, kFeedCellHeight)];
        self.photo.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        self.photo.contentMode = UIViewContentModeScaleAspectFill;
        self.photo.clipsToBounds = YES;
        [self.backCover addSubview:self.photo];

        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, kFeedCellHeight + 6.5f, 200, 50.0)];
        self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Oblique" size:19.0f];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.textColor = [UIColor colorWithRed:63.0f/255.0f green:72.0f/255.0f blue:75.0f/255.0f alpha:1.0f];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.backCover addSubview:self.titleLabel];
        
        self.colorLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 3.0f)];
        [self.colorLine setBackgroundColor:[UIColor clearColor]];
        self.colorLine.alpha = 0.85;
        [self.backCover addSubview:self.colorLine];
        
        // add save button
        self.saveIcon = [[UIButton alloc] initWithFrame:CGRectMake(265.0f, kFeedCellHeight + 15.0f, 12.0f, 12.0f)];
        [self.saveIcon setBackgroundColor:[UIColor clearColor]];
        [self.saveIcon setAdjustsImageWhenHighlighted:NO];
        [self.saveIcon setAdjustsImageWhenDisabled:NO];
        [self.saveIcon setBackgroundImage:[UIImage imageNamed:@"icn20-heart.png"] forState:UIControlStateNormal];
        [self.saveIcon setBackgroundImage:[UIImage imageNamed:@"icn20-heart-active.png"] forState:UIControlStateSelected];
        [self.backCover addSubview:self.saveIcon];

        self.saveCount = [[UILabel alloc] initWithFrame:CGRectMake(23.0f, 0.0f, 40.0f, 12.0f)];
        [self.saveCount setBackgroundColor:[UIColor clearColor]];
        self.saveCount.textColor = [UIColor colorWithRed:39.0f/255.0f green:44.0f/255.0f blue:46.0f/255.0f alpha:1.0f];
        self.saveCount.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0];
        [self.saveIcon addSubview:self.saveCount];
        
        self.cameraIcon = [[UIButton alloc] initWithFrame:CGRectMake(265.0f, kFeedCellHeight + 35.0f, 12.0f, 12.0f)];
        [self.cameraIcon setBackgroundColor:[UIColor clearColor]];
        [self.cameraIcon setAdjustsImageWhenHighlighted:NO];
        [self.cameraIcon setAdjustsImageWhenDisabled:NO];
        [self.cameraIcon setBackgroundImage:[UIImage imageNamed:@"icn20-camera.png"] forState:UIControlStateNormal];
        [self.backCover addSubview:self.cameraIcon];
        
        self.photoCount = [[UILabel alloc] initWithFrame:CGRectMake(23.0f, 0.0f, 40.0f, 12.0f)];
        [self.photoCount setBackgroundColor:[UIColor clearColor]];
        self.photoCount.textColor = [UIColor colorWithRed:39.0f/255.0f green:44.0f/255.0f blue:46.0f/255.0f alpha:1.0f];
        self.photoCount.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0];
        [self.cameraIcon addSubview:self.photoCount];

     }
    
    return self;
}


#pragma mark -
// Override set method
- (void)setRecipe:(PFObject *)aRecipe {
    _recipe = aRecipe;
    
    self.titleLabel.text = [_recipe objectForKey:kHMRecipeTitleKey];
    self.photo.file = [_recipe objectForKey:kHMRecipePhotoKey];
    
    [self setNeedsDisplay];

}

// Configures save Button to match the give save status
- (void)setSaveStatus:(BOOL)saved {
    [self.saveIcon setSelected:saved];
}


@end
