//
//  HMPerson.h
//  homemade
//
//  Created by Guan Guan on 3/28/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMPerson : NSObject

@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *bio;

@property (nonatomic, strong) NSMutableArray *recipes;
@property (nonatomic, strong) NSMutableArray *done_recipes;
@property (nonatomic, strong) NSSet *ingredients;

- (id)initForTest;

@end
