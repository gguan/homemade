//
//  HMAppDelegate.h
//  homemade
//
//  Created by Guan Guan on 3/15/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWRevealViewController;

@interface HMAppDelegate : UIResponder <UIApplicationDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *mainController;

@property (nonatomic, readonly) int networkStatus;

- (BOOL)isParseReachable;

@end
