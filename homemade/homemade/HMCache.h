//
//  HMCache.h
//  homemade
//
//  Created by Guan Guan on 4/14/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMCache : NSObject

+ (id)sharedCache;

- (void)clear;
- (void)setAttributesForRecipe:(PFObject *)recipe attributes:(NSDictionary *)attributes;
- (void)setAttributesForRecipe:(PFObject *)recipe saveCount:(int)saveCount makeCount:(int)makeCount commentCount:(int)commentCount savedByCurrentUser:(BOOL)savedByCurrentUser madeByCurrentUser:(BOOL)madeByCurrentUser;
- (NSDictionary *)attributesForRecipe:(PFObject *)photo;
- (NSNumber *)saveCountForRecipe:(PFObject *)recipe;
- (NSNumber *)madeCountForRecipe:(PFObject *)recipe;
- (NSNumber *)commentCountForRecipe:(PFObject *)recipe;
//- (NSArray *)saversForRecipe:(PFObject *)recipe;
//- (NSArray *)makersForRecipe:(PFObject *)recipe;
//- (NSArray *)commentersForRecipe:(PFObject *)recipe;
- (void)setRecipeIsSavedByCurrentUser:(PFObject *)recipe saved:(BOOL)saved;
- (void)setRecipeIsMadeByCurrentUser:(PFObject *)recipe made:(BOOL)made;
- (BOOL)isSavedByCurrentUser:(PFObject *)recipe;
- (BOOL)isMadeByCurrentUser:(PFObject *)recipe;
- (void)incrementSaverCountForRecipe:(PFObject *)recipe;
- (void)decrementSaverCountForRecipe:(PFObject *)recipe;
- (void)incrementMakerCountForRecipe:(PFObject *)recipe;
- (void)decrementMakerCountForRecipe:(PFObject *)recipe;
- (void)incrementCommentCountForRecipe:(PFObject *)recipe;
- (void)decrementCommentCountForRecipe:(PFObject *)recipe;

- (NSDictionary *)attributesForUser:(PFUser *)user;
- (NSNumber *)recipeCountForUser:(PFUser *)user;
- (void)setRecipeCount:(NSNumber *)count user:(PFUser *)user;

- (void)setFacebookFriends:(NSArray *)friends;
- (NSArray *)facebookFriends;

@end
