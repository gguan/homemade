//
//  HMPhotoCommentView.h
//  homemade
//
//  Created by Guan Guan on 6/7/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMEditPhotoCommentTextField : UIView

@property (nonatomic, strong) UITextField *commentField;
@property (nonatomic) BOOL hideDropShadow;

+ (CGRect)rectForView;

@end
