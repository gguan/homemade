//
//  HMCommentTextViewController.h
//  homemade
//
//  Created by Guan Guan on 6/9/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMCommentTextField : UIView <UITextViewDelegate>

@property (nonatomic, strong) UITextField *commentField;
@property (nonatomic, strong) UIButton *postButton;

+ (CGRect)rectForView;

@end
