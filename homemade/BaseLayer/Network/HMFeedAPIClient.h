//
//  HMFeedAPIClient.h
//  homemade
//
//  Created by Guan Guan on 3/20/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "AFHTTPClient.h"

@interface HMFeedAPIClient : AFHTTPClient

+ (HMFeedAPIClient *)sharedClient;

- (void)latestFeedsWithBlock:(void (^)(NSArray *feeds, NSError *error))block;


@end
