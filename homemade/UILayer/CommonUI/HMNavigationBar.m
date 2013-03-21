//
//  HMNavigationBar.m
//  homemade
//
//  Created by Guan Guan on 3/21/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMNavigationBar.h"

@implementation HMNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    if(self.barStyle != UIBarStyleBlackTranslucent)
//	{
//        UIImage *image = nil;
//        if(bWithLine_) {
//            image = [UIImage imageNamed:@"bgd-navbar.png"];
//        }
//        else {
//            image = [UIImage imageNamed:@"bgd-navbar-no-line.png"];
//        }
//		[image drawInRect:rect];
//	}
//	else {
//		[super drawRect:rect];
//	}
//
//}


@end
