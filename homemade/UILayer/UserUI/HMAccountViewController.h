//
//  HMAccountViewController.h
//  homemade
//
//  Created by Guan Guan on 6/14/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMAccountViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) PFImageView *coverView;
@property (nonatomic, strong) UIScrollView *coverScroller;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PFUser *user;

- (id)initWithUser:(PFUser *)user;

@end
