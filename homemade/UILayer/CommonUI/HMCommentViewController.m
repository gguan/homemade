//
//  HMCommentViewController.m
//  homemade
//
//  Created by Guan Guan on 6/9/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMCommentViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TTTTimeIntervalFormatter.h"
#import "HMPhotoCommentView.h"

@interface HMCommentViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *commentTextField;
@property (nonatomic, strong) PFImageView *photoView;
@property (nonatomic, assign) UIBackgroundTaskIdentifier commentPostBackgroundTaskId;
@property (nonatomic, strong) TTTTimeIntervalFormatter *timeIntervalFormatter;
@end

@implementation HMCommentViewController

- (id)initWithPFObject:(PFObject *)object andType:(NSInteger)type {
    self = [super init];
    if (self) {
        if (!object) {
            return nil;
        }
        
        self.object = object;
        self.type = type;
        
        // The className to query on
        self.parseClassName = kHMCommentClassKey;
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = NO;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 20;
        
        self.timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Custom initialization
    [self.tableView setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    
    self.photoView = [[PFImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 320.0f)];
    if (self.type == kTypeRecipe) {
        [self.photoView setFile:[self.object objectForKey:kHMRecipePhotoKey]];
    } else {
        [self.photoView setFile:[self.object objectForKey:kHMDrinkPhotoPictureKey]];
    }
    [self.photoView loadInBackground];
    
    self.tableView.tableHeaderView = self.photoView;

    
    HMPhotoCommentView *footerView = [[HMPhotoCommentView alloc] initWithFrame:[HMPhotoCommentView rectForView]];
    self.commentTextField = footerView.commentField;
    self.commentTextField.delegate = self;
    self.tableView.tableFooterView = footerView;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
//    if (!self.recipeObject) {
//        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
//        [query setLimit:0];
//        return query;
//    }
//    
//    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
//    query.cachePolicy = kPFCachePolicyNetworkOnly;
//    if ([self.objects count] == 0) {
//        query.cachePolicy = kPFCachePolicyNetworkElseCache;
//    }
//    
//    [query whereKey:kHMDrinkPhotoRecipeKey equalTo:self.recipeObject];
//    [query includeKey:kHMDrinkPhotoUserKey];
//    [query orderByDescending:@"createdAt"];
//    
//    return query;
    return nil;
}


- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    // overridden, since we want to implement sections
//    if (indexPath.row < self.objects.count) {
//        return [self.objects objectAtIndex:indexPath.row];
//    }
    
    return nil;
}


- (PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)photoObject {
    return nil;
}

@end
