//
//  HMLoginViewController.m
//  homemade
//
//  Created by Guan Guan on 4/24/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMLoginViewController.h"

@interface HMLoginViewController ()

@end

@implementation HMLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // There is no documentation on how to handle assets with the taller iPhone 5 screen as of 9/13/2012
    if ([UIScreen mainScreen].bounds.size.height > 480.0f) {
        // for the iPhone 5
        // TODO : change image
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundLogin.png"]];
    } else {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundLogin.png"]];
    }
    
    [self.logInView setLogo:nil];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
