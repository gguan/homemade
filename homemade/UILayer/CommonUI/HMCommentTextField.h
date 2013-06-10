//
//  HMCommentTextViewController.h
//  homemade
//
//  Created by Guan Guan on 6/9/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//


@protocol HMCommentTextFieldDelegate;

@interface HMCommentTextField : UIView <UITextViewDelegate>

@property (nonatomic, strong) UITextField *commentField;
@property (nonatomic, strong) UIButton *postButton;
@property (nonatomic, weak) id <HMCommentTextFieldDelegate> delegate;

+ (CGRect)rectForView;

@end


@protocol HMCommentTextFieldDelegate <NSObject>
@required
- (void)postButtonAction;
@end
