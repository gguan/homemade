//
//  HMLeftPanelViewController.h
//  homemade
//
//  Created by Guan Guan on 6/14/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMCategoryViewController.h"
#import "HMRecipeFeedViewController.h"
#import "HMAccountViewController.h"
#import "HMSaveViewController.h"

@interface HMLeftPanelViewController : UITableViewController

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) HMRecipeFeedViewController *recipeFeedViewController;
@property (nonatomic, strong) HMAccountViewController *accountViewController;
@property (nonatomic, strong) HMCategoryViewController *categoryViewController;
@property (nonatomic, strong) HMSaveViewController *saveViewController;

@end
