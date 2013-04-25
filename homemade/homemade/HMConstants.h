//
//  HMConstants.h
//  homemade
//
//  Created by Guan Guan on 4/13/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <Foundation/Foundation.h>



#pragma mark - NSUserDefaults
extern NSString *const kHMUserDefaultsActivityFeedViewControllerLastRefreshKey;
extern NSString *const kHMUserDefaultsCacheFacebookFriendsKey;

#pragma mark - PFObject Recipe Class
// Class key
extern NSString *const kHMRecipeClassKey;

// Field keys
extern NSString *const kHMRecipeTitleKey;
extern NSString *const kHMRecipeOverviewKey;
extern NSString *const kHMRecipeUserKey;
extern NSString *const kHMRecipePhotoKey;
extern NSString *const kHMRecipeDifficultyKey;
extern NSString *const kHMRecipeIngredientsKey;
extern NSString *const kHMRecipeStepsKey;
extern NSString *const kHMRecipeTipsKey;

#pragma mark - Cached Recipe Attributes
// keys
extern NSString *const kHMRecipeAttributesIsSavedByCurrentUserKey;
extern NSString *const kHMRecipeAttributesSaveCountKey;
extern NSString *const kHMRecipeAttributesSaversKey;
extern NSString *const kHMRecipeAttributesIsMadeByCurrentUserKey;
extern NSString *const kHMRecipeAttributesMakeCountKey;
extern NSString *const kHMRecipeAttributesMakersKey;
extern NSString *const kHMRecipeAttributesCommentCountKey;
extern NSString *const kHMRecipeAttributesCommentersKey;

#pragma mark - Cached User Attributes
// keys
extern NSString *const kHMUserAttributesRecipeCountKey;
extern NSString *const kHMUserAttributesMadeCountKey;
extern NSString *const kHMUserAttributesSaveCountKey;
extern NSString *const kHMUserAttributesIsFollowedByCurrentUserKey;


#pragma mark - TMCache keys
extern NSString *const kHMColorSuffixKey;
