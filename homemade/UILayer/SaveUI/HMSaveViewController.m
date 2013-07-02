//
//  HMSaveViewController.m
//  homemade
//
//  Created by Guan Guan on 3/17/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMSaveViewController.h"
#import "UIViewController+MMDrawerController.h"
#import <QuartzCore/QuartzCore.h>
#import "HMSearchCell.h"

@interface HMSaveViewController ()

@end

@implementation HMSaveViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        // The className to query on
        self.parseClassName = kHMSaveClassKey;
        
        // Whether the built-in pull-to-refresh is enabled, we manuall add it
        self.pullToRefreshEnabled = NO;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 15;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"DRINK+"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn-list.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftDrawerButtonClicked)];
    [self.navigationItem setLeftBarButtonItem:leftItem];    
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
    return self.objects.count;
}

#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyNetworkElseCache;
    }
    [query whereKey:kHMSaveFromUserKey equalTo:[PFUser currentUser]];
    [query includeKey:kHMSaveRecipeKey];
    [query orderByDescending:@"createdAt"];
    
    query.maxCacheAge = 60 * 60 * 24;
    
    return query;
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        return [self.objects objectAtIndex:indexPath.row];
    }
    
    return nil;
}

- (PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)save {
    
    static NSString *CellIdentifier = @"SaveCell";
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    PFObject *drink = [save objectForKey:kHMSaveRecipeKey];
    NSString *title = [drink objectForKey:kHMRecipeTitleKey];
    NSString *description = [drink objectForKey:kHMRecipeOverviewKey];
    PFFile *image = [drink objectForKey:kHMRecipePhotoKey];
    cell.textLabel.text = title;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.clipsToBounds = YES;
    [cell.imageView setFile:image];
    [cell.imageView loadInBackground];
    cell.detailTextLabel.text = description;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
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

#pragma mark -

- (void)leftDrawerButtonClicked {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end
