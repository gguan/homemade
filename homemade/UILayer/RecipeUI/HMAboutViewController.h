//
//  HMIngredientViewController.h
//  homemade
//
//  Created by Xiaodi Xing on 4/30/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMRecipeViewController.h"

@interface HMAboutViewController : UITableViewController 

@property (nonatomic, weak) HMRecipeViewController *recipeViewController;

- (id)initWithRecipe:(PFObject*)recipeObject;

@end
