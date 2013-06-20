//
//  HMTipEditViewController.h
//  homemade
//
//  Created by Guan Guan on 6/20/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

@protocol HMTipEditDelegate;

@interface HMTipEditViewController : UIViewController
@property (nonatomic, weak) id <HMTipEditDelegate> delegate;
- (id)initWithTip:(NSString *)tip;
@end

@protocol HMTipEditDelegate <NSObject>
- (void)addTipItemViewController:(HMTipEditViewController *)controller didFinishEnteringItem:(NSString *)tipItem;
@end