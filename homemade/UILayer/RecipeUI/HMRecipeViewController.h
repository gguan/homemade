//
//  HMRecipeViewController.h
//  homemade
//
//  Created by Guan Guan on 3/21/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "CustomTabBar.h"
#import "HMCameraViewController.h"

@interface HMRecipeViewController : UIViewController<CustomTabBarDelegate, HMCameraDelegate>

@property (nonatomic, strong) HMCameraViewController *photoPicker;

- (id)initWithRecipe:(PFObject*)recipeObject andUIColor:(UIColor*)color;
- (id)initWithRecipe:(PFObject*)recipeObject;

@end
