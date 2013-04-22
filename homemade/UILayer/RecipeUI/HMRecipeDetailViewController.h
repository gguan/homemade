//
//  HMRecipeDetailView.h
//  homemade
//
//  Created by Guan Guan on 4/22/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMRecipeDetailViewController : UIViewController

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *headerImage;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIView *headerMenu;
@property (strong, nonatomic) UIButton *ingredientButton;
@property (strong, nonatomic) UIButton *stepsButton;
@property (strong, nonatomic) UIButton *iMadeItButton;
@property (strong, nonatomic) UIView *ingredientView;
@property (strong, nonatomic) UIView *stepsView;
@property (strong, nonatomic) UIView *iMadeItView;

@property (strong, nonatomic) UIColor *mainColor;

@property (strong, nonatomic) PFObject *recipeObject;


@end
