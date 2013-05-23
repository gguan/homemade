//
//  UIImageView+Addition.m
//  homemade
//
//  Created by Y.CORP.YAHOO.COM\gguan on 5/23/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#define kCoverViewTag           1234
#define kImageViewTag           1235
#define kAnimationDuration      0.3f
#define kImageViewWidth         320.0f
#define kBackViewColor          [UIColor colorWithWhite:0.0 alpha:1.0f]

#import "UIImageView+Addition.h"

@implementation UIImageView (UIImageViewEx)

- (void)hiddenView
{
    UIView *coverView = (UIView *)[[self window] viewWithTag:kCoverViewTag];
    [coverView removeFromSuperview];
}

- (void)hiddenViewAnimation
{
    UIImageView *imageView = (UIImageView *)[[self window] viewWithTag:kImageViewTag];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimationDuration]; //动画时长
    CGRect rect = [self convertRect:self.bounds toView:self.window];
    imageView.frame = rect;
    
    [UIView commitAnimations];
    [self performSelector:@selector(hiddenView) withObject:nil afterDelay:kAnimationDuration];
    
}

//自动按原UIImageView等比例调整目标rect
- (CGRect)autoFitFrame
{
    //调整为固定宽，高等比例动态变化
    float width = kImageViewWidth;
    float targeHeight = (width*self.frame.size.height)/self.frame.size.width;
    UIView *coverView = (UIView *)[[self window] viewWithTag:kCoverViewTag];
    CGRect targeRect = CGRectMake(coverView.frame.size.width/2 - width/2, coverView.frame.size.height/2 - targeHeight/2, width, targeHeight);
    return targeRect;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    UIView *coverView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    coverView.backgroundColor = kBackViewColor;
    coverView.tag = kCoverViewTag;
    UITapGestureRecognizer *hiddenViewGecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenViewAnimation)];
    [coverView addGestureRecognizer:hiddenViewGecognizer];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
    imageView.tag = kImageViewTag;
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = self.contentMode;
    CGRect rect = [self convertRect:self.bounds toView:self.window];
    imageView.frame = rect;
    
    [coverView addSubview:imageView];
    [[self window] addSubview:coverView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimationDuration];
    imageView.frame = [self autoFitFrame];
    [UIView commitAnimations];
    
}

- (void)addDetailShow
{
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0;
    [self addGestureRecognizer:lpgr];

}

@end