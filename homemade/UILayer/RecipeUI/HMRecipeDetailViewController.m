//
//  HMRecipeDetailViewController.m
//  homemade
//
//  Created by Guan Guan on 4/22/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMRecipeDetailViewController.h"

@interface HMRecipeDetailViewController ()

@end

@implementation HMRecipeDetailViewController

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
    
    // Set Back button, it's not in scroll view
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setFrame:CGRectMake(30, 80, 34, 34)];
    [self.backButton setBackgroundColor:[UIColor clearColor]];
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"account"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    // init scroll view
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSLog(@"%f", self.view.frame.size.height);
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.bounces = NO;
    [self.view addSubview:self.scrollView];
    
    // init image view
    PFFile *imgFile = [self.recipeObject objectForKey:kHMRecipePhotoKey];
    [imgFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
        self.headerImage = [[UIImageView alloc] initWithImage:[UIImage imageWithData:imgFile.getData]];
        [self.headerImage setFrame:CGRectMake(0, 0, 320, 800.0)];
        self.headerImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.scrollView addSubview:self.headerImage];
    }];
    
    self.scrollView.contentSize = CGSizeMake(320, 800);
    [self.view bringSubviewToFront:self.backButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
