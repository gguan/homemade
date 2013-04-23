//
//  HMRecipeFeedViewController.m
//  homemade
//
//  Created by Guan Guan on 4/17/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMRecipeFeedViewController.h"
#import "HMRecipeViewController.h"
#import "HMRecipeDetailViewController.h"
#import "HMFeedStreamViewCell.h"
#import "SVPullToRefresh.h"
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
    
    [self.navigationController setNavigationBarHidden:YES];
    
    // add Path style menu
    UIImage *itemImg1 = [UIImage imageNamed:@"myFavorite.png"];
    UIImage *itemImg2 = [UIImage imageNamed:@"WhatIMade.png"];
    UIImage *itemImg3 = [UIImage imageNamed:@"notification.png"];
    UIImage *itemImg4 = [UIImage imageNamed:@"account.png"];
    
    AwesomeMenuItem *starMenuItem1 = [[AwesomeMenuItem alloc] initWithImage:itemImg1
                                                           highlightedImage:itemImg1
                                                               ContentImage:nil
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem2 = [[AwesomeMenuItem alloc] initWithImage:itemImg2
                                                           highlightedImage:itemImg2
                                                               ContentImage:nil
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem3 = [[AwesomeMenuItem alloc] initWithImage:itemImg3
                                                           highlightedImage:itemImg3
                                                               ContentImage:nil
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem4 = [[AwesomeMenuItem alloc] initWithImage:itemImg4
                                                           highlightedImage:itemImg4
                                                               ContentImage:nil
                                                    highlightedContentImage:nil];
    NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, nil];
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) menus:menus];
    NSLog(@"%f", self.view.frame.size.width);
	// customize menu
	menu.rotateAngle = 0;
	menu.menuWholeAngle = M_PI;
	menu.timeOffset = 0.1f;
	menu.farRadius = 46.0f;
	menu.endRadius = 45.0f;
	menu.nearRadius = 43.0f;
    menu.startPoint = CGPointMake(160.0, self.view.frame.size.height - 10);
    menu.delegate = self;
    [self.view addSubview:menu];

    
    
    // setup infinite scrolling
    __weak HMRecipeFeedViewController *weakSelf = self;
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf loadNextPage];
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
        });
    }];


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
    HMRecipeDetailViewController *recipeViewController = [[HMRecipeDetailViewController alloc] init];
    recipeViewController.recipeObject = [self.objects objectAtIndex:indexPath.row];
    [[self navigationController] pushViewController:recipeViewController animated:YES];
    
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


#pragma mark - AwesomeMenu
- (void)AwesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    NSLog(@"Select the index : %d",idx);
}
- (void)AwesomeMenuDidFinishAnimationClose:(AwesomeMenu *)menu {
    NSLog(@"Menu was closed!");
}
- (void)AwesomeMenuDidFinishAnimationOpen:(AwesomeMenu *)menu {
    NSLog(@"Menu is open!");
}


@end
