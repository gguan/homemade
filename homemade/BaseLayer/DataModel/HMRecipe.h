//
//  HMRecipe.h
//  homemade
//
//  Created by Guan Guan on 3/21/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMPerson.h"

typedef enum {
    COCKTAIL,
    JUICE,
    CAKE,
    DESERT,
    OTHER
} RecipeType;


@interface HMRecipe : NSObject

@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) NSString *author_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, strong) NSString *photoUrl;
@property (nonatomic, strong) NSDate   *date;
@property (nonatomic, strong) NSNumber *difficulty;
@property (nonatomic, strong) NSNumber *save_count;
@property (nonatomic, strong) NSNumber *made_count;
@property (nonatomic, strong) HMPerson *author;

@property (nonatomic, strong) NSSet *ingredients;
@property (nonatomic, strong) NSArray *instructions;
@property (nonatomic, strong) NSArray *tips;

@end
