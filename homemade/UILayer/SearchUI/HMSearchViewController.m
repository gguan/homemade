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

@implementation HMSearchViewController {
    BOOL isSearching;
}

@synthesize searchController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isSearching = NO;
    
    self.searchResults = [NSMutableArray array];

    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 44)];
    self.searchBar.userInteractionEnabled = YES;
    self.searchBar.showsCancelButton = NO;
    self.searchBar.delegate = self;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    PFObject *object = [self.searchResults objectAtIndex:indexPath.row];
    NSString *title = [object objectForKey:kHMRecipeTitleKey];
    [cell.textLabel setText:title];
    
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

- (void)filterResults:(NSString *)searchTerm {
    NSString *trimmedTerm = [searchTerm stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (trimmedTerm.length == 0) {
        return;
    }
    [self.searchResults removeAllObjects];
    
    NSLog(@"Do search");
    
    PFQuery *query = [PFQuery queryWithClassName:kHMRecipeClassKey];
    [query whereKey:kHMRecipeTitleKey containsString:trimmedTerm];
    isSearching = YES;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self.searchResults addObjectsFromArray:objects];
            [self.searchController.searchResultsTableView reloadData];
        }
    }];
    
    isSearching = NO;
    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    if (isSearching == NO) {
//        [self filterResults:searchString];
    }
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%i", isSearching);
    if (isSearching == NO) {
        NSString *searchString = [NSString stringWithString:searchBar.text];
        [self filterResults:searchString];
        NSLog(@"search %@", searchString);

    }
    NSLog(@"search clicked!");
    
}

@end
