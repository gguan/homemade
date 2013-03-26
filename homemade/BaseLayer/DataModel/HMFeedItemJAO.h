//
//  HMFeedItemJAO.h
//  homemade
//
//  Created by Sai Luo on 3/20/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

//Used for parsing JSON downloaded from server

#import <Foundation/Foundation.h>
#import "HMFeedItem.h"

@interface HMFeedItemJAO : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (NSArray*)getFeedsFromJSONURL:(NSString*) jsonURLString;

@end
