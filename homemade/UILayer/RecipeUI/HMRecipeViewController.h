//
//  HMRecipeViewController.h
//  homemade
//
//  Created by Guan Guan on 3/21/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMRecipeViewController : UIViewController<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) IBOutlet UIImageView  *photo;
@property (strong, nonatomic) IBOutlet UILabel      *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel      *descLabel;
@property (strong, nonatomic) IBOutlet UIButton     *saveButton;
@property (strong, nonatomic) IBOutlet UITableView  *ingredientsView;
@property (strong, nonatomic) IBOutlet UITableView  *stepsView;


@property (strong, nonatomic) NSMutableArray *ingredients;
@property (strong, nonatomic) NSMutableArray *steps;

@property (strong, nonatomic) UITableView *recipeDetailView;

@end
