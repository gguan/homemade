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
    NSString *title = @"B52轰炸机";
    NSString *overview = @"来自上海西藏大厦万怡酒店MOMO CAFE张俊的大厨食谱：烈焰般刺激的伏加特在欧美国家是最受男士欢迎的烈酒之一。伏加特作为最纯净的烈酒，由于酒中所含杂质极少，口感纯净，并且可以以任何浓度与其它饮料混合饮用，所以经常用于做鸡尾酒的基酒。这款层次分明的shot适合口味厚重的人士。将鸡尾酒一口闷下，酒精一路从咽喉灼烧到胃部，如轰炸机般猛烈。但回味后，胃部暖暖的，奶油和巧克力的香甜在口腔中回味，很特别。";
    UIImage *photo = [UIImage imageNamed:@"0.jpg"];
    NSData *photoData = UIImageJPEGRepresentation(photo, 1.0f);
    PFFile *photoFile = [PFFile fileWithData:photoData];
    
    NSArray *ingredients = @[@{@"name": @"甘露咖啡力娇酒", @"amount": @"45ml"}, @{@"name": @"百利甜酒", @"amount": @"45ml"}, @{@"name": @"苏联红牌伏特加酒", @"amount": @"45ml"}, @{@"name": @"惯奶油", @"amount": @"适量"}, @{@"name": @"肉桂粉", @"amount": @"适量"}
                             ];
    
    
    UIImage *img1 = [UIImage imageNamed:@"1.jpg"];
    NSData *imgData1 = UIImageJPEGRepresentation(img1, 1.0f);
    PFFile *imgFile1 = [PFFile fileWithData:imgData1];
    UIImage *img2 = [UIImage imageNamed:@"2.jpg"];
    NSData *imgData2 = UIImageJPEGRepresentation(img2, 1.0f);
    PFFile *imgFile2 = [PFFile fileWithData:imgData2];
    UIImage *img3 = [UIImage imageNamed:@"3.jpg"];
    NSData *imgData3 = UIImageJPEGRepresentation(img3, 1.0f);
    PFFile *imgFile3 = [PFFile fileWithData:imgData3];
    UIImage *img4 = [UIImage imageNamed:@"4.jpg"];
    NSData *imgData4 = UIImageJPEGRepresentation(img4, 1.0f);
    PFFile *imgFile4 = [PFFile fileWithData:imgData4];
    UIImage *img5 = [UIImage imageNamed:@"5.jpg"];
    NSData *imgData5 = UIImageJPEGRepresentation(img5, 1.0f);
    PFFile *imgFile5 = [PFFile fileWithData:imgData5];
//    UIImage *img6 = [UIImage imageNamed:@"6.jpg"];
//    NSData *imgData6 = UIImageJPEGRepresentation(img6, 1.0f);
//    PFFile *imgFile6 = [PFFile fileWithData:imgData6];
//    UIImage *img7 = [UIImage imageNamed:@"7.jpg"];
//    NSData *imgData7 = UIImageJPEGRepresentation(img7, 1.0f);
//    PFFile *imgFile7 = [PFFile fileWithData:imgData7];
//  
    
    
    
    NSArray *steps = @[
                       @{@"content":@"用冰块洗玻璃杯。", @"photo":imgFile1},
                       @{@"content":@"玻璃杯里加入45ml甘露咖啡力娇酒，45ml百利甜酒，45ml苏联红牌伏特加酒。", @"photo":imgFile2},
                       @{@"content":@"慢慢的浇上惯奶油，撒上肉桂粉即可。", @"photo":imgFile3}
//                       @{@"content":@"然后把芒果肉淋在冰沙上即可。", @"photo":imgFile4},
//                       @{@"content":@"赶紧来一杯吧。", @"photo":imgFile5}
//                       @{@"content":@"取柠檬片，挤去柠檬皮上的油脂，放入酒中即可。", @"photo":imgFile6}
//                       @{@"content":@"最后装饰薄荷叶和新鲜的西柚片，华丽丽的夏日冰爽粉红比基尼就做好了！好诱惑捏！", @"photo":imgFile7}
                       ];
    
    NSNumber *difficulty = [NSNumber numberWithInt:1];
    
    
    NSArray *tips = @[
                      @"加酒的时候不能快，要用一把勺子引导，慢慢加，否则层次会混乱。",
                      @"如果口味重的可以不加惯奶油和肉桂粉。"
//                      @"冰块和天气的温度不同，都会使伏特加马天尼有不同的口感。"
//                      @"喜欢的话还可用橄榄做为装饰。"
                      ];
    
    PFObject *recipe = [PFObject objectWithClassName:@"Recipe"];
    [recipe setObject:[PFUser currentUser] forKey:@"user"];
    [recipe setObject:title forKey:@"title"];
    [recipe setObject:overview forKey:@"overview"];
    [recipe setObject:photoFile forKey:@"photo"];
    [recipe setObject:difficulty forKey:@"difficulty"];
    [recipe setObject:ingredients forKey:@"ingredients"];
    [recipe setObject:steps forKey:@"steps"];
    [recipe setObject:tips forKey:@"tips"];
    [recipe setObject:[HMUtility getPreferredLanguage] forKey:kHMRecipeLanguageKey];
    [recipe setObject:[NSNumber numberWithBool:NO] forKey:kHMRecipeRecommandKey];
    [recipe setObject:@[@"APERITIFS",@"BAILEYS"] forKey:kHMRecipeCategoryKey];
    
    // Photos are public, but may only be modified by the user who uploaded them
    PFACL *recipeACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [recipeACL setPublicReadAccess:YES];
    [recipeACL setWriteAccess:YES forRoleWithName:@"Admin"];    // Admin can edit recipe
    recipe.ACL = recipeACL;
    
    
    [recipe saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"Saved!");
    }];
}

- (void)logout {
    [self dismissViewControllerAnimated:NO completion:^{
        [(HMAppDelegate*)[[UIApplication sharedApplication] delegate] logout];
    }];
}

@end
