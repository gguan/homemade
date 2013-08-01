//
//  HMCategoryQueryViewController.m
//  homemade
//
//  Created by Guan Guan on 7/31/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMCategoryQueryViewController.h"
#import "HMRecipeCellView.h"
#import "HMRecipeViewController.h"
#import "TMCache.h"
#import "UIImage+ColorArt.h"

@interface HMCategoryQueryViewController ()

@property (nonatomic, copy) NSString *category;

@end

@implementation HMCategoryQueryViewController

- (id)initWithStyle:(UITableViewStyle)style category:(NSString *)category
{
    self = [super initWithStyle:style];
    if (self) {
        
        // The className to query on
        self.parseClassName = kHMRecipeClassKey;
        
        // Whether the built-in pull-to-refresh is enabled, we manuall add it
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
        
        self.category = category;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor],UITextAttributeTextColor,
                                                                     [UIColor colorWithWhite:0.0f alpha:0.750f],
                                                                     UITextAttributeTextShadowColor,
                                                                     [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)],
                                                                     UITextAttributeTextShadowOffset,
                                                                     [UIFont fontWithName:@"Helvetica-BoldOblique" size:17.0f], UITextAttributeFont,
                                                                     nil]];
    // Setup navigation bar
    [self.navigationItem setTitle:self.category];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.objects count];
}

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
                }
            }];
        } // if isDataAvailable end
        
    } // if object end
    
    return cell;
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



@end
