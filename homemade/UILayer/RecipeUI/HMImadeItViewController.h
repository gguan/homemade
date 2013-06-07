//
//  HMImadeItViewController.h
//  homemade
//
//  Created by Xiaodi Xing on 4/30/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMCameraViewController.h"

@interface HMImadeItViewController : UITableViewController <HMCameraDelegate>

@property (nonatomic, strong) UIButton *cameraButton;

- (id)initWithRecipe:(PFObject*)recipeObject;


@end
