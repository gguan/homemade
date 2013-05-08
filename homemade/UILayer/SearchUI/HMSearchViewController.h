//
//  HMSearchViewController.h
//  homemade
//
//  Created by Guan Guan on 3/17/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSearchBar.h"

@interface HMSearchViewController : PFQueryTableViewController <UISearchDisplayDelegate>

@property (nonatomic, strong) HMSearchBar *searchBar;
//@property (retain, nonatomic) UISearchDisplayController *searchDisplayController;

@end
