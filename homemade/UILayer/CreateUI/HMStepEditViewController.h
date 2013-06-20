//
//  HMStepEditViewController.h
//  homemade
//
//  Created by Guan Guan on 6/19/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMCameraViewController.h"


@protocol HMStepEditDelegate;

@interface HMStepEditViewController : UIViewController <HMCameraDelegate>
@property (nonatomic, weak) id <HMStepEditDelegate> delegate;
- (id)initWithContent:(NSString *)content photo:(PFFile *)photoFile;
@end


@protocol HMStepEditDelegate <NSObject>
- (void)addStepItemViewController:(HMStepEditViewController *)controller didFinishEnteringItem:(NSDictionary *)stepItem;
@end