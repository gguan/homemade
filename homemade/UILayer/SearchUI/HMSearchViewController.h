//
//  HMSearchViewController.h
//  homemade
//
//  Created by Guan Guan on 3/17/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSearchBar.h"

@interface HMSearchViewController : PFQueryTableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchResults;

@end
