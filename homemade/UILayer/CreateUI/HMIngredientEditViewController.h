//
//  HMIngredientEditViewController.h
//  homemade
//
//  Created by Guan Guan on 6/20/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

@protocol HMIngredientEditDelegate;

@interface HMIngredientEditViewController : UIViewController
@property (nonatomic, weak) id <HMIngredientEditDelegate> delegate;
- (id)initWithName:(NSString *)name amount:(NSString *)amount;
@end


@protocol HMIngredientEditDelegate <NSObject>
- (void)addIngredientItemViewController:(HMIngredientEditViewController *)controller didFinishEnteringItem:(NSDictionary *)ingredientItem;
@end