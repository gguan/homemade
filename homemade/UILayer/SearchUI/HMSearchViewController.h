//
//  HMSearchViewController.h
//  homemade
//
//  Created by Guan Guan on 3/17/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSearchBar.h"

@interface HMSearchViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;


@end
