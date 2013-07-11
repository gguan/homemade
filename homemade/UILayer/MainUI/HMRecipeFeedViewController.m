//
//  HMRecipeFeedViewController.m
//  homemade
//
//  Created by Guan Guan on 4/17/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMAppDelegate.h"
#import "HMRecipeFeedViewController.h"
#import "HMRecipeViewController.h"
#import "SVPullToRefresh.h"
#import <QuartzCore/QuartzCore.h>
#import "SLColorArt.h"
#import "TMCache.h"
#import "HMSearchViewController.h"
#import "UIImageView+Addition.h"
#import "HMCommentViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "HMCreateViewController.h"
#import "UIImage+ColorArt.h"


@interface HMRecipeFeedViewController ()
@end

@implementation HMRecipeFeedViewController {
    AwesomeMenu *menu;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        // The className to query on
        self.parseClassName = kHMRecipeClassKey;
        
        // Whether the built-in pull-to-refresh is enabled, we manuall add it
        self.pullToRefreshEnabled = NO;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;

    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:246.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:1.0f]];
    
    [self.tableView setSeparatorColor:[UIColor clearColor]];

    // Setup navigation bar
    [self.navigationItem setTitle:@"Drink+"];

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn-list.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftDrawerButtonClicked)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn-search.png"] style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonClicked)];
    [self.navigationItem setRightBarButtonItem:searchItem];
    
    // Customize loading view
    UIView *loadingView = (UIView *)[self.view.subviews objectAtIndex:0];
    for (UIView *view in loadingView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            label.font = [HMUtility appFontOfSize:15.0f];
            label.textColor = [UIColor darkGrayColor];
            label.backgroundColor = [UIColor clearColor];
            label.shadowOffset = CGSizeMake(0, 0);
        }
    }
        
    // add Path style menu
    UIImage *itemImg1 = [UIImage imageNamed:@"searchMag.png"];
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
    menu = [[AwesomeMenu alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [HMUtility screenHeight]) menus:menus];
    NSLog(@"%f %f %@", [HMUtility screenHeight], self.view.frame.size.height, NSStringFromCGRect(self.tableView.frame));
	// customize menu
	menu.rotateAngle = 0;
	menu.menuWholeAngle = M_PI;
	menu.timeOffset = 0.1f;
	menu.farRadius = 61.0f;
	menu.endRadius = 60.0f;
	menu.nearRadius = 58.0f;
    if (DEVICE_VERSION_7) {
        menu.startPoint = CGPointMake(160.0, self.view.frame.size.height + 20);
    } else {
        menu.startPoint = CGPointMake(160.0, self.view.frame.size.height - 44);
    }
    menu.delegate = self;
    [self.view addSubview:menu];

    __weak HMRecipeFeedViewController *weakSelf = self;
    // add pull to refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf loadObjects];
            [weakSelf.tableView.pullToRefreshView stopAnimating];
        });
    }];
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf loadNextPage];
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
        });
    }];
}

- (void) dealloc {
    NSLog(@"FeedView dealloc");
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
    return 280.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMRecipeCellView *cell = (HMRecipeCellView *)[tableView cellForRowAtIndexPath:indexPath];
    
    HMRecipeViewController *recipeViewController = [[HMRecipeViewController alloc] initWithRecipe:[self.objects objectAtIndex:indexPath.row] andUIColor:cell.colorArt];
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
    if (indexPath.row < self.objects.count) {
        return [self.objects objectAtIndex:indexPath.row];
    }
    
    return nil;
}


- (PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)recipe {
    
    static NSString *CellIdentifier = @"DrinkRecipeCell";
    
    HMRecipeCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HMRecipeCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [self resetCell:cell];
    cell.tag = indexPath.row;
    cell.saveIcon.tag = indexPath.row;
    
    if (recipe) {
        // Configure the cell
        [cell setRecipe:recipe];
        
        NSDictionary *attributesForRecipe = [[HMCache sharedCache] attributesForRecipe:recipe];
        
        if (attributesForRecipe) {
            NSLog(@"Find cache for recipe %@", recipe.objectId);
            NSLog(@"%@", attributesForRecipe);
            [cell.saveCount setText:[[[HMCache sharedCache] saveCountForRecipe:recipe] description]];
            [cell.photoCount setText:[[[HMCache sharedCache] photoCountForRecipe:recipe] description]];
            [cell setSaveStatus:[[HMCache sharedCache] isSavedByCurrentUser:recipe]];
        } else {
            NSLog(@"Didn't find cache for recipe %@", recipe.objectId);
            @synchronized(self) {
                // query and cache save data on this recipe
                PFQuery *saveQuery = [HMUtility queryForSavesOnRecipe:recipe cachePolicy:kPFCachePolicyNetworkOnly];
                [saveQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    @synchronized(self) {
                        if (error) {
                            return;
                        }
                        BOOL isSavedByCurrentUser = NO;
                        for (PFObject *save in objects) {
                            if ([[[save objectForKey:kHMSaveFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                                isSavedByCurrentUser = YES;
                                break;
                            }
                        }
                        // cache count
                        [[HMCache sharedCache] setSaveCountForRecipe:recipe count:[objects count]];
                        [[HMCache sharedCache] setRecipeIsSavedByCurrentUser:recipe saved:isSavedByCurrentUser];
                    
                        [cell.saveCount setText:[[NSNumber numberWithInt:[objects count]] description]];
                        [cell setSaveStatus:isSavedByCurrentUser];
                    }
                }];
                
                PFQuery *photoQuery = [HMUtility queryForPhotosOnRecipe:recipe cachePolicy:kPFCachePolicyNetworkOnly];
                [photoQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                    @synchronized(self) {
                        if (error) {
                            return;
                        }
                        // cache photo count
                        [[HMCache sharedCache] setPhotoCountForRecipe:recipe count:number];
                        [cell.photoCount setText:[[NSNumber numberWithInt:number] description]];
                    }
                }];
            }
        }
        
        // If photo is in memory, load it right away
        if (cell.photo.file.isDataAvailable) {
            
            [cell.photo loadInBackground:^(UIImage *image, NSError *error){
                if (image) {
                    UIColor *colorArt = [[TMCache sharedCache] objectForKey:[NSString stringWithFormat: @"%@%@", cell.photo.file.name, kHMColorSuffixKey]];
                    
                    if (colorArt) {
                        NSLog(@"Find colorArt from cache %@", colorArt);
                        cell.colorArt = colorArt;
                        [cell.colorLine setBackgroundColor:colorArt];
                    } else {
                        NSLog(@"Didn't find colorArt from cache, compute in background");
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            NSString *colorCacheKey = cell.photo.file.name;
                            UIColor *colorArt = [image colorArtInRect:CGRectMake(image.size.width/2-50, image.size.height/2-50, 100, image.size.height/2+50)].primaryColor;
                            
                            [[TMCache sharedCache] setObject:colorArt forKey:[NSString stringWithFormat: @"%@%@", colorCacheKey, kHMColorSuffixKey]];
                            dispatch_async( dispatch_get_main_queue(), ^{
                                cell.colorArt = colorArt;
                                [cell.colorLine setBackgroundColor:colorArt];
                            });
                        });
                    }
                    [cell.photo addDetailShow];
                }
                if (error) {
                    NSLog(@"Error!");
                }
            }];
        } else {
            [cell.photo.file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (data) {
                    NSString *colorCacheKey = [NSString stringWithFormat:@"color_%@",cell.photo.file.name];
                    UIImage *image = [UIImage imageWithData:data];
                    cell.photo.alpha = 0.0f;
                    [UIView animateWithDuration:0.3
                                     animations:^{
                                         [cell.photo setImage: image];
                                         cell.photo.alpha = 1.0f;
                                         
                                     } completion:^(BOOL finished) { }];
                    
                    UIColor *colorArt = [image colorArtInRect:CGRectMake(image.size.width/2-50, image.size.height/2-50, 100, image.size.height/2+50)].primaryColor;
                    cell.colorArt = colorArt;
                    [cell.colorLine setBackgroundColor:colorArt];

                    [[TMCache sharedCache] setObject:colorArt forKey:colorCacheKey];
                    [cell.photo addDetailShow];     
                }
            }];            
        } // if isDataAvailable end
        
    } // if object end
    
    return cell;
}


#pragma mark - AwesomeMenu
- (void)AwesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    NSLog(@"Select the index : %d",idx);
    if (idx == 0) {
        HMCreateViewController *createViewController = [[HMCreateViewController alloc] initWithStyle:UITableViewStylePlain];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:createViewController];
        
        
        [self presentViewController:navigationController animated:YES completion:^{
            
        }];
    } else if (idx == 3) {
        [(HMAppDelegate*)[[UIApplication sharedApplication] delegate] logout];
    }
}
- (void)AwesomeMenuDidFinishAnimationClose:(AwesomeMenu *)menu {
    NSLog(@"Menu was closed!");
}
- (void)AwesomeMenuDidFinishAnimationOpen:(AwesomeMenu *)menu {
    NSLog(@"Menu is open!");
}

#pragma mark - Scroll delegate

// Need keep menu button fix position on the view
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect fixedFrame = self.view.frame;
    
    fixedFrame.origin.y = scrollView.contentOffset.y;
    menu.frame = fixedFrame;
}

#pragma mark - ()

// when reuse table view cell, do some clean up and reset cell
- (void)resetCell:(HMRecipeCellView *)cell {
    
    // Placeholder image
    [cell.photo setImage:nil];
    // Move photo back to left
    // Clear color line
    [cell.colorLine setBackgroundColor:[UIColor clearColor]];
    // Clear text
    [cell.saveCount setText:@"0"];
    [cell.photoCount setText:@"0"];
    
}

- (void)leftDrawerButtonClicked {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)searchButtonClicked {
    HMSearchViewController *searchViewController = [[HMSearchViewController alloc] init];
    [[self navigationController] pushViewController:searchViewController animated:YES];
}

@end
