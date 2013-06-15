//
//  HMLeftPanelViewController.m
//  homemade
//
//  Created by Guan Guan on 6/14/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMLeftPanelViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "HMRecipeFeedViewController.h"
#import "HMAccountViewController.h"
#import "HMSaveViewController.h"

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
    
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];

    [header setText:@"Drink+"];
    [header setTextAlignment:NSTextAlignmentCenter];
    [header setFont:[UIFont preferredFontForTextStyle:@"UIFontTextStyleHeadline1"]];
    self.tableView.tableHeaderView = header;
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
        HMRecipeFeedViewController *centerViewController = [[HMRecipeFeedViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:centerViewController];
//        __weak HMLeftPanelViewController *weakSelf = self;
        [self.mm_drawerController setCenterViewController:navigationController withFullCloseAnimation:YES completion:^(BOOL success) {
            
        }];
        self.currentIndex = 0;
        
    } else if (indexPath.row == 1) {
        HMAccountViewController *accountViewController = [[HMAccountViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:accountViewController];
        [self.mm_drawerController setCenterViewController:navigationController];
        self.currentIndex = 1;
    } else if (indexPath.row == 2) {
        // TODO
    } else if (indexPath.row == 3) {
        HMSaveViewController *saveViewController = [[HMSaveViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:saveViewController];
        [self.mm_drawerController setCenterViewController:navigationController];
        self.currentIndex = 3;
    }
}

@end
