//
//  HMFeedAPIClient.m
//  homemade
//
//  Created by Guan Guan on 3/20/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMFeedAPIClient.h"
#import "HMFeedItem.h"

#define BASE_URL @"http://guans-macbook-pro.local:9000"
#define MOMENT_PATH @"/moment"

@implementation HMFeedAPIClient

+ (HMFeedAPIClient *)sharedClient {
    static HMFeedAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HMFeedAPIClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    });
    
    return _sharedClient;
}

- (void)latestFeedsWithBlock:(void (^)(NSArray *feeds, NSError *error))block {
#ifdef DEBUG
    // create moments manually for testing
    NSMutableArray *feeds = [NSMutableArray arrayWithCapacity:10];
    for (int i=0; i<10; i++) {
        HMFeedItem *feed = [[HMFeedItem alloc] initForTest];
        [feeds addObject:feed];
    }
    if (block) {
        block([NSArray arrayWithArray:feeds], nil);
    }
#else
    // TODO
    if (block) {
        block(nil, nil);
    }
#endif
    
}

@end
