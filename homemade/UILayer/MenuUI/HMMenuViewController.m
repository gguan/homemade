//
//  HMMenuViewController.m
//  homemade
//
//  Created by Guan Guan on 3/16/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "SWRevealViewController.h"
#import "HMMenuViewController.h"
#import "LeftPanelCell.h"
#import "HMFeedStreamViewController.h"
#import "HMSaveViewController.h"
#import "HMAccountViewController.h"
#import "HMSettingViewController.h"
#import "EDColor.h"
#import <QuartzCore/QuartzCore.h>

@interface HMMenuViewController ()


@end

@implementation HMMenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor colorWithHex:0xEDEBDD];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LeftPanelCellItem";
    LeftPanelCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[LeftPanelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor blueColor];
    }
    
    switch ([indexPath row]) {
        case 0:
            [cell.icon setImage:[UIImage imageNamed:@"icons_1.png"]];
            cell.contentView.backgroundColor = [UIColor colorWithHex:0x3CDDC9];
            break;
        case 1:
            [cell.icon setImage:[UIImage imageNamed:@"icons_2.png"]];
            cell.contentView.backgroundColor = [UIColor colorWithHex:0xFB5755];
            break;
        case 2:
            [cell.icon setImage:[UIImage imageNamed:@"icons_3.png"]];
            cell.contentView.backgroundColor = [UIColor colorWithHex:0x7F4E75];
            break;
        case 3:
            [cell.icon setImage:[UIImage imageNamed:@"icons_4.png"]];
            cell.contentView.backgroundColor = [UIColor colorWithHex:0xD9D3BC];
            break;
        case 4:
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [[cell.subviews objectAtIndex:0] removeFromSuperview]; //remove the arrow view
            break;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 60;
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
    SWRevealViewController *revealController = self.revealViewController;
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;  // <-- we know it is a NavigationController

    NSInteger row = indexPath.row;
    if (row == 0) {
            if ( ![frontNavigationController.topViewController isKindOfClass:[HMFeedStreamViewController class]] ) {
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[HMFeedStreamViewController alloc] init]];
                [revealController setFrontViewController:navigationController animated:YES];
            }
            // Seems the user attempts to 'switch' to exactly the same controller he came from!
            else {
                [revealController revealToggle:self];
            }

    } else if (row == 1) {
            if ( ![frontNavigationController.topViewController isKindOfClass:[HMSaveViewController class]] ) {
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[HMSaveViewController alloc] init]];
                [revealController setFrontViewController:navigationController animated:YES];
            }
            // Seems the user attempts to 'switch' to exactly the same controller he came from!
            else {
                [revealController revealToggle:self];
            }            
    } else if (row == 2) {
            NSLog(@"Click!");
            if ( ![frontNavigationController.topViewController isKindOfClass:[HMAccountViewController class]] ) {
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[HMAccountViewController alloc] init]];
                [revealController setFrontViewController:navigationController animated:YES];
            }
            // Seems the user attempts to 'switch' to exactly the same controller he came from!
            else {
                [revealController revealToggle:self];
            }
    } else if (row == 3) {
            if ( ![frontNavigationController.topViewController isKindOfClass:[HMSettingViewController class]] ) {
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[HMSettingViewController alloc] init]];
                [revealController setFrontViewController:navigationController animated:YES];
            }
            // Seems the user attempts to 'switch' to exactly the same controller he came from!
            else {
                [revealController revealToggle:self];
            }
    }
}



@end
