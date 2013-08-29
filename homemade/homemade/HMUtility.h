//
//  HMUtility.h
//  homemade
//
//  Created by Guan Guan on 4/28/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *  System Versioning Preprocessor Macros
 */

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


NSUInteger DeviceSystemMajorVersion();

#define DEVICE_VERSION_7 (DeviceSystemMajorVersion() >= 7)


@interface HMUtility : NSObject

+ (void)saveRecipeInBackground:(id)recipe block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)unSaveRecipeInBackground:(id)recipe block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

+ (void)unfollowUserEventually:(PFUser *)user;
+ (void)followUserInBackground:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock;


+ (void)processFacebookProfilePictureData:(NSData *)data;

+ (BOOL)userHasValidFacebookData:(PFUser *)user;
+ (BOOL)userHasProfilePictures:(PFUser *)user;

+ (NSString *)firstNameForDisplayName:(NSString *)displayName;


+ (PFQuery *)queryForSavesOnRecipe:(PFObject *)recipe cachePolicy:(PFCachePolicy)cachePolicy;
+ (PFQuery *)queryForCommentsOnRecipe:(PFObject *)recipe cachePolicy:(PFCachePolicy)cachePolicy;
+ (PFQuery *)queryForPhotosOnRecipe:(PFObject *)recipe cachePolicy:(PFCachePolicy)cachePolicy;

+ (void)drawSideAndBottomDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context;

+ (CGFloat)textHeight:(NSString *)text fontSize:(CGFloat)fontSize width:(CGFloat)width;

+ (CGFloat)screenHeight;

+ (UIFont *)appFontOfSize:(CGFloat)size;

+ (NSString *)getPreferredLanguage;

+ (NSArray *)getCategories;

@end
