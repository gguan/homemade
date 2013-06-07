//
//  HMUtility.h
//  homemade
//
//  Created by Guan Guan on 4/28/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMUtility : NSObject

+ (void)saveRecipeInBackground:(id)recipe block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)unSaveRecipeInBackground:(id)recipe block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

+ (void)processFacebookProfilePictureData:(NSData *)data;

+ (BOOL)userHasValidFacebookData:(PFUser *)user;
+ (BOOL)userHasProfilePictures:(PFUser *)user;

+ (NSString *)firstNameForDisplayName:(NSString *)displayName;


+ (PFQuery *)queryForSavesOnRecipe:(PFObject *)recipe cachePolicy:(PFCachePolicy)cachePolicy;
+ (PFQuery *)queryForCommentsOnRecipe:(PFObject *)recipe cachePolicy:(PFCachePolicy)cachePolicy;


+ (void)drawSideAndBottomDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context;

@end
