//
//  HMCommentViewController.h
//  homemade
//
//  Created by Guan Guan on 6/9/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMCommentTextField.h"

@interface HMCommentViewController : PFQueryTableViewController <UITextFieldDelegate, HMCommentTextFieldDelegate>

@property (nonatomic, strong) PFObject *object;
@property (nonatomic, assign) NSString *type;

- (id)initWithPFObject:(PFObject *)object andType:(NSString *)type;

@end
