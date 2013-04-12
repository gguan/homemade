//
//  HMAccountViewController.h
//  homemade
//
//  Created by Guan Guan on 3/18/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMAccountViewController : UITableViewController

@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

- (void)loginButtonTouchHandler:(id)sender;

@end
