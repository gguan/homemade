//
//  HMDrinkPhotoViewController.h
//  homemade
//
//  Created by Guan Guan on 7/4/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMRecipeViewController.h"

@interface HMDrinkPhotoViewController : UICollectionViewController 

@property (nonatomic, weak) HMRecipeViewController *recipeViewController;

- (id)initWithRecipe:(PFObject*)recipeObject;


@end
