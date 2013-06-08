//
//  HMImadeItViewController.h
//  homemade
//
//  Created by Xiaodi Xing on 4/30/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

@class HMRecipeViewController;

@interface HMImadeItViewController : PFQueryTableViewController

@property (nonatomic, weak) HMRecipeViewController *recipeViewController;

- (id)initWithRecipe:(PFObject*)recipeObject;


@end
