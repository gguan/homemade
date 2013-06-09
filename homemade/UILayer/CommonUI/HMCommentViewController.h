//
//  HMCommentViewController.h
//  homemade
//
//  Created by Guan Guan on 6/9/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMCommentViewController : PFQueryTableViewController <UITextFieldDelegate>

@property (nonatomic, strong) PFObject *object;
@property (nonatomic, assign) NSInteger type;

- (id)initWithPFObject:(PFObject *)object andType:(NSInteger)type;

@end
