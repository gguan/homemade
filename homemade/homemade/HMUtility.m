//
//  HMUtility.m
//  homemade
//
//  Created by Guan Guan on 4/28/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMUtility.h"

@implementation HMUtility

+ (void)saveRecipeInBackground:(id)recipe block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    
    PFQuery *queryExistingSaves = [PFQuery queryWithClassName:kHMSaveClassKey];
    [queryExistingSaves whereKey:kHMSaveRecipeKey equalTo:recipe];
    [queryExistingSaves whereKey:kHMSaveFromUserKey equalTo:[PFUser currentUser]];
    [queryExistingSaves setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingSaves findObjectsInBackgroundWithBlock:^(NSArray *saves, NSError *error) {
        if (!error) {
            if ([saves count] > 0) {
                NSLog(@"The recipe has already been saved by user.");
            } else {
                // proceed to creating new save
                NSLog(@"Save recipe by user on Parse server.");
                PFObject *saveActivity = [PFObject objectWithClassName:kHMSaveClassKey];
                [saveActivity setObject:[PFUser currentUser] forKey:kHMSaveFromUserKey];
                [saveActivity setObject:[recipe objectForKey:kHMRecipeUserKey] forKey:kHMSaveToUserKey];
                [saveActivity setObject:recipe forKey:kHMSaveRecipeKey];
                
                PFACL *saveACL = [PFACL ACLWithUser:[PFUser currentUser]];
                [saveACL setPublicReadAccess:YES];
                [saveACL setWriteAccess:YES forUser:[recipe objectForKey:kHMRecipeUserKey]];
                saveActivity.ACL = saveACL;
                
                [saveActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (completionBlock) {
                        completionBlock(succeeded, error);
                    }
                    
                    // refresh cache
                    PFQuery *query = [HMUtility queryForSavesOnRecipe:recipe cachePolicy:kPFCachePolicyNetworkOnly];
                    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        if (!error) {
                            BOOL isSavedByCurrentUser = NO;
                            for (PFObject *save in objects) {
                                if ([[[save objectForKey:kHMSaveFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                                    isSavedByCurrentUser = YES;
                                    break;
                                }
                            }
                            NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                        [NSNumber numberWithInt:[objects count]],
                                                        kHMRecipeAttributesSaveCountKey,
                                                        [NSNumber numberWithBool:isSavedByCurrentUser],
                                                        kHMRecipeAttributesIsSavedByCurrentUserKey,
                                                        nil];
                            [[HMCache sharedCache] setAttributesForRecipe:recipe attributes:attributes];
                        }
                    }];
                }];
                
            }
        }
    }];
}
+ (void)unSaveRecipeInBackground:(id)recipe block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    
    PFQuery *queryExistingSaves = [PFQuery queryWithClassName:kHMSaveClassKey];
    [queryExistingSaves whereKey:kHMSaveRecipeKey equalTo:recipe];
    [queryExistingSaves whereKey:kHMSaveFromUserKey equalTo:[PFUser currentUser]];
    [queryExistingSaves setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingSaves findObjectsInBackgroundWithBlock:^(NSArray *saves, NSError *error) {
    
        if (!error) {
            for (PFObject *save in saves) {
                [save delete];
            }
            if (completionBlock) {
                completionBlock(YES,nil);
            }
            
            // refresh cache
            PFQuery *query = [HMUtility queryForSavesOnRecipe:recipe cachePolicy:kPFCachePolicyNetworkOnly];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    BOOL isSavedByCurrentUser = NO;
                    for (PFObject *save in objects) {
                        if ([[[save objectForKey:kHMSaveFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                            isSavedByCurrentUser = YES;
                            break;
                        }
                    }
                    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                [NSNumber numberWithInt:[objects count]],
                                                kHMRecipeAttributesSaveCountKey,
                                                [NSNumber numberWithBool:isSavedByCurrentUser],
                                                kHMRecipeAttributesIsSavedByCurrentUserKey,
                                                nil];
                    [[HMCache sharedCache] setAttributesForRecipe:recipe attributes:attributes];
                }
            }];
        }
    }];
}


+ (void)processFacebookProfilePictureData:(NSData *)data {
    
}

+ (BOOL)userHasValidFacebookData:(PFUser *)user {
    
}
+ (BOOL)userHasProfilePictures:(PFUser *)user {
    
}

+ (NSString *)firstNameForDisplayName:(NSString *)displayName {
    
}


#pragma mark - Common queries 
+ (PFQuery *)queryForSavesOnRecipe:(PFObject *)recipe cachePolicy:(PFCachePolicy)cachePolicy {
    PFQuery *query = [PFQuery queryWithClassName:kHMSaveClassKey];
    [query whereKey:kHMSaveRecipeKey equalTo:recipe];
    [query setCachePolicy:cachePolicy];
    [query includeKey:kHMSaveFromUserKey];
    [query includeKey:kHMSaveRecipeKey];
    return query;
}

+ (PFQuery *)queryForCommentsOnRecipe:(PFObject *)recipe cachePolicy:(PFCachePolicy)cachePolicy {
    PFQuery *query = [PFQuery queryWithClassName:kHMCommentClassKey];
    [query whereKey:kHMCommentRecipeKey equalTo:recipe];
    [query setCachePolicy:cachePolicy];
    [query includeKey:kHMSaveFromUserKey];
    [query includeKey:kHMSaveRecipeKey];
    return query;
}



@end
