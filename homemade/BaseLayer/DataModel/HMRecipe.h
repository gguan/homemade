//
//  HMRecipe.h
//  homemade
//
//  Created by Guan Guan on 3/21/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMRecipe : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;

@property (strong, nonatomic) NSString *photoUrl;

@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *author_id;


//can not use "description" in core data
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) NSDate   *date;
@property (nonatomic, strong) NSNumber *like_count;
@property (nonatomic, strong) NSNumber *difficulty;
@property (nonatomic, strong) NSNumber *done_count;


@end
