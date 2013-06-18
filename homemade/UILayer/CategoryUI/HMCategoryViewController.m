//
//  HMCategoryViewController.m
//  homemade
//
//  Created by Guan Guan on 6/17/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMCategoryViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface HMCategoryViewController ()

@end

@implementation HMCategoryViewController

- (id)init
{
    self = [super init];
    if (self) {
//        [self.view setFrame:[UIScreen mainScreen].bounds];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"DRINK+"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(leftDrawerButtonClicked)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
- (void)leftDrawerButtonClicked {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end
