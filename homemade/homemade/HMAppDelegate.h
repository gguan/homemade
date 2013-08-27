//
//  HMAppDelegate.h
//  homemade
//
//  Created by Guan Guan on 3/15/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMRecipeFeedViewController;

@interface HMAppDelegate : UIResponder <UIApplicationDelegate, NSURLConnectionDataDelegate, PFLogInViewControllerDelegate , PFSignUpViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HMRecipeFeedViewController *mainController;

@property (nonatomic, readonly) int networkStatus;

- (BOOL)isParseReachable;
- (void)presentLoginViewControllerAnimated:(BOOL)animated;
- (void)logout;

@end
