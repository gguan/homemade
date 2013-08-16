//
//  HMLeftPanelViewController.m
//  homemade
//
//  Created by Guan Guan on 6/14/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMLeftPanelViewController.h"
#import "UIViewController+MMDrawerController.h"


@interface HMLeftPanelViewController ()

@end

@implementation HMLeftPanelViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.currentIndex = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor colorWithRed:30.0f/255.0f green:34.0f/255.0f blue:36.0f/255.0f alpha:1.0f];
    [self.tableView setBackgroundView:backgroundView];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    [self.tableView setSeparatorColor:[UIColor blackColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
   

//    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
//    [header setText:@"Drink+"];
//    [header setTextAlignment:NSTextAlignmentCenter];
//    if (DEVICE_VERSION_7) {
//        [header setFont:[UIFont preferredFontForTextStyle:@"UIFontTextStyleHeadline1"]];
//    } else {
//        [header setFont:[UIFont systemFontOfSize:15.0f]];
//    }
//    
//    header.autoresizingMask = UIViewAutoresizingNone;
//    self.tableView.tableHeaderView = header;
    if (DEVICE_VERSION_7) {
        UIEdgeInsets insets = UIEdgeInsetsMake(64.0f, 0, 100.0f, 0);
        self.tableView.contentInset = insets;
    }
    UIView *footer = [[UIView alloc] init];
    self.tableView.tableFooterView = footer;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LeftDrawerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.textLabel setFont:[HMUtility appFontOfSize:14.0f]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        cell.backgroundColor = [UIColor colorWithRed:30.0f/255.0f green:34.0f/255.0f blue:36.0f/255.0f alpha:1.0f];
    }
    // Configure the cell...
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Home";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Account";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"Category";
    } else {
        cell.textLabel.text = @"Saves";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentIndex == indexPath.row) {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    } else if (indexPath.row == 0) {
        if (!self.recipeFeedViewController) {
            self.recipeFeedViewController = [[HMRecipeFeedViewController alloc] init];
        }
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.recipeFeedViewController];
        if (DEVICE_VERSION_7) {
            navigationController.navigationBar.tintColor = [UIColor whiteColor];
        }
        [self.mm_drawerController setCenterViewController:navigationController withFullCloseAnimation:YES completion:^(BOOL success) {
        }];
        self.currentIndex = 0;
        
    } else if (indexPath.row == 1) {
        if (!self.accountViewController) {
            self.accountViewController = [[HMAccountViewController alloc] initWithUser:[PFUser currentUser]];
        }
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.accountViewController];
        if (DEVICE_VERSION_7) {
            navigationController.navigationBar.tintColor = [UIColor whiteColor];
        }
        [self.mm_drawerController setCenterViewController:navigationController withFullCloseAnimation:YES completion:^(BOOL success) {
        }];
        self.currentIndex = 1;
    } else if (indexPath.row == 2) {
        if (!self.categoryViewController) {
            self.categoryViewController = [[HMCategoryViewController alloc] init];
        }
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.categoryViewController];
        if (DEVICE_VERSION_7) {
            navigationController.navigationBar.tintColor = [UIColor whiteColor];
        }
        [self.mm_drawerController setCenterViewController:navigationController withFullCloseAnimation:YES completion:^(BOOL success) {
        }];
        self.currentIndex = 2;
    } else if (indexPath.row == 3) {
        if (!self.saveViewController) {
            self.saveViewController = [[HMSaveViewController alloc] init];

        }
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.saveViewController];
        if (DEVICE_VERSION_7) {
            navigationController.navigationBar.tintColor = [UIColor whiteColor];
        }
        [self.mm_drawerController setCenterViewController:navigationController withFullCloseAnimation:YES completion:^(BOOL success) {
        }];
        self.currentIndex = 3;
    }
}

@end
