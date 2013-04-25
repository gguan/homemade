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
#import "HMRecipeCellView.h"
#import "SVPullToRefresh.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+ColorArt.h"
#import "UIImage+FX.h"
#import "TMCache.h"
#import <Parse/Parse.h>


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
    
    // Customize pullToRefresh view
    [[self.view.subviews objectAtIndex:1] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    UIView *pullToRefreshView = (UIView *)[self.view.subviews objectAtIndex:1];
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
    
    HMRecipeCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HMRecipeCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    cell.titleLabel.text = [object objectForKey:@"title"];
    // TODO
    cell.saveCount.text = @"100";
    cell.commentCount.text = @"100";
    
    if (object) {
        cell.photo.file = [object objectForKey:kHMRecipePhotoKey];
        
        // PFQTVC will take care of asynchronously downloading files, but will only load them when the tableview is not moving. If the data is there, let's load it right away.
        if (cell.photo.file.isDataAvailable) {
            // Manually download images from parse and set animation
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                NSData *data = [cell.photo.file getData];
//                if(data) {
//                    dispatch_async( dispatch_get_main_queue(), ^{
//                        [UIView animateWithDuration:0.0
//                                         animations:^{
//                                             cell.photo.alpha = 0.0f;
//                                         }
//                                         completion:^(BOOL finished){
//                                             UIImage *image = [UIImage imageWithData:data];
//                                             // find color in center 100x100 area, still need to improve
//                                             CGRect cropRect = CGRectMake(image.size.width/2-50, image.size.height/2-50, 100, image.size.height/2+50);
//                                             CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
//                                             UIImage *subImage = [UIImage imageWithCGImage:imageRef];
//                                             CGImageRelease(imageRef);
//                                             SLColorArt *colorArt = [subImage colorArt];
//                                             
//                                             [UIView animateWithDuration:0.0
//                                                              animations:^{
//                                                                  cell.photo.image = image;
//                                                                  cell.photo.alpha = 1.0f;
//                                                                  cell.colorArt = colorArt;
//                                                                  [cell.colorLine setBackgroundColor:colorArt.primaryColor];
//                                                                  cell.colorLine.alpha = 0.95;
//                                                              }
//                                                              completion:^(BOOL finished) { }];
//                                         }];//outside block
//                    });
//                } else {
//                    NSLog(@"Error! Failed to download data from parse!");
//                }                
//                
//            });
            [cell.photo loadInBackground:^(UIImage *image, NSError *error){
                if (image) {
                    
                    UIColor *colorArt = [[TMCache sharedCache] objectForKey:[NSString stringWithFormat: @"%@%@", cell.photo.file.name, kHMColorSuffixKey]];
                    
                    if (colorArt) {
                        NSLog(@"Find colorArt from cache %@", colorArt);
//                        cell.colorArt = colorArt;
                        [cell.colorLine setBackgroundColor:colorArt];
                    } else {
                        NSLog(@"Didn't find colorArt from cache, compute in background");
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            UIImage *cropImage = [image imageCroppedToRect:CGRectMake(image.size.width/2-50, image.size.height/2-50, 100, image.size.height/2+50)];
                            UIColor *colorArt = [cropImage colorArt].primaryColor;
                            [[TMCache sharedCache] setObject:colorArt forKey:[NSString stringWithFormat: @"%@%@", cell.photo.file.name, kHMColorSuffixKey]];
                            dispatch_async( dispatch_get_main_queue(), ^{
//                                cell.colorArt = colorArt;
                                [cell.colorLine setBackgroundColor:colorArt];
                            });
                        });
                    }
                    
                }
                if (error) {
                    NSLog(@"Error!");
                }
            }];
        } // if isDataAvailable end
        
    }
    
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect fixedFrame = self.view.frame;
    fixedFrame.origin.y = 0 + scrollView.contentOffset.y;
    menu.frame = fixedFrame;
}

@end
