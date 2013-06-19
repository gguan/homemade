//
//  HMAccountViewController.h
//  homemade
//
//  Created by Guan Guan on 6/14/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMCameraViewController.h"

@interface HMAccountViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, HMCameraDelegate>

@property (nonatomic, strong) HMCameraViewController *photoPicker;

@property (nonatomic, strong) UIScrollView *coverScroller;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PFUser *user;

- (id)initWithUser:(PFUser *)user;

@end
