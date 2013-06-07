//
//  HMPhotoCommentView.m
//  homemade
//
//  Created by Guan Guan on 6/7/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMPhotoCommentView.h"
#import "HMUtility.h"

@interface HMPhotoCommentView()
@property (nonatomic, strong) UIView *mainView;
@end

@implementation HMPhotoCommentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        self.mainView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, frame.size.width, 51.0f)];
        self.mainView.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0];
        [self addSubview:self.mainView];
        
        UIImageView *commentBox = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchFrame.png"]];
        commentBox.frame = CGRectMake(0.0f, 8.0f, frame.size.width, 35.0f);
        [self.mainView addSubview:commentBox];
        
        self.commentField = [[UITextField alloc] initWithFrame:CGRectMake( 10.0f, 10.0f, 257.0f, 31.0f)];
        self.commentField.font = [UIFont systemFontOfSize:14.0f];
        self.commentField.placeholder = @"Add a comment";
        self.commentField.returnKeyType = UIReturnKeySend;
        self.commentField.textColor = [UIColor colorWithRed:73.0f/255.0f green:55.0f/255.0f blue:35.0f/255.0f alpha:1.0f];
        self.commentField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.commentField setValue:[UIColor colorWithRed:154.0f/255.0f green:146.0f/255.0f blue:138.0f/255.0f alpha:1.0f] forKeyPath:@"_placeholderLabel.textColor"]; // Are we allowed to modify private properties like this? -Héctor
        [self.mainView addSubview:self.commentField];
    }
    return self;
}

#pragma mark - UIView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (!self.hideDropShadow) {
        [HMUtility drawSideAndBottomDropShadowForRect:self.mainView.frame inContext:UIGraphicsGetCurrentContext()];
    }
}


#pragma mark - PAPPhotoDetailsFooterView

+ (CGRect)rectForView {
    return CGRectMake( 0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 69.0f);
}

@end
