//
//  HMCreateViewController.h
//  homemade
//
//  Created by Guan Guan on 6/19/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMCameraViewController.h"
#import "HMStepEditViewController.h"
#import "HMIngredientEditViewController.h"
#import "HMTipEditViewController.h"

@interface HMCreateViewController : UITableViewController <HMCameraDelegate, HMStepEditDelegate, HMIngredientEditDelegate, HMTipEditDelegate>

@end
