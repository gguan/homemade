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

    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundLogin.png"]]];
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]]];

    // Set field text color
    [self.logInView.usernameField setBackgroundColor:[UIColor colorWithRed:35.0f/255.0f green:35.0f/255.0f blue:35.0f/255.0f alpha:0.5]];
    [self.logInView.passwordField setBackgroundColor:[UIColor colorWithRed:35.0f/255.0f green:35.0f/255.0f blue:35.0f/255.0f alpha:0.5]];
    

}

- (void)viewDidLayoutSubviews {
    [self.logInView.logo setFrame:CGRectMake(120.0f, 70.0f, 80.0f, 15.0f)];
}


@end
