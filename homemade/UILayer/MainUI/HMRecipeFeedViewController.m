//
//  HMRecipeFeedViewController.m
//  homemade
//
//  Created by Guan Guan on 4/17/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMRecipeFeedViewController.h"
#import "HMFeedStreamViewCell.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface HMRecipeFeedViewController ()
@property (nonatomic, assign) BOOL shouldReloadOnAppear;
@end

@implementation HMRecipeFeedViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        
        // The className to query on
        self.parseClassName = kHMRecipeClassKey;
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
        
        self.shouldReloadOnAppear = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"Homemade";
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    [self.tableView addGestureRecognizer:revealController.panGestureRecognizer];
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
    
    // Right bar button
    UIImageView *btnImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
    [btnImage setImage:[UIImage imageNamed:@"icons_search.png"]];
    btnImage.alpha = 0.6f;
    btnImage.layer.shadowColor = [UIColor whiteColor].CGColor;
    btnImage.layer.shadowOffset = CGSizeMake(0.0, -1.0);
    btnImage.contentMode = UIViewContentModeScaleAspectFit;
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0.0f, 12.0f, 32.0f, 20.0f);
    [rightButton addSubview:btnImage];
    [rightButton addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightBarButton];

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.objects count];
}

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 320.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //For testing, point to the same HMRecipeViewController,add properties later
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyNetworkElseCache;
    }
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    // overridden, since we want to implement sections
    if (indexPath.row < self.objects.count) {
        return [self.objects objectAtIndex:indexPath.row];
    }
    
    return nil;
}


- (PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"RecipeCell";
    
    HMFeedStreamViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HMFeedStreamViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    cell.nameLabel.text = [object objectForKey:@"title"];
    cell.descLabel.text = [object objectForKey:@"overview"];;
    
    
    if (object) {
        cell.photo.file = [object objectForKey:kHMRecipePhotoKey];
        
        // PFQTVC will take care of asynchronously downloading files, but will only load them when the tableview is not moving. If the data is there, let's load it right away.
        if (cell.photo.file.isDataAvailable) {
            [cell.photo loadInBackground:^(UIImage *image, NSError *error){
                if (error) {
                    NSLog(@"Error!");
                }
            }];
        }
    }
    

    [cell.contentView bringSubviewToFront:cell.imageView];
    
    
    return cell;
}


@end
