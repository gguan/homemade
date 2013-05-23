//
//  HMRecipeFeedViewController.h
//  homemade
//
//  Created by Guan Guan on 4/17/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <Parse/Parse.h>
#import "AwesomeMenu.h"
#import "HMRecipeCellView.h"

@interface HMRecipeFeedViewController : PFQueryTableViewController <AwesomeMenuDelegate, HMRecipeCellViewDelegate, UIGestureRecognizerDelegate>

@end
