//
//  HMFeedItem.m
//  homemade
//
//  Created by Guan Guan on 3/17/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMFeedItem.h"

@implementation HMFeedItem

@synthesize sid,author_id,photo_url,title,desc,date,like_count,difficulty,done_count;

- (id)init {
    self = [super init];
    if (self)
    {
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
    self.desc = @"Do what you like and fuch the rest";
    self.date = [[NSDate date] dateByAddingTimeInterval:-(rand()%10)*24*60*60];
    self.like_count = [NSNumber numberWithInt:arc4random() % 50];
    self.difficulty = [NSNumber numberWithInt:arc4random() % 5];
    self.done_count = [NSNumber numberWithInt:arc4random() % 20];
        
    return self;
}


@end
