//
//  HMDrinkPhotoViewController.h
//  homemade
//
//  Created by Guan Guan on 7/4/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMRecipeViewController.h"

@interface HMDrinkPhotoViewController : UICollectionViewController <HMCameraDelegate>

@property (nonatomic, weak) HMRecipeViewController *recipeViewController;
@property (nonatomic, strong) HMCameraViewController *photoPicker;

- (id)initWithRecipe:(PFObject*)recipeObject;

@end
