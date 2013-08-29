//
//  HMLeftPanelViewController.m
//  homemade
//
//  Created by Guan Guan on 6/14/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMLeftPanelViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "HMCreateViewController.h"


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
    backgroundView.backgroundColor = [UIColor colorWithRed:39.0f/255.0f green:44.0f/255.0f blue:46.0f/255.0f alpha:1.0f];
    [self.tableView setBackgroundView:backgroundView];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
   
    [self.tableView setBounces:NO];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu-logo.png"]];
    [header addSubview:logo];
    self.tableView.tableHeaderView = header;

    UIEdgeInsets insets = UIEdgeInsetsMake(65.0f, 0, 100.0f, 0);
    self.tableView.contentInset = insets;

    UIView *footer = [[UIView alloc] init];
    self.tableView.tableFooterView = footer;
    
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [postButton setFrame:CGRectMake(90, [HMUtility screenHeight] - 160, 60, 60)];
    [postButton setBackgroundImage:[UIImage imageNamed:@"menu-post-btn.png"] forState:UIControlStateNormal];
    [postButton addTarget:self action:@selector(postButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:postButton];
    
    
    UILabel *comment = [[UILabel alloc] initWithFrame:CGRectMake(0, [HMUtility screenHeight] - 90, 240, 10)];
    [comment setBackgroundColor:[UIColor clearColor]];
    [comment setText:@"Share your drink recipe"];
    [comment setBackgroundColor:[UIColor clearColor]];
    [comment setFont:[UIFont systemFontOfSize:11.0f]];
    [comment setTextColor:[UIColor colorWithRed:19.0f/255.0f green:24.0f/255.0f blue:26.0f/255.0f alpha:1.0f]];
    [comment setTextAlignment:NSTextAlignmentCenter];
    [self.tableView addSubview:comment];
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
    
    UIImageView *menuItem;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:20.0/255 green:23.0/255 blue:24.0/255 alpha:0.9];
        [cell setSelectedBackgroundView:bgColorView];
        
        menuItem = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 39)];
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(200, 2, 9, 36)];
        [arrow setImage:[UIImage imageNamed:@"menu-arrow.png"]];
        UIImageView *divider = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, 320, 2)];
        [divider setImage:[UIImage imageNamed:@"menu-divider.png"]];
        [cell addSubview:menuItem];
        [cell addSubview:arrow];
        [cell addSubview:divider];
    }
    // Configure the cell...
    if (indexPath.row == 0) {
        [menuItem setImage:[UIImage imageNamed:@"menu-home.png"]];
    } else if (indexPath.row == 1) {
        [menuItem setImage:[UIImage imageNamed:@"menu-account.png"]];
    } else if (indexPath.row == 2) {
        [menuItem setImage:[UIImage imageNamed:@"menu-category.png"]];
    } else {
        [menuItem setImage:[UIImage imageNamed:@"menu-save.png"]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 41.0f;
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

- (void)postButtonClicked {
    HMCreateViewController *createViewController = [[HMCreateViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:createViewController];
    [self presentViewController:navController animated:YES completion:^{
    }];
}

@end
