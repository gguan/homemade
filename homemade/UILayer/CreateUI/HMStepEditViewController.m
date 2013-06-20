//
//  HMStepEditViewController.m
//  homemade
//
//  Created by Guan Guan on 6/19/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMStepEditViewController.h"

@interface HMStepEditViewController ()

@end

@implementation HMStepEditViewController

- (id)initWithContent:(NSString *)content photo:(PFFile *)photoFile
{
    self = [super init];
    if (self) {
        // Custom initialization
        [self.view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
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
