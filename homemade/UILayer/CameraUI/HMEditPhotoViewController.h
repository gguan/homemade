//
//  HMEditPhotoViewController.h
//  homemade
//
//  Created by Guan Guan on 6/6/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMEditPhotoViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) PFObject *recipeObject;

- (id)initWithImage:(UIImage *)aImage withRecipe:(PFObject *)recipe;

@end
