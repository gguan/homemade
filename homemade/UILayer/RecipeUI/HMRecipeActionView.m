//
//  HMRecipeActionView.m
//  homemade
//
//  Created by Guan Guan on 7/10/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMRecipeActionView.h"
#import "UIImage+ColorImage.h"


@implementation HMRecipeActionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithRed:24.0f/255.0f green:27.0f/255.0f blue:28.0f/255.0f alpha:1.0f]];
        UIColor *mainColor = [UIColor colorWithRed:118.0f/255.0f green:132.0f/255.0f blue:138.0f/255.0f alpha:1.0f];

        self.saveButton = [[UIButton alloc] initWithFrame:CGRectMake(60.0, 20.0, 20.0, 20.0)];
        [self.saveButton setBackgroundImage:[[UIImage imageNamed:@"icn40-heart.png"] changeImageToColor:mainColor] forState:UIControlStateNormal];
        [self.saveButton setBackgroundImage:[[UIImage imageNamed:@"icn40-heart.png"] changeImageToColor:[UIColor colorWithRed:244.0f/255.0f green:95.0f/255.0f blue:31.0f/255.0f alpha:1.0f]] forState:UIControlStateSelected];
        [self addSubview:self.saveButton];
        [self.saveButton addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
        self.saveLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 43.0, 40.0, 20.0)];
        [self.saveLabel setText:@"SAVE"];
        [self.saveLabel setTextColor:mainColor];
        [self.saveLabel setTextAlignment:NSTextAlignmentCenter];
        [self.saveLabel setBackgroundColor:[UIColor clearColor]];
        [self.saveLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:8.0f]];
        [self addSubview:self.saveLabel];
        
        self.commentButton = [[UIButton alloc] initWithFrame:CGRectMake(150.0, 20.0, 20.0, 20.0)];
        [self.commentButton setBackgroundImage:[[UIImage imageNamed:@"icn40-comments.png"] changeImageToColor:mainColor] forState:UIControlStateNormal];
        [self addSubview:self.commentButton];
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(135.0, 43.0, 50.0, 20.0)];
        [commentLabel setText:@"COMMENT"];
        [commentLabel setTextColor:mainColor];
        [commentLabel setTextAlignment:NSTextAlignmentCenter];
        [commentLabel setBackgroundColor:[UIColor clearColor]];
        [commentLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:8.0f]];
        [self addSubview:commentLabel];
        
        self.shareButton = [[UIButton alloc] initWithFrame:CGRectMake(240.0, 20.0, 20.0, 20.0)];
        [self.shareButton setBackgroundImage:[[UIImage imageNamed:@"icn40-facebook.png"] changeImageToColor:mainColor] forState:UIControlStateNormal];
        [self addSubview:self.shareButton];
        UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(230.0, 43.0, 40.0, 20.0)];
        [shareLabel setText:@"SHARE"];
        [shareLabel setTextColor:mainColor];
        [shareLabel setTextAlignment:NSTextAlignmentCenter];
        [shareLabel setBackgroundColor:[UIColor clearColor]];
        [shareLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:8.0f]];
        [self addSubview:shareLabel];
    }
    return self;
}

- (void)test {
    NSLog(@"test");
}

@end
