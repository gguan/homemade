//
//  HMDrinkPhotoViewHeader.m
//  homemade
//
//  Created by Guan Guan on 7/29/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMDrinkPhotoViewHeader.h"
#import "UIImage+ColorImage.h"

@implementation HMDrinkPhotoViewHeader

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:238.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
        
        UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, 49.0f, 320, 1.0f)];
        border.backgroundColor = [UIColor colorWithRed:205.0f/255.0f green:213.0f/255.0f blue:216.0f/255.0f alpha:1.0f];
        
        UILabel *header = [[UILabel alloc]initWithFrame:CGRectMake(135, 10, 150, 30)];
        header.backgroundColor = [UIColor clearColor];
        header.font = [UIFont fontWithName:@"Helvetica-Oblique" size:15];
        header.textColor = [UIColor colorWithRed:69.0f/255.0f green:78.0f/255.0f blue:81.0f/255.0f alpha:1.0f];
        header.text = @"Upload a photo";
        
        self.cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(250, 10, 30, 30)];
        self.cameraButton.layer.cornerRadius = 15.0f;
        self.cameraButton.layer.borderWidth = 1.5f;
        self.cameraButton.layer.borderColor = [UIColor colorWithRed:63.0f/255.0f green:72.0f/255.0f blue:75.0f/255.0f alpha:1.0f].CGColor;
        UIImageView *cameraImg = [[UIImageView alloc] initWithFrame:CGRectMake(7, 6, 16, 16)];
        [cameraImg setImage:[[UIImage imageNamed:@"icn40-camera.png"] changeImageToColor:[UIColor colorWithRed:63.0f/255.0f green:72.0f/255.0f blue:75.0f/255.0f alpha:1.0f]]];
        [self.cameraButton addSubview:cameraImg];
                
        [self addSubview:border];
        [self addSubview:header];
        [self addSubview:self.cameraButton];
    }
    return self;
}

@end
