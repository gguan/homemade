//
//  HMCommentTextViewController.h
//  homemade
//
//  Created by Guan Guan on 6/9/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//


@protocol HMCommentTextFieldDelegate;

@interface HMCommentBar : UIToolbar <UITextViewDelegate>

@property (nonatomic, strong) UITextField *commentField;
@property (nonatomic, strong) UIButton *postButton;
@property (nonatomic, weak) id <HMCommentTextFieldDelegate> textFieldDelegate;

+ (CGRect)rectForView:(CGRect)viewRect navBarHidden:(BOOL)hidden;

@end


@protocol HMCommentTextFieldDelegate <NSObject>
@required
- (void)postButtonAction;
@end
