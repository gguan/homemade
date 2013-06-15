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
#import "HMAboutViewController.h"
#import "UIViewController+MMDrawerController.h"


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
    NSLog(@"load main view");
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    
    // Setup navigation bar
    [self.navigationItem setTitle:@"DRINK+"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(leftDrawerButtonClicked)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButtonClicked)];
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
        menu.startPoint = CGPointMake(160.0, self.tableView.frame.size.height + 20.0f);
    } else {
        menu.startPoint = CGPointMake(160.0, self.tableView.frame.size.height);
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
    return 225.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMRecipeCellView *cell = (HMRecipeCellView *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.leftIsVisible == YES) {
        [cell bounceToLeft:0.2];
    } else {
        //For testing, point to the same HMRecipeViewController,add properties later

        HMRecipeViewController *recipeViewController = [[HMRecipeViewController alloc] initWithRecipe:[self.objects objectAtIndex:indexPath.row] andUIColor:cell.colorArt];

        [[self navigationController] pushViewController:recipeViewController animated:YES];
//        HMAboutViewController *recipeViewController = [[HMAboutViewController alloc] initWithRecipe:[self.objects objectAtIndex:indexPath.row]];
//        [[self navigationController] pushViewController:recipeViewController animated:YES];
    }
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
    
    static NSString *CellIdentifier = @"RecipeCell";
    
    HMRecipeCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HMRecipeCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    
    [self resetCell:cell];
    cell.tag = indexPath.row;
    cell.saveButton.tag = indexPath.row;
    
    if (recipe) {
        // Configure the cell
        [cell setRecipe:recipe];
        
        NSDictionary *attributesForRecipe = [[HMCache sharedCache] attributesForRecipe:recipe];
        
        if (attributesForRecipe) {
            NSLog(@"Find cache for recipe %@", recipe.objectId);
            NSLog(@"%@", attributesForRecipe);
            [cell.saveCount setText:[[[HMCache sharedCache] saveCountForRecipe:recipe] description]];
            [cell setSaveStatus:[[HMCache sharedCache] isSavedByCurrentUser:recipe]];
            
            // although we have cache, we still fetch the latest data
            PFQuery *query = [HMUtility queryForSavesOnRecipe:recipe cachePolicy:kPFCachePolicyNetworkOnly];
            [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
                if (error) {
                    return;
                }
                // update label
                [cell.saveCount setText:[NSString stringWithFormat:@"%i", count]];
                // update cache
                NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:attributesForRecipe];
                [attributes setObject:[NSNumber numberWithInt:count] forKey:kHMRecipeAttributesSaveCountKey];
                [[HMCache sharedCache] setAttributesForRecipe:recipe attributes:attributes];
            }];
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
                    [cell.photo addDetailShow];
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
                        [cell.photo addDetailShow];
                        
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
    if (idx == 0) { // search
//        [self presentViewController:[[HMSearchViewController alloc] initWithStyle:UITableViewStylePlain] animated:YES completion:nil];
        HMSearchViewController *searchViewController = [[HMSearchViewController alloc] init];
        [[self navigationController] pushViewController:searchViewController animated:YES];
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
//    if (DEVICE_VERSION_7) {
//        fixedFrame.origin.y += 20;
//    }
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

- (void)recipeTableCellView:(HMRecipeCellView *)recipeTableCellView didTapCommentButton:(UIButton *)button recipe:(PFObject *)recipe {
    HMCommentViewController *commentView = [[HMCommentViewController alloc] initWithPFObject:recipe andType:kHMCommentTypeRecipe];
    [[self navigationController] pushViewController:commentView animated:YES];

    NSLog(@"Comment button tapped.");
}

// Sent to the delegate when the share button is tapped
// @param photo the PFObject for the photo that will be commented on
- (void)recipeTableCellView:(HMRecipeCellView *)recipeTableCellView didTapShareButton:(UIButton *)button recipe:(PFObject *)recipe {
    
    // First attempt: Publish using the Facenook Share dialog
    FBAppCall *call = [self publishWithShareDialog:recipe];
    
    // Second fallback: Publish using the iOS6 OS Integrated Share dialog
    BOOL displayedNativeDialog = YES;
    if (!call) {
        [self publishWithOSIntegratedShareDialog:recipe];
    }

    // Third fallback: Publish using either the Graph API or the Web Dialog
    if (!call && !displayedNativeDialog) {
        [self publishWithWebDialog:recipe];
    }

    
}

- (BOOL) publishWithOSIntegratedShareDialog:(PFObject *)recipe {
    PFFile *imageFile = [recipe objectForKey:kHMRecipePhotoKey];
    return [FBDialogs
            presentOSIntegratedShareDialogModallyFrom:self
            initialText: [recipe objectForKey:kHMRecipeTitleKey]
            image: [UIImage imageWithData:[imageFile getData]]
            url:nil
            handler:^(FBOSIntegratedShareDialogResult result, NSError *error) {
                // Only show the error if it is not due to the dialog
                // not being supported, otherwise ignore because our fallback
                // will show the share view controller.
                if ([[error userInfo][FBErrorDialogReasonKey]
                     isEqualToString:FBErrorDialogNotSupported]) {
                    return;
                }
                if (error) {
                    [self showAlert:[self checkErrorMessage:error]];
                } else if (result == FBNativeDialogResultSucceeded) {
                    [self showAlert:@"Posted successfully."];
                }
            }];
}


/*
 * Share using the Web Dialog
 */
- (void) publishWithWebDialog:(PFObject *)recipe {
    // Put together the dialog parameters
    
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     [recipe objectForKey:kHMRecipeTitleKey], @"name",
     [recipe objectForKey:kHMRecipeOverviewKey], @"description",
     // recipeLink, @"link", ! we should have a website to give a facebook share link
     [(PFFile *)[recipe objectForKey:kHMRecipePhotoKey] url], @"picture",
     nil];

    
    // Invoke the dialog
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:
     ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or publishing a story.
             [self showAlert:[self checkErrorMessage:error]];
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled story publishing.");
             } else {
                 // Handle the publish feed callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"post_id"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled story publishing.");
                 } else {
                     // User clicked the Share button
                     [self showAlert:[self checkPostId:urlParams]];
                 }
             }
         }
     }];
}


/*
 * Share using the Facebook native Share Dialog
 */
- (FBAppCall *) publishWithShareDialog:(PFObject *)recipe {
    // Set up the dialog parameters
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    params.link = [NSURL URLWithString:[(PFFile *)[recipe objectForKey:kHMRecipePhotoKey] url]];
    params.picture = [NSURL URLWithString:[(PFFile *)[recipe objectForKey:kHMRecipePhotoKey] url]];
    params.name = [recipe objectForKey:kHMRecipeTitleKey];
    params.description = [recipe objectForKey:kHMRecipeOverviewKey];
    // Set this flag on to enable the Share Dialog beta feature
//    [FBSettings  enableBetaFeature:FBBetaFeaturesShareDialog];
    return [FBDialogs presentShareDialogWithParams:params
                                       clientState:nil
                                           handler:
            ^(FBAppCall *call, NSDictionary *results, NSError *error) {
                if(error) {
                    // If there's an error show the relevant message
                    [self showAlert:[self checkErrorMessage:error]];
                } else {
                    // Check if cancel info is returned and log the event
                    if (results[@"completionGesture"] &&
                        [results[@"completionGesture"] isEqualToString:@"cancel"]) {
                        NSLog(@"User canceled story publishing.");
                    } else {
                        // If the post went through show a success message
                        [self showAlert:[self checkPostId:results]];
                    }
                }
                
            }];
}


#pragma mark - Helper methods
/*
 * Helper method to show alert results or errors
 */
- (NSString *)checkErrorMessage:(NSError *)error {
    NSString *errorMessage = @"";
    if (error.fberrorUserMessage) {
        errorMessage = error.fberrorUserMessage;
    } else {
        errorMessage = @"Operation failed due to a connection problem, retry later.";
    }
    return errorMessage;
}

/*
 * Helper method to check for the posted ID
 */
- (NSString *) checkPostId:(NSDictionary *)results {
    NSString *message = @"Posted successfully.";
    // Share Dialog
    NSString *postId = results[@"postId"];
    if (!postId) {
        // Web Dialog
        postId = results[@"post_id"];
    }
    if (postId) {
        message = [NSString stringWithFormat:@"Posted story, id: %@", postId];
    }
    return message;
}

/*
 * Helper method to parse URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

/*
 * Helper method to show an alert
 */
- (void)showAlert:(NSString *) alertMsg {
    if (![alertMsg isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Result"
                                    message:alertMsg
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void)leftDrawerButtonClicked {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)searchButtonClicked {
    HMSearchViewController *searchViewController = [[HMSearchViewController alloc] init];
    [[self navigationController] pushViewController:searchViewController animated:YES];
}

@end
