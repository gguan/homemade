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

@interface HMMainViewController ()

@end

@implementation HMMainViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.leftGapPercentage = 0.85f;
        self.rightGapPercentage = 0.93f;
        
        
        UINavigationController *centerNavController = [[UINavigationController alloc] initWithRootViewController: [[HMFeedStreamViewController alloc] init]];
        centerNavController.navigationBar.barStyle = UIBarStyleBlackOpaque;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(toggleRightPanel:)];
        UIViewController *buttonController = [centerNavController.viewControllers objectAtIndex:0];
        if (!buttonController.navigationItem.rightBarButtonItem) {
            buttonController.navigationItem.rightBarButtonItem = rightBarButton;
        }
        buttonController.title = @"Homemade";
        
        self.centerPanel = centerNavController;
        
        HMMenuViewController *menuController = [[HMMenuViewController alloc] initWithStyle:UITableViewStylePlain];

        menuController.feedStreamViewController = centerNavController;
        menuController.sidePanelController.centerPanel = centerNavController;
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

@end
