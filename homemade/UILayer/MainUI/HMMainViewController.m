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

@interface HMMainViewController ()

@end

@implementation HMMainViewController

- (id)init
{
    self = [super init];
    if (self) {
        UINavigationController *centerNavController = [[UINavigationController alloc] initWithRootViewController: [[HMFeedStreamViewController alloc] init]];
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(toggleRightPanel:)];
        UIViewController *buttonController = [centerNavController.viewControllers objectAtIndex:0];
        if (!buttonController.navigationItem.rightBarButtonItem) {
            buttonController.navigationItem.rightBarButtonItem = rightBarButton;
        }
        
        self.centerPanel = centerNavController;
        
        HMMenuViewController *menuController = [[HMMenuViewController alloc] init];
//        menuController..centerNavController = centerNavController;
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

@end
