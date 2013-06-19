//
//  HMCreateViewController.m
//  homemade
//
//  Created by Guan Guan on 6/19/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMCreateViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface HMCreateViewController ()

@property (nonatomic, strong) UITextField *titleField;
@property (nonatomic, strong) PFImageView *coverView;
@property (nonatomic, strong) PFFile *coverImage;
@property (nonatomic, strong) UITextView *descriptionField;

@end

@implementation HMCreateViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
        
        //
        self.titleField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, 280, 30)];
        [self.titleField setPlaceholder:@"add a title"];
        [self.titleField setBorderStyle:UITextBorderStyleRoundedRect];
        [headerView addSubview:self.titleField];
        
        
        self.coverView = [[PFImageView alloc] initWithFrame:CGRectMake(110, 60, 100, 100)];
        self.coverView.layer.borderColor = [UIColor colorWithWhite:0.7f alpha:0.5f].CGColor;
        self.descriptionField.layer.borderWidth = 1.0f;
        UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [coverButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [coverButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [coverButton setFrame:CGRectMake(100, 60, 120, 120)];
        [coverButton setBackgroundColor:[UIColor clearColor]];
        [coverButton setTitle:@"drink picture" forState:UIControlStateNormal];
        coverButton.layer.borderColor = [UIColor colorWithWhite:0.7f alpha:0.5f].CGColor;
        coverButton.layer.borderWidth = 1.0f;
        [headerView addSubview:self.coverView];
        [headerView insertSubview:coverButton aboveSubview:self.coverView];
        
        self.descriptionField = [[UITextView alloc] initWithFrame:CGRectMake( 20.0f, 190.0f, 280.0f, 100.0f)];
        self.descriptionField.font = [UIFont systemFontOfSize:14.0f];
//        self.descriptionField.placeholder = @"add some description to introduce this drink";
        self.descriptionField.returnKeyType = UIReturnKeyDefault;
        self.descriptionField.layer.borderWidth = 1.0f;
        self.descriptionField.layer.borderColor = [UIColor colorWithWhite:0.7f alpha:0.5f].CGColor;
        self.descriptionField.layer.cornerRadius = 4.0f;
        [headerView addSubview:self.descriptionField];

        
        self.tableView.tableHeaderView = headerView;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController setTitle:@"Post a new recipe"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(leftDrawerButtonClicked)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(rightDrawerButtonClicked)];
    [self.navigationItem setRightBarButtonItem:rightItem];

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
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44.0f)];
        [header setText:@"Write steps to make this drink"];
        return header;
    } else if (section == 1) {
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44.0f)];
        [header setText:@"Write ingredients of this drink"];
        return header;

    } else if (section == 2) {
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44.0f)];
        [header setText:@"Write some tips to make drink better"];
        return header;
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CreateTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */


- (void)leftDrawerButtonClicked {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)rightDrawerButtonClicked {
    NSLog(@"Save clicked!");
}

@end
