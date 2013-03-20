//
//  HMFeedItem.h
//  homemade
//
//  Created by Guan Guan on 3/17/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    COCKTAIL = 0,
    JUICE,
    CAKE,
    OTHER
} RecipeType;


@interface HMFeedItem : NSObject

@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *author_id;
@property (nonatomic, copy) NSString *photo_url;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, strong) NSDate   *date;
@property (nonatomic, strong) NSNumber *like_count;
@property (nonatomic, strong) NSNumber *difficulty;
@property (nonatomic, strong) NSNumber *done_count;

- (id)initForTest;

@end
