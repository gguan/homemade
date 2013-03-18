//
//  HMMenuViewController.m
//  homemade
//
//  Created by Guan Guan on 3/16/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMMenuViewController.h"
#import "LeftPanelCell.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import "HMFeedStreamViewController.h"
#import "HMSaveViewController.h"
#import "HMAccountViewController.h"
#import "HMSettingViewController.h"

@interface HMMenuViewController ()


@end

@implementation HMMenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        //Add background color to bounce area
        UIView *topview = [[UIView alloc] initWithFrame:CGRectMake(0,-480,320,480)];
        topview.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:57.0/255.0 blue:59.0/255.0 alpha:1.0];
        [self.tableView addSubview:topview];
//        self.tableView.bounces = NO; //Disable bounce
        
        [self.tableView setSeparatorColor:[UIColor blackColor]];

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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCellItem";
    LeftPanelCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[LeftPanelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    

    switch ([indexPath row]) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"icon_cloud.png"];
            cell.textLabel.text = @"Today";
            break;
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"icon_heart.png"];
            cell.textLabel.text = @"Save";
            break;
        case 2:
            cell.imageView.image = [UIImage imageNamed:@"icon_date.png"];
            cell.textLabel.text = @"Done";
            break;
        case 3:
            cell.imageView.image = [UIImage imageNamed:@"icon_setting.png"];
            cell.textLabel.text = @"Setting";
            break;
//        case 4:
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            break;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
            return 45;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//        if ([[UIScreen mainScreen] bounds].size.height == 568) //4 inch screen
//            return 280+88;
//        else //3.5 inch screen
//            return 280;
    if(section == 0)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 568) //4 inch screen
            return 280+88;
        else //3.5 inch screen
            return 280;
    }
    else
        return 0;
}

-(UIView *) tableView:(UITableView *)tableView
viewForFooterInSection:(NSInteger)section
{
    int height;
    if ([[UIScreen mainScreen] bounds].size.height == 568) //4 inch screen
        height = 280+88;
    else //3.5 inch screen
        height = 280;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(200, 0, 320, height)];
    footerView.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:57.0/255.0 blue:59.0/255.0 alpha:1.0];
    
    UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,200 + 2* height)];
    bottomview.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:57.0/255.0 blue:59.0/255.0 alpha:1.0];
    [footerView addSubview:bottomview];

    
    self.tableView.tableFooterView = footerView;
    return footerView;
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
    
    switch ([indexPath row]) {
        case 0:
            if (self.sidePanelController.centerPanel == self.feedStreamViewController) {
                [self.sidePanelController showCenterPanelAnimated:YES];
                return;
            }
            if (self.feedStreamViewController == nil) {
                UINavigationController *centerNavController = [[UINavigationController alloc] initWithRootViewController: [[HMFeedStreamViewController alloc] init]];
                UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(toggleRightPanel:)];
                UIViewController *buttonController = [centerNavController.viewControllers objectAtIndex:0];
                if (!buttonController.navigationItem.rightBarButtonItem) {
                    buttonController.navigationItem.rightBarButtonItem = rightBarButton;
                }
                self.feedStreamViewController = centerNavController;
                self.sidePanelController.centerPanel = centerNavController;
            } else {
                self.sidePanelController.centerPanel = self.feedStreamViewController;
            }
            break;
        case 1:
            if (self.sidePanelController.centerPanel == self.saveViewController) {
                [self.sidePanelController showCenterPanelAnimated:YES];
                return;
            }
            if (self.saveViewController == nil) {
                UINavigationController *centerNavController = [[UINavigationController alloc] initWithRootViewController: [[HMSaveViewController alloc] init]];
                UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(toggleRightPanel:)];
                UIViewController *buttonController = [centerNavController.viewControllers objectAtIndex:0];
                if (!buttonController.navigationItem.rightBarButtonItem) {
                    buttonController.navigationItem.rightBarButtonItem = rightBarButton;
                }
                self.saveViewController = centerNavController;
                self.sidePanelController.centerPanel = centerNavController;
            } else {
                self.sidePanelController.centerPanel = self.saveViewController;
            }
            break;
        case 2:
            if (self.sidePanelController.centerPanel == self.accountViewController) {
                [self.sidePanelController showCenterPanelAnimated:YES];
                return;
            }
            if (self.accountViewController == nil) {
                UINavigationController *centerNavController = [[UINavigationController alloc] initWithRootViewController: [[HMAccountViewController alloc] init]];
                self.accountViewController = centerNavController;
                self.sidePanelController.centerPanel = centerNavController;
            } else {
                self.sidePanelController.centerPanel = self.accountViewController;
            }
            break;
        case 3:
            if (self.sidePanelController.centerPanel == self.settingViewController) {
                [self.sidePanelController showCenterPanelAnimated:YES];
                return;
            }
            if (self.settingViewController == nil) {
                UINavigationController *centerNavController = [[UINavigationController alloc] initWithRootViewController: [[HMSettingViewController alloc] init]];
                self.settingViewController = centerNavController;
                self.sidePanelController.centerPanel = centerNavController;
            } else {
                self.sidePanelController.centerPanel = self.settingViewController;
            }
            break;
        default:
            break;
    }
}



@end
