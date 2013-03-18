//
//  HMMenuViewController.h
//  homemade
//
//  Created by Guan Guan on 3/16/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HMMenuViewController : UITableViewController

@property (nonatomic, strong) UINavigationController *feedStreamViewController;
@property (nonatomic, strong) UINavigationController *saveViewController;
@property (nonatomic, strong) UINavigationController *accountViewController;
@property (nonatomic, strong) UINavigationController *settingViewController;

@end
