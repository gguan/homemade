//
//  HMSettingViewController.m
//  homemade
//
//  Created by Guan Guan on 3/18/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMAppDelegate.h"
#import "HMSettingViewController.h"
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
    
    NSString *title = @"Setting";
    [self.navigationItem setTitle:title];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(leftDrawerButtonClicked)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightDrawerButtonClicked)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    UIButton *logoutView = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutView setFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 60)];
    [logoutView setTitle:@"Logout" forState:UIControlStateNormal];
    [logoutView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [logoutView addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = logoutView;
    
//    [self uploadtestingdata];
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

#pragma mark -
- (void)leftDrawerButtonClicked {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)rightDrawerButtonClicked {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}




- (void)uploadtestingdata {
    // test recipe data structure
    NSString *title = @"丰盈科斯塔Busty Crusta";
    NSString *overview = @"来自黄涛的大厨食谱：沾着金巴丽和砂糖的杯口，充满了甜蜜的味道，加上抹茶力娇酒和君度力娇酒的混合，更增加了甜味，朗姆酒的浓重的酒精油然而生，酸酸的柠檬汁又带来第三种美妙的口感。3款甜酒的搭配，各显风姿，甜中带苦。砂糖的装饰，犹如晶莹剔透的钻石，在光照下透着红光，清新的绿色像一袭晚礼服，光泽诱人。";
    UIImage *photo = [UIImage imageNamed:@"p1.jpg"];
    NSData *photoData = UIImageJPEGRepresentation(photo, 1.0f);
    PFFile *photoFile = [PFFile fileWithData:photoData];
    
    NSArray *ingredients = @[@{@"name": @"朗姆酒", @"amount": @"45ml"}, @{@"name": @"金巴丽", @"amount": @"适量"}, @{@"name": @"抹茶力娇酒", @"amount": @"15ml"}, @{@"name": @"法国君度力娇酒", @"amount": @"10-15ml"}, @{@"name": @"柠檬汁", @"amount": @"10ml"}, @{@"name": @"砂糖", @"amount": @"适量"}];
    
    
    UIImage *img1 = [UIImage imageNamed:@"s11.jpg"];
    NSData *imgData1 = UIImageJPEGRepresentation(img1, 1.0f);
    PFFile *imgFile1 = [PFFile fileWithData:imgData1];
    UIImage *img2 = [UIImage imageNamed:@"s12.jpg"];
    NSData *imgData2 = UIImageJPEGRepresentation(img2, 1.0f);
    PFFile *imgFile2 = [PFFile fileWithData:imgData2];
    UIImage *img3 = [UIImage imageNamed:@"s13.jpg"];
    NSData *imgData3 = UIImageJPEGRepresentation(img3, 1.0f);
    PFFile *imgFile3 = [PFFile fileWithData:imgData3];
    UIImage *img4 = [UIImage imageNamed:@"s14.jpg"];
    NSData *imgData4 = UIImageJPEGRepresentation(img4, 1.0f);
    PFFile *imgFile4 = [PFFile fileWithData:imgData4];
    
    
    NSArray *steps = @[
                       @[@"取一酒杯，杯口浸没在金巴丽酒内，再放入砂糖的碗中，使杯口沾满砂糖。", imgFile1],
                       @[@"另取一酒杯，加入45ml朗姆酒，15ml抹茶力娇酒，10-15ml法国君度力娇酒，10ml柠檬汁,放入冰块。", imgFile2],
                       @[@"取杯罩盖住杯子，上下左右充分摇晃均匀。", imgFile3],
                       @[@"将酒倒入沾着砂糖的杯中即可。", imgFile4]
                       ];
    
    NSNumber *difficulty = [NSNumber numberWithInt:1];
    
    
    NSArray *tips = @[@"杯口一定要蘸金巴丽这种甜味的酒，以增加粘度，否则砂糖沾不上去。", @"沾砂糖的时候，不宜过多，多了的话，可以倒过来拍掉一点，否则影响酒的口感。", @"品尝时，要先舔一口砂糖，再喝一口酒。"];
    
    PFObject *recipe = [PFObject objectWithClassName:@"Recipe"];
    [recipe setObject:[PFUser currentUser] forKey:@"user"];
    [recipe setObject:title forKey:@"title"];
    [recipe setObject:overview forKey:@"overview"];
    [recipe setObject:photoFile forKey:@"photo"];
    [recipe setObject:difficulty forKey:@"difficulty"];
    [recipe setObject:ingredients forKey:@"ingredients"];
    [recipe setObject:steps forKey:@"steps"];
    [recipe setObject:tips forKey:@"tips"];
    
    // Photos are public, but may only be modified by the user who uploaded them
    PFACL *recipeACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [recipeACL setPublicReadAccess:YES];
    recipe.ACL = recipeACL;
    
    [recipe save];
}

- (void)logout {
    [self dismissViewControllerAnimated:NO completion:^{
        [(HMAppDelegate*)[[UIApplication sharedApplication] delegate] logout];
    }];
}

@end
