//
//  HMCache.m
//  homemade
//
//  Created by Guan Guan on 4/14/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "HMCache.h"
#import "TMCache.h"

@interface HMCache()

@property (nonatomic, strong) TMCache *cache;
- (void)setAttributes:(NSDictionary *)attributes forRecipe:(PFObject *)recipe;
@end

@implementation HMCache

#pragma mark - Initialization

+ (id)sharedCache {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        self.cache = [TMCache sharedCache];
    }
    return self;
}

#pragma mark - HMCache

- (void)clear {
    [self.cache removeAllObjects];
}

- (void)setAttributesForRecipe:(PFObject *)recipe attributes:(NSDictionary *)attributes {
   [self setAttributes:attributes forRecipe:recipe]; 
}

- (void)setAttributesForRecipe:(PFObject *)recipe saveCount:(int)saveCount makeCount:(int)makeCount commentCount:(int)commentCount savedByCurrentUser:(BOOL)savedByCurrentUser madeByCurrentUser:(BOOL)madeByCurrentUser {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:saveCount],
                                        kHMRecipeAttributesSaveCountKey,
                                        [NSNumber numberWithInt:makeCount],
                                        kHMRecipeAttributesMakeCountKey,
                                        [NSNumber numberWithInt:commentCount],
                                        kHMRecipeAttributesCommentCountKey,
                                        [NSNumber numberWithBool:savedByCurrentUser],
                                        kHMRecipeAttributesIsSavedByCurrentUserKey,
                                        [NSNumber numberWithBool:madeByCurrentUser],
                                       kHMRecipeAttributesIsMadeByCurrentUserKey,
                                       nil];
    [self setAttributes:attributes forRecipe:recipe];
}


- (NSNumber *)saveCountForRecipe:(PFObject *)recipe {
    NSDictionary *attributes = [self attributesForRecipe:recipe];
    NSNumber *saveCount = [attributes objectForKey:kHMRecipeAttributesSaveCountKey];
    if (saveCount) {
        return saveCount;
    }
    return [NSNumber numberWithInt:0];
}

- (NSNumber *)photoCountForRecipe:(PFObject *)recipe {
    NSDictionary *attributes = [self attributesForRecipe:recipe];
    NSNumber *photoCount = [attributes objectForKey:kHMRecipeAttributesPhotoCountKey];
    if (photoCount) {
        return photoCount;
    }
    return [NSNumber numberWithInt:0];
}

- (void)setSaveCountForRecipe:(PFObject *)recipe count:(NSInteger)count {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForRecipe:recipe]];
    
    [attributes setObject:[NSNumber numberWithInteger:count] forKey:kHMRecipeAttributesSaveCountKey];
    [self setAttributes:attributes forRecipe:recipe];
}

- (void)setPhotoCountForRecipe:(PFObject *)recipe count:(NSInteger)count {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForRecipe:recipe]];
    
    [attributes setObject:[NSNumber numberWithInteger:count] forKey:kHMRecipeAttributesPhotoCountKey];
    [self setAttributes:attributes forRecipe:recipe];
}

- (NSNumber *)commentCountForRecipe:(PFObject *)recipe {
    NSDictionary *attributes = [self attributesForRecipe:recipe];
    NSNumber *commentCount = [attributes objectForKey:kHMRecipeAttributesCommentCountKey];
    if (commentCount) {
        return commentCount;
    }
    return [NSNumber numberWithInt:0];
}

/*
- (NSArray *)saversForRecipe:(PFObject *)recipe {
    NSDictionary *attributes = [self attributesForRecipe:recipe];
    if (attributes) {
        return [attributes objectForKey:kHMRecipeAttributesSaversKey];
    }
    return [NSArray array];
}


- (NSArray *)makersForRecipe:(PFObject *)recipe {
    NSDictionary *attributes = [self attributesForRecipe:recipe];
    if (attributes) {
        return [attributes objectForKey:kHMRecipeAttributesMakersKey];
    }
    return [NSArray array];
}

- (NSArray *)commentersForRecipe:(PFObject *)recipe {
    NSDictionary *attributes = [self attributesForRecipe:recipe];
    if (attributes) {
        return [attributes objectForKey:kHMRecipeAttributesCommentersKey];
    }
    return [NSArray array];
}
 */

- (void)setRecipeIsSavedByCurrentUser:(PFObject *)recipe saved:(BOOL)saved {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForRecipe:recipe]];
    [attributes setObject:[NSNumber numberWithBool:saved] forKey:kHMRecipeAttributesIsSavedByCurrentUserKey];
    [self setAttributes:attributes forRecipe:recipe];
}

- (void)setRecipeIsMadeByCurrentUser:(PFObject *)recipe made:(BOOL)made {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForRecipe:recipe]];
    [attributes setObject:[NSNumber numberWithBool:made] forKey:kHMRecipeAttributesIsMadeByCurrentUserKey];
    [self setAttributes:attributes forRecipe:recipe];
}

- (BOOL)isSavedByCurrentUser:(PFObject *)recipe {
    NSDictionary *attributes = [self attributesForRecipe:recipe];
    if (attributes) {
        return [[attributes objectForKey:kHMRecipeAttributesIsSavedByCurrentUserKey] boolValue];
    }
    return NO;
}

- (BOOL)isMadeByCurrentUser:(PFObject *)recipe {
    NSDictionary *attributes = [self attributesForRecipe:recipe];
    if (attributes) {
        return [[attributes objectForKey:kHMRecipeAttributesIsMadeByCurrentUserKey] boolValue];
    }
    return NO;
}

- (void)incrementSaverCountForRecipe:(PFObject *)recipe {
    NSNumber *saveCount = [NSNumber numberWithInt:[[self saveCountForRecipe:recipe] intValue] + 1];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForRecipe:recipe]];
    [attributes setObject:saveCount forKey:kHMRecipeAttributesSaveCountKey];
    [self setAttributes:attributes forRecipe:recipe];
}

- (void)decrementSaverCountForRecipe:(PFObject *)recipe {
    NSNumber *saveCount = [NSNumber numberWithInt:[[self saveCountForRecipe:recipe] intValue] - 1];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForRecipe:recipe]];
    [attributes setObject:saveCount forKey:kHMRecipeAttributesSaveCountKey];
    [self setAttributes:attributes forRecipe:recipe];
}

- (void)incrementMakerCountForRecipe:(PFObject *)recipe {
    NSNumber *makeCount = [NSNumber numberWithInt:[[self photoCountForRecipe:recipe] intValue] + 1];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForRecipe:recipe]];
    [attributes setObject:makeCount forKey:kHMRecipeAttributesMakeCountKey];
    [self setAttributes:attributes forRecipe:recipe];
}

- (void)decrementMakerCountForRecipe:(PFObject *)recipe {
    NSNumber *makeCount = [NSNumber numberWithInt:[[self photoCountForRecipe:recipe] intValue] - 1];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForRecipe:recipe]];
    [attributes setObject:makeCount forKey:kHMRecipeAttributesMakeCountKey];
    [self setAttributes:attributes forRecipe:recipe];
}

- (void)incrementCommentCountForRecipe:(PFObject *)recipe {
    NSNumber *commentCount = [NSNumber numberWithInt:[[self commentCountForRecipe:recipe] intValue] + 1];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForRecipe:recipe]];
    [attributes setObject:commentCount forKey:kHMRecipeAttributesCommentCountKey];
    [self setAttributes:attributes forRecipe:recipe];
}

- (void)decrementCommentCountForRecipe:(PFObject *)recipe {
    NSNumber *commentCount = [NSNumber numberWithInt:[[self commentCountForRecipe:recipe] intValue] - 1];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForRecipe:recipe]];
    [attributes setObject:commentCount forKey:kHMRecipeAttributesCommentCountKey];
    [self setAttributes:attributes forRecipe:recipe];
}

- (NSDictionary *)attributesForUser:(PFUser *)user {
    NSString *key = [self keyForUser:user];
    return [self.cache objectForKey:key];
}

- (NSNumber *)recipeCountForUser:(PFUser *)user {
    NSDictionary *attributes = [self attributesForUser:user];
    if (attributes) {
        NSNumber *recipeCount = [attributes objectForKey:kHMUserAttributesRecipeCountKey];
        if (recipeCount) {
            return recipeCount;
        }
    }
    
    return [NSNumber numberWithInt:0];
}

- (void)setRecipeCount:(NSNumber *)count user:(PFUser *)user {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForUser:user]];
    [attributes setObject:count forKey:kHMUserAttributesRecipeCountKey];
    [self setAttributes:attributes forUser:user];
}

- (void)setFacebookFriends:(NSArray *)friends {
    NSString *key = kHMUserDefaultsCacheFacebookFriendsKey;
    [self.cache setObject:friends forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:friends forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)facebookFriends {
    NSString *key = kHMUserDefaultsCacheFacebookFriendsKey;
    if ([self.cache objectForKey:key]) {
        return [self.cache objectForKey:key];
    }
    
    NSArray *friends = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (friends) {
        [self.cache setObject:friends forKey:key];
    }
    
    return friends;
}


#pragma mark - ()

- (NSDictionary *)attributesForRecipe:(PFObject *)recipe {
    NSString *key = [self keyForRecipe:recipe];
    return [self.cache objectForKey:key];
}

- (void)setAttributes:(NSDictionary *)attributes forRecipe:(PFObject *)recipe {
    NSString *key = [self keyForRecipe:recipe];
    [self.cache setObject:attributes forKey:key];
}

- (void)setAttributes:(NSDictionary *)attributes forUser:(PFUser *)user {
    NSString *key = [self keyForUser:user];
    [self.cache setObject:attributes forKey:key];
}

- (NSString *)keyForRecipe:(PFObject *)recipe {
    return [NSString stringWithFormat:@"recipe_%@", [recipe objectId]];
}

- (NSString *)keyForUser:(PFUser *)user {
    return [NSString stringWithFormat:@"user_%@", [user objectId]];
}


@end
