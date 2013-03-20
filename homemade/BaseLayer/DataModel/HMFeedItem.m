//
//  HMFeedItem.m
//  homemade
//
//  Created by Guan Guan on 3/17/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMFeedItem.h"

@implementation HMFeedItem

- (id)init {
    self = [super init]; if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initForTest {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.sid = [NSString stringWithFormat:@"%d", arc4random() % 429496];
    self.author_id = [NSString stringWithFormat:@"%d", arc4random() % 10];
    self.photo_url = @"http://25.media.tumblr.com/a1c7a3d16d09748af8a7a8873e7fc5af/tumblr_miujy2tGxj1rz8t4lo1_500.jpg";
    self.title = @"Work hard, play hard";
    _description = @"Do what you like and fuch the rest";
    _date = [NSDate date];
    self.like_count = [NSNumber numberWithInt:arc4random() % 50];
    self.difficulty = [NSNumber numberWithInt:arc4random() % 5];
    self.done_count = [NSNumber numberWithInt:arc4random() % 20];
        
    return self;
}


@end
