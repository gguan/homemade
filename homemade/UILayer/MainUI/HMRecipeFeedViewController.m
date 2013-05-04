//
//  HMRecipeFeedViewController.m
//  homemade
//
//  Created by Guan Guan on 4/17/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMRecipeFeedViewController.h"
#import "HMRecipeViewController.h"
#import "SVPullToRefresh.h"
#import <QuartzCore/QuartzCore.h>
#import "SLColorArt.h"
#import "TMCache.h"
#import "HMCommonUIUtility.h"


@interface HMRecipeFeedViewController ()
@property (nonatomic, assign) BOOL shouldReloadOnAppear;
@end

@implementation HMRecipeFeedViewController {
    AwesomeMenu *menu;
}


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
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    
    // Customize loading view
    UIView *loadingView = (UIView *)[self.view.subviews objectAtIndex:0];
    for (UIView *view in loadingView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor clearColor];
            label.shadowOffset = CGSizeMake(0, 0);
        }
    }
    
    // Customize pullToRefresh view
    UIView *pullToRefreshView = (UIView *)[self.view.subviews objectAtIndex:1];
    [pullToRefreshView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    for (UIView *view in pullToRefreshView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor clearColor];
            label.shadowOffset = CGSizeMake(0, 0);
        }
    }
    
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
    menu = [[AwesomeMenu alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) menus:menus];

	// customize menu
	menu.rotateAngle = 0;
	menu.menuWholeAngle = M_PI;
	menu.timeOffset = 0.1f;
	menu.farRadius = 61.0f;
	menu.endRadius = 60.0f;
	menu.nearRadius = 58.0f;
    menu.startPoint = CGPointMake(160.0, self.view.frame.size.height);
    menu.delegate = self;
    [self. view addSubview:menu];

    
    
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
    return 220.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMRecipeCellView *cell = (HMRecipeCellView *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.leftIsVisible == YES) {
        [cell bounceToLeft:0.2];
    } else {
        //For testing, point to the same HMRecipeViewController,add properties later

        HMRecipeViewController *recipeViewController = [[HMRecipeViewController alloc] initWithRecipe:[self.objects objectAtIndex:indexPath.row]];
      
        [[self navigationController] pushViewController:recipeViewController animated:YES];
    }
}


#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
//    if (![PFUser currentUser]) {
//        [super objectsDidLoad:nil];
//        return nil;
//    }
    
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


- (PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)recipe {
    
    static NSString *CellIdentifier = @"RecipeCell";
    
    HMRecipeCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HMRecipeCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    
    [self resetCell:cell];
    cell.tag = indexPath.row;
    cell.saveButton.tag = indexPath.row;
    
    // TODO
    if (recipe) {
        // Configure the cell
        [cell setRecipe:recipe];
        
        NSDictionary *attributesForRecipe = [[HMCache sharedCache] attributesForRecipe:recipe];
        
        if (attributesForRecipe) {
            NSLog(@"Find cache for recipe %@", recipe.objectId);
            NSLog(@"%@", attributesForRecipe);
            [cell.saveCount setText:[[[HMCache sharedCache] saveCountForRecipe:recipe] description]];
            [cell setSaveStatus:[[HMCache sharedCache] isSavedByCurrentUser:recipe]];
        } else {
            NSLog(@"Didn't find cache for recipe %@", recipe.objectId);
            @synchronized(self) {
                // dictionary hold recipe data
                NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
                
                // query and cache save data on this recipe
                PFQuery *query = [HMUtility queryForSavesOnRecipe:recipe cachePolicy:kPFCachePolicyNetworkOnly];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    
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
                    NSNumber *saveCount = [NSNumber numberWithInt:[objects count]];
                    
                    [attributes setObject:saveCount forKey:kHMRecipeAttributesSaveCountKey];
                    [attributes setObject:[NSNumber numberWithBool:isSavedByCurrentUser] forKey:kHMRecipeAttributesIsSavedByCurrentUserKey];
                    
                    [cell.saveCount setText:[saveCount description]];
                    [cell setSaveStatus:isSavedByCurrentUser];
                }];
                
                // cache recipe data
                [[HMCache sharedCache] setAttributesForRecipe:recipe attributes:attributes];
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
                    
                }
                if (error) {
                    NSLog(@"Error!");
                }
            }];
        } else {
            // Manually download images from parse and set animation
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSData *data = [cell.photo.file getData];
                if(data) {
                    NSString *colorCacheKey = cell.photo.file.name;
                    UIImage *image = [UIImage imageWithData:data];
                    UIColor *colorArt = [image colorArtInRect:CGRectMake(image.size.width/2-50, image.size.height/2-50, 100, image.size.height/2+50)].primaryColor;
                    
                    [[TMCache sharedCache] setObject:colorArt forKey:[NSString stringWithFormat: @"%@%@", colorCacheKey, kHMColorSuffixKey]];
                    dispatch_async( dispatch_get_main_queue(), ^{
                                                
                        // fade in fetched photo
                        [UIView animateWithDuration:0.0
                                         animations:^{
                                             cell.photo.alpha = 0.0f;
                                         }
                                         completion:^(BOOL finished) {
                                             [UIView animateWithDuration:0.3
                                                              animations:^{
                                                                  [cell.photo setImage: image];
                                                                  cell.photo.alpha = 1.0f;
                                                                  cell.colorArt = colorArt;
                                                                  [cell.colorLine setBackgroundColor:colorArt];
                                                              }
                                                              completion:^(BOOL finished) { }];
                                         }];
                        
                    });


                } else {
                    NSLog(@"Error! Failed to download data from parse!");
                }
                
            });
        } // if isDataAvailable end
        
    } // if object end
    
    return cell;
}


#pragma mark - AwesomeMenu
- (void)AwesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    NSLog(@"Select the index : %d",idx);
    if (idx == 3) { // account
        
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
    fixedFrame.origin.y = 0 + scrollView.contentOffset.y;
    menu.frame = fixedFrame;
}

#pragma mark - ()

// when reuse table view cell, do some clean up and reset cell
- (void)resetCell:(HMRecipeCellView *)cell {
    
    // Placeholder image
    [cell.photo setImage:nil];
    // Move photo back to left
    [cell bounceToLeft:0];
    // Clear color line
    [cell.colorLine setBackgroundColor:[UIColor clearColor]];
    // Clear text
    [cell.saveCount setText:@""];
    [cell.commentCount setText:@""];
    
}

#pragma mark - HMRecipeCellView delegate

- (void)recipeTableCellView:(HMRecipeCellView *)recipeTableCellView didTapSaveButton:(UIButton *)button recipe:(PFObject *)recipe {
    NSLog(@"Tap save button! %@", recipe.objectId);
    
    // When user tap the button, we temperaly disable the button until server and cache are updated.
    [recipeTableCellView shouldEnableSaveButton:NO];
    
    BOOL saved = !button.selected;
    [recipeTableCellView setSaveStatus:saved];
    
    NSString *originalSaveCountTitle = recipeTableCellView.saveCount.text;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber *saveCount = [numberFormatter numberFromString:originalSaveCountTitle];
    
    // Update cache
    // TODO
    if (saved) {
        saveCount = [NSNumber numberWithInt:[saveCount intValue] + 1];
        [[HMCache sharedCache] incrementSaverCountForRecipe:recipe];
    } else {
        if ([saveCount intValue] > 0) {
            saveCount = [NSNumber numberWithInt:[saveCount intValue] - 1];
        }
        [[HMCache sharedCache] decrementSaverCountForRecipe:recipe];
    }
    [[HMCache sharedCache] setRecipeIsSavedByCurrentUser:recipe saved:saved];
    
    // update label
    [recipeTableCellView.saveCount setText:[numberFormatter stringFromNumber:saveCount]];
    
    // update sever
    if (saved) {
        [HMUtility saveRecipeInBackground:recipe block:^(BOOL succeeded, NSError *error) {
            [recipeTableCellView shouldEnableSaveButton:YES];
            [recipeTableCellView setSaveStatus:succeeded];
            if (!succeeded) {
                [recipeTableCellView.saveCount setText:originalSaveCountTitle];
            }
        }];
    } else {
        [HMUtility unSaveRecipeInBackground:recipe block:^(BOOL succeeded, NSError *error) {
            [recipeTableCellView shouldEnableSaveButton:YES];
            [recipeTableCellView setSaveStatus:!succeeded];
            if (!succeeded) {
                [recipeTableCellView.saveCount setText:originalSaveCountTitle];
            }
        }];
    }
    
}

/*!
 Sent to the delegate when the share button is tapped
 @param photo the PFObject for the photo that will be commented on
 */
- (void)recipeTableCellView:(HMRecipeCellView *)recipeTableCellView didTapShareButton:(UIButton *)button recipe:(PFObject *)recipe {
    [HMCommonUIUtility showAlert:@"test"];
    
    
    
}


@end
