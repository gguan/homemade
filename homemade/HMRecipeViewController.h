//
//  HMRecipeViewController.h
//  homemade
//
//  Created by Guan Guan on 3/21/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBar.h"

@interface HMRecipeViewController : UIViewController<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,CustomTabBarDelegate>

@property(nonatomic,strong) PFObject* recipeObject;


@end
