//
//  HMSignUpViewController.m
//  homemade
//
//  Created by Guan Guan on 8/27/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMSignUpViewController.h"

@interface HMSignUpViewController ()

@end

@implementation HMSignUpViewController

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
    
    [self.signUpView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundLogin.png"]]];
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]]];
    
    // Set field text color
    [self.signUpView.usernameField setBackgroundColor:[UIColor colorWithRed:35.0f/255.0f green:35.0f/255.0f blue:35.0f/255.0f alpha:0.5]];
    [self.signUpView.passwordField setBackgroundColor:[UIColor colorWithRed:35.0f/255.0f green:35.0f/255.0f blue:35.0f/255.0f alpha:0.5]];
    // Set field text color
    [self.signUpView.emailField setBackgroundColor:[UIColor colorWithRed:35.0f/255.0f green:35.0f/255.0f blue:35.0f/255.0f alpha:0.5]];
    
}

- (void)viewDidLayoutSubviews {
    [self.signUpView.logo setFrame:CGRectMake(120.0f, 70.0f, 80.0f, 15.0f)];
}

@end
