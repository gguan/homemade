//
//  HMImadeItViewController.m
//  homemade
//
//  Created by Xiaodi Xing on 4/30/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMImadeItViewController.h"

@interface HMImadeItViewController ()
@property (nonatomic, strong) PFObject *recipeObject;
@property (nonatomic, strong) NSMutableArray *works;
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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
