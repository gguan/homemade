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
        self.rightFixedWidth = 290.0f;
        
        UINavigationController *centerNavController = [[UINavigationController alloc] initWithRootViewController: [[HMFeedStreamViewController alloc] init]];
        HMMenuViewController *menuController = [[HMMenuViewController alloc] initWithStyle:UITableViewStylePlain];
        menuController.feedStreamViewController = centerNavController;
        
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

- (UIBarButtonItem *)leftButtonForCenterPanel {
    
    UIImageView *btnImage = [[UIImageView alloc] initWithFrame:CGRectMake(12.0f, 0.0f, 20.0f, 20.0f)];
    [btnImage setImage:[UIImage imageNamed:@"icons_menu.png"]];
    btnImage.alpha = 0.6f;
    btnImage.layer.shadowColor = [UIColor whiteColor].CGColor;
    btnImage.layer.shadowOffset = CGSizeMake(0.0, -1.0);
    btnImage.contentMode = UIViewContentModeScaleAspectFit;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(12.0f, 12.0f, 32.0f, 20.0f);
    [rightButton addSubview:btnImage];
    [rightButton addTarget:self action:@selector(toggleLeftPanel:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    return leftBarButton;
}


@end
