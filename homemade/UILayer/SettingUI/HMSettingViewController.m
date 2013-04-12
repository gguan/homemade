//
//  HMSettingViewController.m
//  homemade
//
//  Created by Guan Guan on 3/18/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMSettingViewController.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface HMSettingViewController ()

@end

@implementation HMSettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    SWRevealViewController *revealController = [self revealViewController];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    
    // Left bar button
    UIImageView *leftBtnImage = [[UIImageView alloc] initWithFrame:CGRectMake(12.0f, 0.0f, 20.0f, 20.0f)];
    [leftBtnImage setImage:[UIImage imageNamed:@"icons_menu.png"]];
    leftBtnImage.alpha = 0.6f;
    leftBtnImage.layer.shadowColor = [UIColor whiteColor].CGColor;
    leftBtnImage.layer.shadowOffset = CGSizeMake(0.0, -1.0);
    leftBtnImage.contentMode = UIViewContentModeScaleAspectFit;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(12.0f, 12.0f, 32.0f, 20.0f);
    [leftButton addSubview:leftBtnImage];
    [leftButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftButtonItem];
    
    
    // test parse
//    NSString *title = @"test recipe";
//    NSArray *arr = @[@"item1", @"item2", @"item3"];
//    NSDictionary *dict = @{@"key1": @"value1", @"key2": @"value2"};
//    PFObject *recipe = [PFObject objectWithClassName:@"RecipeTest"];
//    [recipe setObject:[PFUser currentUser] forKey:@"user"];
//    [recipe setObject:title forKey:@"title"];
//    [recipe setObject:arr forKey:@"strarray"];
//    [recipe setObject:dict forKey:@"dict"];
//    
//    // Photos are public, but may only be modified by the user who uploaded them
//    PFACL *recipeACL = [PFACL ACLWithUser:[PFUser currentUser]];
//    [recipeACL setPublicReadAccess:YES];
//    recipe.ACL = recipeACL;
//    
//    [recipe save];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
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

/*
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
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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

@end
