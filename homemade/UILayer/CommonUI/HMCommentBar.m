//
//  HMCommentTextViewController.m
//  homemade
//
//  Created by Guan Guan on 6/9/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMCommentBar.h"

#define TextFieldWidth 220
#define TextFontSize 14.0f
#define HeightOfView 51.0f

@interface HMCommentBar ()
//@property (nonatomic, strong) UIView *mainView;
@end

@implementation HMCommentBar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
//        self.mainView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, TextFieldWidth, HeightOfView)];
//        self.mainView.backgroundColor = [UIColor clearColor];
//        [self addSubview:self.mainView];
//        
//        UIImageView *commentBox = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchFrame.png"]];
//        commentBox.frame = CGRectMake(5.0f, 8.0f, TextFieldWidth, 35.0f);
//        [self.mainView addSubview:commentBox];
//        
        self.commentField = [[UITextField alloc] initWithFrame:CGRectMake( 10.0f, 10.0f, TextFieldWidth - 20, 31.0f)];
        self.commentField.font = [UIFont systemFontOfSize:TextFontSize];
        self.commentField.placeholder = @"Add a comment";
        self.commentField.returnKeyType = UIReturnKeySend;
        self.commentField.textColor = [UIColor colorWithRed:73.0f/255.0f green:55.0f/255.0f blue:35.0f/255.0f alpha:1.0f];
        self.commentField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.commentField setValue:[UIColor colorWithRed:154.0f/255.0f green:146.0f/255.0f blue:138.0f/255.0f alpha:1.0f] forKeyPath:@"_placeholderLabel.textColor"]; // Are we allowed to modify private properties like this? -Héctor
        [self addSubview:self.commentField];
        
        
        if (DEVICE_VERSION_7) {
            NSLog(@"v7!!!!");
            self.postButton = [UIButton buttonWithType:UIButtonTypeSystem];
        } else {
            self.postButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [self.postButton setBackgroundColor:[UIColor grayColor]];
        }
        
        [self.postButton setTitle:@"Post" forState:UIControlStateNormal];
        [self.postButton setFrame:CGRectMake(10.0f + TextFieldWidth, 8.0f, 80.0f, 35.0f)];
        [self.postButton addTarget:self action:@selector(postButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.postButton];
    }
    return self;
}

+ (CGRect)rectForView:(CGRect)viewRect navBarHidden:(BOOL)hidden {
    if (hidden) {
        return CGRectMake(0.0f, viewRect.size.height - HeightOfView, viewRect.size.width, HeightOfView);
    } else {
        return CGRectMake(0.0f, viewRect.size.height - HeightOfView - 44.0f, viewRect.size.width, HeightOfView);
    }
}

- (void)postButtonAction {
    if (_textFieldDelegate && [_textFieldDelegate respondsToSelector:@selector(postButtonAction)]) {
        NSLog(@"Tap post button...");
        [_textFieldDelegate postButtonAction];
    }
}

- (void) text {
    NSLog(@"test");
}

@end
