//
//  HMSearchViewController.m
//  homemade
//
//  Created by Guan Guan on 3/17/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMSearchViewController.h"

@interface HMSearchViewController ()

@end

@implementation HMSearchViewController

@synthesize searchController;

- (void)viewDidLoad
{
    [super viewDidLoad];

//    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
//    [self.view addSubview:self.tableView];
    NSLog(@"%@", self.searchDisplayController);
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 44)];
    self.searchBar.userInteractionEnabled = YES;
    self.searchBar.showsCancelButton = NO;
//    self.searchBar.delegate = self;
    
    
    
    self.tableView.tableHeaderView = self.searchBar;
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.delegate = self;
    self.searchController.searchResultsTableView.delegate = self;
    
    if (DEVICE_VERSION_7) {
        self.searchController.displaysSearchBarInNavigationBar = NO;
    }
            
//    for (UIView *possibleButton in self.searchBar.subviews)
//    {
//        if ([possibleButton isKindOfClass:[UIButton class]])
//        {
//            UIButton *cancelButton = (UIButton*)possibleButton;
//            cancelButton.enabled = YES;
//            break;
//        }
//    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
     NSLog(@"unload view");
    [super viewDidUnload];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"disappear");
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    
    self.searchController.searchResultsTableView.delegate = nil;
    self.searchController.delegate = nil;
    self.searchController.searchResultsDelegate = nil;
    self.searchController.searchResultsDataSource = nil;
    self.searchController = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
//{
//    // DO ur operations
//    NSLog(@"Canceled");
////    [searchBar resignFirstResponder];
//}
//




@end
