//
//  HMMainViewController.m
//  homemade
//
//  Created by Guan Guan on 3/16/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMMainViewController.h"
#import "HMFeedStreamViewController.h"
#import "HMMenuViewController.h"
#import "HMSearchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+JASidePanel.h"
#import "HMNavigationBar.h"

@interface HMMainViewController ()

@end

@implementation HMMainViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.leftFixedWidth = 70.0f;
        self.rightGapPercentage = 0.93f;
        
        UINavigationController *centerNavController = [[UINavigationController alloc] initWithRootViewController: [[HMFeedStreamViewController alloc] init]];
        HMMenuViewController *menuController = [[HMMenuViewController alloc] initWithStyle:UITableViewStylePlain];
        menuController.feedStreamViewController = centerNavController;
        menuController.sidePanelController.centerPanel = centerNavController;
        
        self.centerPanel = centerNavController;
        self.leftPanel = menuController;
        self.rightPanel = [[HMSearchViewController alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)stylePanel:(UIView *)panel {
    panel.layer.cornerRadius = 3.0f;
    panel.clipsToBounds = YES;
}

- (void)styleContainer:(UIView *)container animate:(BOOL)animate duration:(NSTimeInterval)duration {
    [super styleContainer:container animate:animate duration:duration];
    container.layer.shadowColor = [UIColor blackColor].CGColor;
    container.layer.shadowRadius = 5.0f;
    container.layer.shadowOpacity = 0.75f;
    container.clipsToBounds = NO;
}


@end
