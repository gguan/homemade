//
//  HMImadeItViewController.m
//  homemade
//
//  Created by Xiaodi Xing on 4/30/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMImadeItViewController.h"

#define HeaderHeight 60
#define CameraButtonWidth 100
#define CameraButtonHeight 47

@interface HMImadeItViewController ()
@property (nonatomic, strong) PFObject *recipeObject;
@property (nonatomic, strong) NSMutableArray *works;

@property (nonatomic, strong) UIButton *cameraButton;

@end

@implementation HMImadeItViewController

- (id)initWithRecipe:(PFObject*)recipeObject{
    self = [super init];
    if (self) {
        self.recipeObject = recipeObject;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Custom initialization
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, HeaderHeight)];
    self.cameraButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-CameraButtonWidth)/2, 10, CameraButtonWidth, CameraButtonHeight)];
    [self.cameraButton setBackgroundImage:[UIImage imageNamed:@"buttonCamera"] forState:UIControlStateNormal];
    [self.cameraButton setBackgroundImage:[UIImage imageNamed:@"buttonCameraSelected"] forState:UIControlStateHighlighted];
    [headerView addSubview:self.cameraButton];
    
    self.tableView.tableHeaderView = headerView;

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
