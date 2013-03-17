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

@property NSString *sid;
@property NSString *author_id;
@property NSString *photo_url;
@property NSDate   *date;
@property NSString *title;
@property NSString *description;
@property NSNumber * like_count;
@property NSNumber *difficulty;
@property NSNumber *done_count;

@end
