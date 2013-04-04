//
//  HMFeedItemJAO.m
//  homemade
//
//  Created by Sai Luo on 3/20/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#define UserDefaultsFeedsKey @"UserDefaultsFeedsKey" //move to constant.h later

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
    //need doublecheck the toRet format
    [[NSUserDefaults standardUserDefaults] setObject:toRet forKey:UserDefaultsFeedsKey];

    
    return toRet;
}


- (HMFeedItem*) getFeedFromJSONDictionary:(NSDictionary*)jsonDict
{
    NSString *theFeedId = [jsonDict objectForKey:@"feedId"];
    
    //convert NSString to NSNumber
//    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
//    [f setNumberStyle:NSNumberFormatterDecimalStyle];
//    NSNumber * feedIdNumber = [f numberFromString:theFeedId];
    
    HMFeedItem *toRet = [self getFeedByFeedId:theFeedId];
    
    if(!toRet)
    {
        toRet = (HMFeedItem *)[NSEntityDescription insertNewObjectForEntityForName:@"Feed" inManagedObjectContext:self.managedObjectContext];
    }
    
    if(jsonDict)
    {
        toRet.sid = [jsonDict objectForKey:@"feedId"];
        toRet.author_id = [jsonDict objectForKey:@"authorId"];
        toRet.photo_url = [jsonDict objectForKey:@"photoUrl"];
        toRet.title = [jsonDict objectForKey:@"title"];
        toRet.desc = [jsonDict objectForKey:@"desc"];
        
//        toRet.date = [jsonDict objectForKey:@"date"];
        
        NSString *dateString = @"01-02-2010";
        dateString = [jsonDict objectForKey:@"date"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormatter dateFromString:dateString];
        toRet.date = dateFromString;
        
        toRet.like_count = [jsonDict objectForKey:@"likeCount"];
        toRet.difficulty = [jsonDict objectForKey:@"difficulty"];
        toRet.done_count = [jsonDict objectForKey:@"doneCount"];
    }
    return toRet;
}



- (HMFeedItem*)getFeedByFeedId:(NSString*)feedId {
    NSArray *feedIds = [NSArray arrayWithObject:feedId];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // need testing here, whether add core data manually working
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Feed" inManagedObjectContext:self.managedObjectContext]];
    [fetchRequest setPredicate: [NSPredicate predicateWithFormat: @"(sid IN %@)", feedIds]];
    
    // make sure the results are sorted as well
//    [fetchRequest setSortDescriptors: [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey: @"feedId" ascending:YES]]];
    
    NSError *error = nil;
    NSArray *feedsMatchingIds = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
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
