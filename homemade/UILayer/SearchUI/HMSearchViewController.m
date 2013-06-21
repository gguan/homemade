//
//  HMSearchViewController.m
//  homemade
//
//  Created by Guan Guan on 3/17/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMSearchViewController.h"
#import "SVPullToRefresh.h"
#import "HMSearchCell.h"

#define QueryLimit 2

@interface HMSearchViewController ()

@end

@implementation HMSearchViewController {
    BOOL isSearching;
    NSInteger page;
    NSString *searchTerm;
}

@synthesize searchController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isSearching = NO;
    page = 0;
    searchTerm = nil;
    
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
    
    // Infinite scroll and pagination
    __weak HMSearchViewController *weakSelf = self;
    [self.searchController.searchResultsTableView addInfiniteScrollingWithActionHandler:^{
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf loadNextPage];
            [weakSelf.searchController.searchResultsTableView.infiniteScrollingView stopAnimating];
        });
    }];
    
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
    HMSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[HMSearchCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    PFObject *object = [self.searchResults objectAtIndex:indexPath.row];
    NSString *title = [object objectForKey:kHMRecipeTitleKey];
    NSString *description = [object objectForKey:kHMRecipeOverviewKey];
    
    PFFile *imageFile = [object objectForKey:kHMRecipePhotoKey];
    [cell.photoView setFile:imageFile];
    [cell.photoView loadInBackground];
    [cell.nameLabel setText:title];
    [cell.descriptionLabel setText:description];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 106.0f;
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

- (void)filterResults:(NSString *)searchText {
    NSString *trimmedTerm = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (trimmedTerm.length == 0) {
        return;
    }
    [self.searchResults removeAllObjects];
    
    NSLog(@"Do search");
    
    PFQuery *query = [PFQuery queryWithClassName:kHMRecipeClassKey];
    [query whereKey:kHMRecipeTitleKey containsString:trimmedTerm];
    query.limit = QueryLimit;
    isSearching = YES;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self.searchResults addObjectsFromArray:objects];
            [self.searchController.searchResultsTableView reloadData];
            page = 1;
            searchTerm = [NSString stringWithString:searchText];
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

#pragma mark -

- (void)loadNextPage {
    if (isSearching) {
        return;
    }
    NSLog(@"Load next page");
    if ([self.searchBar.text isEqualToString:searchTerm]) {
        NSString *trimmedTerm = [searchTerm stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (trimmedTerm.length == 0) {
            return;
        }
        
        PFQuery *query = [PFQuery queryWithClassName:kHMRecipeClassKey];
        [query whereKey:kHMRecipeTitleKey containsString:trimmedTerm];
        query.limit = QueryLimit;
        query.skip = QueryLimit * page;
        isSearching = YES;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                [self.searchResults addObjectsFromArray:objects];
                [self.searchController.searchResultsTableView reloadData];
                page += 1;
            }
        }];
        
        isSearching = NO;
    }
}

@end
