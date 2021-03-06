//
//  HMProfileImageView.m
//  homemade
//
//  Created by Guan Guan on 6/1/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMProfileImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface HMProfileImageView()
@property (nonatomic, strong) UIImageView *borderImageView;
@end

@implementation HMProfileImageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.profileImageView = [[PFImageView alloc] initWithFrame:frame];
        self.profileImageView.layer.masksToBounds = YES;
        self.profileImageView.layer.cornerRadius = 4.0f;
        [self addSubview:self.profileImageView];
        
        self.profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.profileButton];
        
        if (frame.size.width < 35.0f) {
            self.borderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShadowProfilePicture-29.png"]];
        } else if (frame.size.width < 43.0f) {
            self.borderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShadowProfilePicture-35.png"]];
        } else {
            self.borderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShadowProfilePicture-43.png"]];
        }
        
        [self addSubview:self.borderImageView];
    }
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    [self bringSubviewToFront:self.borderImageView];
    
    self.profileImageView.frame = CGRectMake( 1.0f, 0.0f, self.frame.size.width - 2.0f, self.frame.size.height - 2.0f);
    self.borderImageView.frame = CGRectMake( 0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    self.profileButton.frame = CGRectMake( 0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
}

#pragma mark - PAPProfileImageView

- (void)setFile:(PFFile *)file {
    if (!file) {
        return;
    }
    
    self.profileImageView.image = [UIImage imageNamed:@"AvatarPlaceholder.png"];
    self.profileImageView.file = file;
    [self.profileImageView loadInBackground];
}

@end
