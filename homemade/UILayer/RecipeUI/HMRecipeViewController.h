//
//  HMRecipeViewController.h
//  homemade
//
//  Created by Guan Guan on 3/21/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMRecipeViewController : UIViewController<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>


//@property (strong, nonatomic) IBOutlet UIImageView  *photo;
//@property (strong, nonatomic) IBOutlet UILabel      *titleLabel;
//@property (strong, nonatomic) IBOutlet UILabel      *descLabel;
//@property (strong, nonatomic) IBOutlet UIButton     *saveButton;
//@property (strong, nonatomic) IBOutlet UITableView  *ingredientsView;
//@property (strong, nonatomic) IBOutlet UITableView  *stepsView;

@property (strong, nonatomic) UIImageView  *photo;
@property (strong, nonatomic) NSString      *titleLabel;
@property (strong, nonatomic) NSString     *descLabel;
@property (strong, nonatomic) UIButton     *saveButton;
@property (strong, nonatomic) UITableView  *ingredientsView;
@property (strong, nonatomic) UITableView  *stepsView;

@property (strong, nonatomic) NSMutableArray *ingredients;
@property (strong, nonatomic) NSMutableArray *steps;
@property (strong, nonatomic) NSMutableArray *tips;

@property (strong, nonatomic) UITableView *recipeDetailView;

@property (strong, nonatomic) NSMutableArray *ingredientsQuantity;
@property (strong, nonatomic) NSMutableArray *stepsLabelHeight;
@property (strong, nonatomic) NSMutableArray *tipsLabelHeight;

@end
