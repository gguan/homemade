//
//  HMFeedItemJAO.m
//  homemade
//
//  Created by Sai Luo on 3/20/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMFeedItemJAO.h"
#import "HMMD5Hash.h"

#define UserDefaultsJSONHashDictionaryKey @"UserDefaultsJSONHashDictionaryKey" // move to constant.h later


@implementation HMFeedItemJAO


- (NSArray*)getFeedsFromJSONURL:(NSString*) jsonURLString;
{
    NSMutableArray *toRet = nil;
    NSURL *jsonURL = [NSURL URLWithString:jsonURLString];
    
    if(jsonURL)
    {
        NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
        
        // if the data is not changed, then stop the procedure
        if(![self checkIfJSONDataChangedForURLString:jsonURLString andLatestData:jsonData])
            return nil;
        
        NSError *err = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        if(!json)
            NSLog(@"Error parsing JSON:%@",err);
        else
        {
            NSArray *jsonDictArray = [json objectForKey:@"Feeds"];
            if(jsonDictArray)
            {
                toRet = [NSMutableArray arrayWithCapacity:jsonDictArray.count];
                for(int i=0; i<jsonDictArray.count; i++)
                {
                    NSDictionary *jsonDict = [jsonDictArray objectAtIndex:i];
                    HMFeedItem *feed = [self getFeedFromJSONDictionary:jsonDict];
                    if(feed)
                        [toRet addObject:feed];
                }
            }
        }
        
    }
    
    return toRet;
}


- (HMFeedItem*) getFeedFromJSONDictionary:(NSDictionary*)jsonDict
{
    NSNumber *theFeedId = [jsonDict objectForKey:@"FeedId"];
    
    HMFeedItem *toRet = [self getFeedByFeedId:theFeedId];
    
    if(!toRet)
    {
        toRet = (HMFeedItem *)[NSEntityDescription insertNewObjectForEntityForName:@"Feed" inManagedObjectContext:self.managedObjectContext];
    }
    
    if(jsonDict)
    {
        toRet.sid = [jsonDict objectForKey:@"FeedId"];
        toRet.author_id = [jsonDict objectForKey:@"AuthorId"];
        toRet.photo_url = [jsonDict objectForKey:@"PhotoUrl"];
        toRet.title = [jsonDict objectForKey:@"Title"];
        toRet.desc = [jsonDict objectForKey:@"Desc"];
        toRet.date = [jsonDict objectForKey:@"Date"];
        toRet.like_count = [jsonDict objectForKey:@"LikeCount"];
        toRet.difficulty = [jsonDict objectForKey:@"Difficulty"];
        toRet.done_count = [jsonDict objectForKey:@"DoneCount"];
    }
    return toRet;
}



- (HMFeedItem*)getFeedByFeedId:(NSNumber*)feedId {
    NSArray *feedIds = [NSArray arrayWithObject:feedId];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // need testing here, whether add core data manually working
    [fetchRequest setEntity:
     [NSEntityDescription entityForName:@"Feed" inManagedObjectContext:self.managedObjectContext]];
    [fetchRequest setPredicate: [NSPredicate predicateWithFormat: @"(feedId IN %@)", feedIds]];
    
    // make sure the results are sorted as well
    [fetchRequest setSortDescriptors: [NSArray arrayWithObject:
                                       [[NSSortDescriptor alloc] initWithKey: @"feedId"
                                                                   ascending:YES]]];
    
    NSError *error = nil;
    NSArray *feedsMatchingIds = [self.managedObjectContext
                                  executeFetchRequest:fetchRequest error:&error];
    
    if (!feedsMatchingIds) {
        return nil;
    }
    else {
        return [feedsMatchingIds lastObject];
    }
}



-(BOOL)checkIfJSONDataChangedForURLString:(NSString*)urlString andLatestData:(NSData*)latestData {
    BOOL toRet = YES;
    
    NSMutableDictionary *hashDict = [[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsJSONHashDictionaryKey] mutableCopy];
    
    // initialize hash dictionary if needed
    if (hashDict == nil) {
        hashDict = [NSMutableDictionary dictionary];
    }
    
    NSString *key = [HMMD5Hash getMD5HashFromString:urlString];
    
    if (key) {
        NSString *dataHash = [hashDict objectForKey:key];
        NSString *latestDataHash = [HMMD5Hash getMD5FromData:latestData];
        
        
        if (dataHash && [dataHash isEqualToString:latestDataHash]) {
            toRet = NO;
        }
        else {
            // update the dictionary in userdefaults if the data hash is not available or data changed
            [hashDict setObject:latestDataHash forKey:key];
            [[NSUserDefaults standardUserDefaults] setObject:hashDict forKey:UserDefaultsJSONHashDictionaryKey];
        }
    }
    return toRet;
}


@end
